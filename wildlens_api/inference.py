"model toutes les fonctions"
import torch
from torchvision import models, transforms
from PIL import Image
import os
import torch.nn as nn
from cbam import CBAM

class SimpleClassifier(nn.Module):
    def __init__(self, num_classes=26):
        super(SimpleClassifier, self).__init__()
        weights = models.ResNet18_Weights.DEFAULT
        self.resnet = models.resnet18(weights=weights)
        num_features = self.resnet.fc.in_features
        self.cbam = CBAM(512)  # ResNet18's last conv layer has 512 channels
        self.resnet.fc = nn.Linear(num_features, num_classes)

    def forward(self, x):
        x = self.resnet.conv1(x)
        x = self.resnet.bn1(x)
        x = self.resnet.relu(x)
        x = self.resnet.maxpool(x)

        x = self.resnet.layer1(x)
        x = self.resnet.layer2(x)
        x = self.resnet.layer3(x)
        x = self.resnet.layer4(x)

        x = self.cbam(x)
        x = self.resnet.avgpool(x)
        x = torch.flatten(x, 1)
        x = self.resnet.fc(x)
        return x

# Liste des classes
CLASS_NAMES = [
    'bernache_du_canada', 'castor', 'cerf_mulet', 'chat', 'cheval', 'chien',
    'coyote', 'dindon_sauvage', 'ecureuil', 'ecureuil_gris_occidental',
    'elephant', 'lapin', 'loup', 'loutre_de_riviere', 'lynx', 'lynx_roux',
    'mouffette', 'ours', 'ours_noir', 'puma', 'rat', 'raton_laveur', 'renard',
    'renard_gris', 'souris', 'vison_americain'
]

# Chargement du modèle entraîné une seule fois au niveau du module
MODEL_PATH = os.getenv("MODEL_PATH", "./best_model.pth")
model = None

def load_model(model_path=MODEL_PATH):
    global model
    if model is None:
        m = SimpleClassifier(num_classes=len(CLASS_NAMES))
        if os.path.exists(model_path):
            try:
                state_dict = torch.load(model_path, map_location=torch.device("cpu"))
                # Supprimer les préfixes 'module.' du state_dict si nécessaire
                new_state_dict = {}
                for k, v in state_dict.items():
                    if k.startswith('module.'):
                        k = k[7:]  # Supprimer 'module.'
                    new_state_dict[k] = v
                m.load_state_dict(new_state_dict, strict=False)
            except Exception as e:
                print(f"Erreur lors du chargement du modèle : {str(e)}")
                # Utiliser le modèle pré-entraîné par défaut
                pass
        m.eval()
        model = m
    return model

# Prétraitement
preprocess = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225]),
])

# Prédiction
def predict_image(image_path, model=None):
    if model is None:
        model = load_model()
    try:
        image = Image.open(image_path).convert("RGB")
        input_tensor = preprocess(image).unsqueeze(0)
        with torch.no_grad():
            output = model(input_tensor)
            probabilities = torch.nn.functional.softmax(output[0], dim=0)
            confidence, predicted_idx = torch.max(probabilities, 0)
            return {
                "animal_name": CLASS_NAMES[predicted_idx.item()],
                "confidence": float(confidence.item()),
                "details": None
            }
    except Exception as e:
        print(f"Erreur lors de la prédiction : {str(e)}")
        return {
            "animal_name": "inconnu",
            "confidence": 0.0,
            "details": str(e)
        }

