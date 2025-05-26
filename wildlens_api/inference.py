import torch
from torchvision import models, transforms
from PIL import Image
import os
import torch.nn as nn

# Définition CBAM identique à ton modèle d'entraînement
class ChannelAttention(nn.Module):
    def __init__(self, in_planes, ratio=16):
        super(ChannelAttention, self).__init__()
        self.avg_pool = nn.AdaptiveAvgPool2d(1)
        self.max_pool = nn.AdaptiveMaxPool2d(1)
        self.fc1 = nn.Conv2d(in_planes, in_planes // ratio, 1, bias=False)
        self.relu = nn.ReLU()
        self.fc2 = nn.Conv2d(in_planes // ratio, in_planes, 1, bias=False)
        self.sigmoid = nn.Sigmoid()

    def forward(self, x):
        avg_out = self.fc2(self.relu(self.fc1(self.avg_pool(x))))
        max_out = self.fc2(self.relu(self.fc1(self.max_pool(x))))
        out = avg_out + max_out
        return self.sigmoid(out)

class SpatialAttention(nn.Module):
    def __init__(self, kernel_size=7):
        super(SpatialAttention, self).__init__()
        self.conv = nn.Conv2d(2, 1, kernel_size, padding=kernel_size//2, bias=False)
        self.sigmoid = nn.Sigmoid()

    def forward(self, x):
        avg_out = torch.mean(x, dim=1, keepdim=True)
        max_out, _ = torch.max(x, dim=1, keepdim=True)
        x = torch.cat([avg_out, max_out], dim=1)
        x = self.conv(x)
        return self.sigmoid(x)

class CBAM(nn.Module):
    def __init__(self, in_planes, ratio=16, kernel_size=7):
        super(CBAM, self).__init__()
        self.ca = ChannelAttention(in_planes, ratio)
        self.sa = SpatialAttention(kernel_size)

    def forward(self, x):
        x = x * self.ca(x)
        x = x * self.sa(x)
        return x

# Reconstruction du modèle exactement comme à l'entraînement
class AnimalClassifier(nn.Module):
    def __init__(self, num_classes=26):
        super(AnimalClassifier, self).__init__()
        base_model = models.efficientnet_b3(weights=None)
        in_planes = base_model.features[-1][0].out_channels
        self.features = nn.Sequential(
            *list(base_model.features),
            CBAM(in_planes)
        )
        self.avgpool = base_model.avgpool
        self.classifier = nn.Sequential(
            nn.Linear(base_model.classifier[1].in_features, 256),
            nn.BatchNorm1d(256),
            nn.ReLU(),
            nn.Dropout(0.4),
            nn.Linear(256, 128),
            nn.BatchNorm1d(128),
            nn.ReLU(),
            nn.Dropout(0.3),
            nn.Linear(128, num_classes)
        )

    def forward(self, x):
        x = self.features(x)
        x = self.avgpool(x)
        x = torch.flatten(x, 1)
        x = self.classifier(x)
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
MODEL_PATH = os.getenv("MODEL_PATH", "./animal_classifier_model.pth")
model = None

def load_model(model_path=MODEL_PATH):
    global model
    if model is None:
        m = AnimalClassifier(num_classes=len(CLASS_NAMES))
        state_dict = torch.load(model_path, map_location=torch.device("cpu"))
        m.load_state_dict(state_dict)
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

