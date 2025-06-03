import os
import torch
import torch.nn as nn
from torchvision import transforms
from PIL import Image
from efficientnet_pytorch import EfficientNet

# === CBAM ===
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

# === Modèle ===
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

# === Mapping des classes ===
CLASS_MAPPING = {
    0: 'bernache_du_canada', 1: 'castor', 2: 'cerf_mulet', 3: 'chat', 4: 'cheval', 5: 'chien',
    6: 'coyote', 7: 'dindon_sauvage', 8: 'ecureuil', 9: 'ecureuil_gris_occidental', 10: 'elephant',
    11: 'lapin', 12: 'loup', 13: 'loutre_de_riviere', 14: 'lynx', 15: 'lynx_roux', 16: 'mouffette',
    17: 'ours', 18: 'ours_noir', 19: 'puma', 20: 'rat', 21: 'raton_laveur', 22: 'renard',
    23: 'renard_gris', 24: 'souris', 25: 'vison_americain'
}

# === Configurations ===
device = torch.device("mps" if torch.backends.mps.is_available() else "cuda" if torch.cuda.is_available() else "cpu")

# === Transformation image ===
image_transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(mean=[0.485, 0.456, 0.406],
                         std=[0.229, 0.224, 0.225]),
])

# === Chargement du modèle ===
model = EfficientNetWithCBAM(num_classes=len(CLASS_MAPPING))
model.load_state_dict(torch.load("model_weights.pth", map_location=device))
model.to(device)
model.eval()

# === Prédiction ===
def predict(image_path):
    image = Image.open(image_path).convert('RGB')
    image = image_transform(image).unsqueeze(0).to(device)

    with torch.no_grad():
        outputs = model(image)
        _, predicted = torch.max(outputs, 1)
        class_idx = predicted.item()
        return CLASS_MAPPING[class_idx]

if __name__ == "__main__":
    import argparse

    parser = argparse.ArgumentParser(description="Prédiction d'espèce à partir d'une image")
    parser.add_argument("image_path", type=str, help="Chemin vers l'image à prédire")
    args = parser.parse_args()

    prediction = predict(args.image_path)
    print(f"Espèce prédite : {prediction}")
