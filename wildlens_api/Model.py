import os
import numpy as np
import torch
import torch.nn as nn
import torch.optim as optim
from torch.utils.data import Dataset, DataLoader
from torchvision import transforms
from efficientnet_pytorch import EfficientNet
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.metrics import classification_report, confusion_matrix, f1_score
from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from datetime import datetime
import logging
import argparse
from tqdm import tqdm
import h5py
import itertools

# Configuration du logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s'
)

# Vérification du dispositif (MPS pour Mac M2 Pro, sinon CPU)
device = torch.device("mps" if torch.backends.mps.is_available() else "cpu")
logging.info(f"Utilisation du dispositif : {device}")

# Chargement des données avec vérification des fichiers
def load_data(train_dir, test_dir):
    required_files = [
        ('X_train.npy', 'X_train', train_dir),
        ('y_train.npy', 'y_train', train_dir),
        ('X_test.npy', 'X_test', test_dir),
        ('y_test.npy', 'y_test', test_dir),
        ('species_mapping.txt', 'species_mapping', test_dir)
    ]
    
    # Vérifier si les fichiers équilibrés existent
    balanced_files = [
        ('X_train_balanced.npy', 'X_train', train_dir),
        ('y_train_balanced.npy', 'y_train', train_dir)
    ]
    
    data = {}
    for file_name, data_type, dir_path in required_files:
        file_path = os.path.join(dir_path, file_name)
        
        # Si le fichier est X_train ou y_train, vérifier d'abord la version équilibrée
        if data_type in ['X_train', 'y_train']:
            balanced_file_path = os.path.join(train_dir, file_name.replace('X_train', 'X_train_balanced').replace('y_train', 'y_train_balanced'))
            if os.path.exists(balanced_file_path):
                file_path = balanced_file_path
                logging.info(f"Fichier équilibré trouvé : {file_path}")
        
        if not os.path.exists(file_path):
            logging.error(f"Fichier manquant : {file_path}")
            raise FileNotFoundError(f"Fichier manquant : {file_path}")
        
        if file_name.endswith('.npy'):
            data[data_type] = np.load(file_path, mmap_mode='r')
            logging.info(f"Chargé {data_type} : {data[data_type].shape}")
        else:
            species_mapping = {}
            with open(file_path, 'r') as f:
                for line in f:
                    specie, idx = line.strip().split(': ')
                    species_mapping[specie] = int(idx)
            data[data_type] = species_mapping
            logging.info(f"Mapping des classes chargé : {species_mapping}")
    
    return data['X_train'], data['y_train'], data['X_test'], data['y_test'], data['species_mapping']

# Transformations des données
train_transform = transforms.Compose([
    transforms.ToPILImage(),
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])
val_transform = transforms.Compose([
    transforms.ToPILImage(),
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
])

# Dataset personnalisé
class CustomDataset(Dataset):
    def __init__(self, X, y, transform=None):
        self.X = X
        self.y = y
        self.transform = transform

    def __len__(self):
        return len(self.X)

    def __getitem__(self, idx):
        image = self.X[idx]
        label = self.y[idx]
        if self.transform:
            image = self.transform(image)
        return image, label

# Fonction pour plotter la matrice de confusion
def plot_confusion_matrix(cm, classes, normalize=False, title='Matrice de Confusion', cmap=plt.cm.Blues):
    plt.figure(figsize=(10, 10))
    plt.imshow(cm, interpolation='nearest', cmap=cmap)
    plt.title(title)
    plt.colorbar()
    tick_marks = np.arange(len(classes))
    plt.xticks(tick_marks, classes, rotation=45)
    plt.yticks(tick_marks, classes)
    if normalize:
        cm = cm.astype('float') / cm.sum(axis=1)[:, np.newaxis]
        print("Matrice de confusion normalisée")
    else:
        print('Matrice de confusion non normalisée')
    print(cm)
    thresh = cm.max() / 2.
    for i, j in itertools.product(range(cm.shape[0]), range(cm.shape[1])):
        plt.text(j, i, format(cm[i, j], '.2f') if normalize else str(cm[i, j]),
                 horizontalalignment="center",
                 color="white" if cm[i, j] > thresh else "black")
    plt.tight_layout()
    plt.ylabel('Étiquette vraie')
    plt.xlabel('Étiquette prédite')
    plt.savefig(os.path.join(results_dir, 'confusion_matrix.png'))
    plt.close()

# Définition du modèle avec CBAM
class CBAM(nn.Module):
    def __init__(self, channels, reduction_ratio=16):
        super(CBAM, self).__init__()
        self.channel_attention = nn.Sequential(
            nn.AdaptiveAvgPool2d(1),
            nn.Conv2d(channels, channels // reduction_ratio, 1),
            nn.ReLU(),
            nn.Conv2d(channels // reduction_ratio, channels, 1),
            nn.Sigmoid()
        )
        self.spatial_attention = nn.Sequential(
            nn.Conv2d(2, 1, kernel_size=7, padding=3),
            nn.Sigmoid()
        )

    def forward(self, x):
        channel_att = self.channel_attention(x)
        x = x * channel_att
        max_pool = torch.max(x, dim=1, keepdim=True)[0]
        avg_pool = torch.mean(x, dim=1, keepdim=True)
        spatial_input = torch.cat([max_pool, avg_pool], dim=1)
        spatial_att = self.spatial_attention(spatial_input)
        x = x * spatial_att
        return x

class EfficientNetWithCBAM(nn.Module):
    def __init__(self, num_classes=26):
        super(EfficientNetWithCBAM, self).__init__()
        self.efficientnet = EfficientNet.from_pretrained('efficientnet-b0')
        for param in self.efficientnet.parameters():
            param.requires_grad = False
        for param in self.efficientnet._conv_head.parameters():
            param.requires_grad = True
        for param in self.efficientnet._bn1.parameters():
            param.requires_grad = True
        for param in self.efficientnet._fc.parameters():
            param.requires_grad = True
        self.cbam = CBAM(channels=1280)
        self.classifier = nn.Sequential(
            nn.Linear(1280, 512),
            nn.BatchNorm1d(512),
            nn.ReLU(),
            nn.Dropout(0.5),
            nn.Linear(512, num_classes)
        )

    def forward(self, x):
        x = self.efficientnet.extract_features(x)
        x = self.cbam(x)
        x = self.efficientnet._avg_pooling(x)
        x = x.flatten(start_dim=1)
        x = self.efficientnet._dropout(x)
        x = self.classifier(x)
        return x

# Fonction pour sauvegarder les poids
def save_weights(model, output_dir):
    weights_path = os.path.join(output_dir, "model_weights.pth")
    torch.save(model.state_dict(), weights_path)
    logging.info(f"Poids du modèle sauvegardés dans {weights_path}")

# Entraînement
def train_model(model, train_loader, val_loader, criterion, optimizer, scheduler, epochs=20):
    best_val_loss = float('inf')
    patience = 5
    patience_counter = 0
    train_losses, val_losses = [], []
    train_accuracies, val_accuracies = [], []

    for epoch in range(epochs):
        model.train()
        running_loss = 0.0
        correct = 0
        total = 0
        for images, labels in tqdm(train_loader, desc=f"Époque {epoch+1}/{epochs} - Entraînement"):
            images, labels = images.to(device), labels.to(device)
            optimizer.zero_grad()
            outputs = model(images)
            loss = criterion(outputs, labels)
            loss.backward()
            optimizer.step()
            running_loss += loss.item()
            _, predicted = torch.max(outputs.data, 1)
            total += labels.size(0)
            correct += (predicted == labels).sum().item()
        
        train_loss = running_loss / len(train_loader)
        train_acc = 100 * correct / total
        train_losses.append(train_loss)
        train_accuracies.append(train_acc)

        model.eval()
        val_loss = 0.0
        correct = 0
        total = 0
        with torch.no_grad():
            for images, labels in tqdm(val_loader, desc=f"Époque {epoch+1}/{epochs} - Validation"):
                images, labels = images.to(device), labels.to(device)
                outputs = model(images)
                loss = criterion(outputs, labels)
                val_loss += loss.item()
                _, predicted = torch.max(outputs.data, 1)
                total += labels.size(0)
                correct += (predicted == labels).sum().item()
        
        val_loss = val_loss / len(val_loader)
        val_acc = 100 * correct / total
        val_losses.append(val_loss)
        val_accuracies.append(val_acc)
        scheduler.step(val_loss)

        logging.info(f"Époque {epoch+1}/{epochs} - Perte train : {train_loss:.4f}, Précision train : {train_acc:.2f}%")
        logging.info(f"Perte val : {val_loss:.4f}, Précision val : {val_acc:.2f}%")

        if val_loss < best_val_loss:
            best_val_loss = val_loss
            patience_counter = 0
            torch.save(model.state_dict(), os.path.join(results_dir, 'best_model.pth'))
            with h5py.File(os.path.join(results_dir, 'model_weights.h5'), 'w') as h5f:
                for key, value in model.state_dict().items():
                    h5f.create_dataset(key, data=value.cpu().numpy())
            save_weights(model, results_dir)
        else:
            patience_counter += 1
            if patience_counter >= patience:
                logging.info("Arrêt anticipé")
                break

    return train_losses, val_losses, train_accuracies, val_accuracies

# Évaluation
def evaluate_model(model, test_loader):
    model.eval()
    y_true, y_pred = [], []
    with torch.no_grad():
        for images, labels in tqdm(test_loader, desc="Évaluation"):
            images, labels = images.to(device), labels.to(device)
            outputs = model(images)
            _, predicted = torch.max(outputs.data, 1)
            y_true.extend(labels.cpu().numpy())
            y_pred.extend(predicted.cpu().numpy())
    
    report = classification_report(y_true, y_pred, target_names=list(species_mapping.keys()))
    cm = confusion_matrix(y_true, y_pred)
    return report, cm

# Point d'entrée principal
if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Entraînement du modèle")
    parser.add_argument('--train_dir', default='/Users/zachariekouache/Documents/codage/EPSI/MSPR/DataCleasing/DATA_OK/npy_files', help='Chemin du dossier contenant les fichiers .npy d\'entraînement')
    parser.add_argument('--test_dir', default='/Users/zachariekouache/Documents/codage/EPSI/MSPR/DataCleasing/DATA_OK/npy_files', help='Chemin du dossier contenant les fichiers .npy de test')
    args = parser.parse_args()
    
    # Chargement des données
    try:
        X_train, y_train, X_test, y_test, species_mapping = load_data(args.train_dir, args.test_dir)
    except FileNotFoundError as e:
        logging.error(str(e))
        exit(1)
    
    # Création des datasets
    train_dataset = CustomDataset(X_train, y_train, transform=train_transform)
    test_dataset = CustomDataset(X_test, y_test, transform=val_transform)
    
    # Division en train et validation
    train_size = int(0.8 * len(train_dataset))
    val_size = len(train_dataset) - train_size
    train_dataset, val_dataset = torch.utils.data.random_split(train_dataset, [train_size, val_size])
    
    # DataLoaders avec num_workers=0 pour éviter les problèmes de multiprocessing sur MPS
    train_loader = DataLoader(train_dataset, batch_size=32, shuffle=True, num_workers=0)
    val_loader = DataLoader(val_dataset, batch_size=32, shuffle=False, num_workers=0)
    test_loader = DataLoader(test_dataset, batch_size=32, shuffle=False, num_workers=0)
    
    # Initialisation du modèle
    model = EfficientNetWithCBAM(num_classes=26).to(device)
    
    # Fonction de perte et optimiseur
    criterion = nn.CrossEntropyLoss()
    optimizer = optim.Adam(filter(lambda p: p.requires_grad, model.parameters()), lr=0.001)
    scheduler = optim.lr_scheduler.ReduceLROnPlateau(optimizer, mode='min', factor=0.1, patience=5)
    
    # Génération du rapport
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    results_dir = f"results_{timestamp}"
    os.makedirs(results_dir, exist_ok=True)
    
    # Entraînement
    train_losses, val_losses, train_accuracies, val_accuracies = train_model(
        model, train_loader, val_loader, criterion, optimizer, scheduler, epochs=20
    )
    
    # Évaluation
    report, cm = evaluate_model(model, test_loader)
    
    # Plot de la matrice de confusion
    plot_confusion_matrix(cm, classes=list(species_mapping.keys()), normalize=True)
    
    # Sauvegarde des courbes d'apprentissage
    plt.figure(figsize=(12, 5))
    plt.subplot(1, 2, 1)
    plt.plot(train_losses, label='Perte train')
    plt.plot(val_losses, label='Perte val')
    plt.xlabel('Époque')
    plt.ylabel('Perte')
    plt.legend()
    plt.subplot(1, 2, 2)
    plt.plot(train_accuracies, label='Précision train')
    plt.plot(val_accuracies, label='Précision val')
    plt.xlabel('Époque')
    plt.ylabel('Précision (%)')
    plt.legend()
    plt.savefig(os.path.join(results_dir, 'learning_curves.png'))
    plt.close()
    
    # Génération du rapport PDF
    pdf_path = os.path.join(results_dir, 'report.pdf')
    c = canvas.Canvas(pdf_path, pagesize=letter)
    c.drawString(100, 750, "Rapport de Performance du Modèle")
    c.drawString(100, 730, f"Date : {timestamp}")
    c.drawString(100, 710, f"Dispositif : {device}")
    c.drawString(100, 690, f"Nombre d'époques : 20")
    c.drawString(100, 670, f"Taille du batch : 32")
    c.drawString(100, 650, "Métriques d'évaluation :")
    y_position = 630
    for line in report.split('\n'):
        c.drawString(100, y_position, line)
        y_position -= 15
        if y_position < 50:
            c.showPage()
            y_position = 750
    c.showPage()
    c.drawImage(os.path.join(results_dir, 'confusion_matrix.png'), 100, letter[1] - 400, width=400, height=400)
    c.showPage()
    c.save()
    
    logging.info(f"Rapport sauvegardé à {pdf_path}")
    logging.info(f"Courbes d'apprentissage sauvegardées à {os.path.join(results_dir, 'learning_curves.png')}")
    logging.info(f"Matrice de confusion sauvegardée à {os.path.join(results_dir, 'confusion_matrix.png')}")
    logging.info(f"Modèle sauvegardé à {os.path.join(results_dir, 'best_model.pth')}")
    logging.info(f"Poids sauvegardés à {os.path.join(results_dir, 'model_weights.h5')}")