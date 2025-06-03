"main"
from fastapi import FastAPI, Depends, HTTPException, status, UploadFile, File
from fastapi.middleware.cors import CORSMiddleware
from fastapi.security import OAuth2PasswordRequestForm
from sqlalchemy.orm import Session
from typing import List
from database import engine, get_db
from models import Base
import schemas
import crud
import auth
import inference
import shutil
import os
import cloudinary
import cloudinary.uploader
from cloudinary.utils import cloudinary_url
import models

Base.metadata.create_all(bind=engine)

app = FastAPI(title="WildLens API")

# CORS for Flutter frontend
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

AVATAR_UPLOAD_DIR = os.getenv("AVATAR_UPLOAD_DIR", "static/avatars")
os.makedirs(AVATAR_UPLOAD_DIR, exist_ok=True)

# Cloudinary configuration (set these as environment variables in production/Docker):
# CLOUDINARY_CLOUD_NAME, CLOUDINARY_API_KEY, CLOUDINARY_API_SECRET
cloudinary.config(
    cloud_name = os.getenv("CLOUDINARY_CLOUD_NAME", "dhbuz6quf"),
    api_key = os.getenv("CLOUDINARY_API_KEY", "622983176859212"),
    api_secret = os.getenv("CLOUDINARY_API_SECRET", "5yJlPZECyQQdRyVuyZHplu_ttQ4"),
    secure=True
)

# --- AUTH ---
@app.post("/auth/register", response_model=schemas.UserOut)
def register(user: schemas.UserCreate, db: Session = Depends(get_db)):
    if crud.get_user_by_email(db, user.email):
        raise HTTPException(status_code=400, detail="Email already registered")
    return crud.create_user(db, user)

@app.post("/auth/login", response_model=schemas.Token)
def login(form_data: OAuth2PasswordRequestForm = Depends(), db: Session = Depends(get_db)):
    user = auth.authenticate_user(db, form_data.username, form_data.password)
    if not user:
        raise HTTPException(status_code=401, detail="Incorrect email or password")
    token = auth.create_access_token({"sub": str(user.id)})
    return {"access_token": token, "token_type": "bearer"}

# --- USER PROFILE ---
@app.get("/users/me", response_model=schemas.UserOut)
def get_me(current_user=Depends(auth.get_current_user), db: Session = Depends(get_db)):
    return current_user

@app.put("/users/me", response_model=schemas.UserOut)
def update_me(update: schemas.UserCreate, current_user=Depends(auth.get_current_user), db: Session = Depends(get_db)):
    return crud.update_user(db, current_user.id, update)

@app.put("/users/me/avatar")
async def upload_avatar(
    file: UploadFile = File(...),
    current_user=Depends(auth.get_current_user),
    db: Session = Depends(get_db),
):
    try:
        # Validate file type and size
        if not file.content_type.startswith("image/"):
            raise HTTPException(status_code=400, detail="Invalid file type")
        contents = await file.read()
        if len(contents) > 5 * 1024 * 1024:  # 5MB limit
            raise HTTPException(status_code=400, detail="File too large")
        # Upload to Cloudinary
        upload_result = cloudinary.uploader.upload(
            contents,
            public_id=f"user_{current_user.id}_avatar",
            folder="avatars",
            overwrite=True,
            resource_type="image"
        )
        avatar_url = upload_result["secure_url"]
        # Update user in DB
        current_user.avatar = avatar_url
        db.commit()
        db.refresh(current_user)
        return {"avatar_url": avatar_url}
    except Exception as e:
        import traceback
        print("[Avatar Upload Error]", traceback.format_exc())
        raise HTTPException(status_code=400, detail=f"Avatar upload failed: {str(e)}")

# --- ANIMALS ---
@app.get("/animals/", response_model=List[schemas.AnimalOut])
def get_animals(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return crud.get_animals(db, skip=skip, limit=limit)

@app.post("/animals/", response_model=schemas.AnimalOut)
def create_animal(animal: schemas.AnimalCreate, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.create_animal(db, animal)

@app.get("/animals/{animal_id}", response_model=schemas.AnimalOut)
def get_animal(animal_id: int, db: Session = Depends(get_db)):
    animal = crud.get_animal(db, animal_id)
    if not animal:
        raise HTTPException(status_code=404, detail="Animal not found")
    return animal

@app.put("/animals/{animal_id}", response_model=schemas.AnimalOut)
def update_animal(animal_id: int, animal: schemas.AnimalCreate, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.update_animal(db, animal_id, animal)

@app.delete("/animals/{animal_id}")
def delete_animal(animal_id: int, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.delete_animal(db, animal_id)

# --- ECOSYSTEMS ---
@app.get("/ecosystems/", response_model=List[schemas.EcosystemOut])
def get_ecosystems(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return crud.get_ecosystems(db, skip=skip, limit=limit)

@app.post("/ecosystems/", response_model=schemas.EcosystemOut)
def create_ecosystem(ecosystem: schemas.EcosystemCreate, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.create_ecosystem(db, ecosystem)

@app.get("/ecosystems/{ecosystem_id}", response_model=schemas.EcosystemOut)
def get_ecosystem(ecosystem_id: int, db: Session = Depends(get_db)):
    eco = crud.get_ecosystem(db, ecosystem_id)
    if not eco:
        raise HTTPException(status_code=404, detail="Ecosystem not found")
    return eco

@app.put("/ecosystems/{ecosystem_id}", response_model=schemas.EcosystemOut)
def update_ecosystem(ecosystem_id: int, ecosystem: schemas.EcosystemCreate, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.update_ecosystem(db, ecosystem_id, ecosystem)

@app.delete("/ecosystems/{ecosystem_id}")
def delete_ecosystem(ecosystem_id: int, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.delete_ecosystem(db, ecosystem_id)

# --- SCANS ---
@app.post("/scans/", response_model=schemas.ScanOut)
def create_scan(scan: schemas.ScanCreate, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.create_scan(db, scan)

@app.get("/scans/", response_model=List[schemas.ScanOut])
def get_scans(skip: int = 0, limit: int = 100, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    print('current_user', current_user)
    return crud.get_scans_by_user(db, current_user.id, skip=skip, limit=limit)

@app.get("/scans/{scan_id}", response_model=schemas.ScanOut)
def get_scan(scan_id: int, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    scan = crud.get_scan(db, scan_id)
    if not scan or scan.user_id != current_user.id:
        raise HTTPException(status_code=404, detail="Scan not found")
    return scan

@app.delete("/scans/{scan_id}")
def delete_scan(scan_id: int, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.delete_scan(db, scan_id, current_user.id)

# --- FAVORITES ---
@app.post("/favorites/", response_model=schemas.FavoriteOut)
def add_favorite(favorite: schemas.FavoriteCreate, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.add_favorite(db, current_user.id, favorite.animal_id)

@app.delete("/favorites/{animal_id}")
def remove_favorite(animal_id: int, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.remove_favorite(db, current_user.id, animal_id)

@app.get("/favorites/", response_model=List[schemas.AnimalOut])
def list_favorites(db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.get_favorites(db, current_user.id)

# --- ACTIVITY HISTORY ---
@app.get("/history/", response_model=List[schemas.ActivityHistoryOut])
def get_history(db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.get_history(db, current_user.id)

@app.post("/history/", response_model=schemas.ActivityHistoryOut)
def add_history(activity: schemas.ActivityHistoryCreate, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.add_history(db, current_user.id, activity)

@app.delete("/history/{activity_id}")
def delete_history(activity_id: int, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.delete_history(db, activity_id, current_user.id)

# --- BADGES ---
@app.get("/badges/", response_model=List[schemas.BadgeOut])
def get_badges(db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.get_badges(db, current_user.id)

@app.post("/badges/", response_model=schemas.BadgeOut)
def add_badge(badge: schemas.BadgeCreate, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.add_badge(db, current_user.id, badge)

@app.delete("/badges/{badge_id}")
def remove_badge(badge_id: int, db: Session = Depends(get_db), current_user=Depends(auth.get_current_user)):
    return crud.remove_badge(db, current_user.id, badge_id)

# --- FOOTPRINT ANALYSIS ---
#@app.post("/analyze/footprint", response_model=schemas.FootprintAnalysisResult)
#def analyze_footprint(file: UploadFile = File(...), db: Session = Depends(get_db)):
#    temp_path = f"/tmp/{file.filename}"
#    with open(temp_path, "wb") as buffer:
#        shutil.copyfileobj(file.file, buffer)
#    result = inference.predict_image(temp_path)
#    os.remove(temp_path)
    # Cherche l'animal dans la base à partir du nom prédit
#    animal = db.query(models.Animal).filter(models.Animal.name == result["animal_name"]).first()
#    animal_id = animal.id if animal else None
#    result["animal_id"] = animal_id
#    return result

@app.post("/analyze/image", response_model=schemas.ScanOut)
async def analyze_image(
    file: UploadFile = File(...),
    db: Session = Depends(get_db),
    current_user=Depends(auth.get_current_user)
):
    try:
        # Sauvegarder temporairement l'image
        temp_path = f"temp_{file.filename}"
        with open(temp_path, "wb") as buffer:
            shutil.copyfileobj(file.file, buffer)

        # Analyser l'image
        result = inference.predict_image(temp_path)

        # Uploader l'image sur Cloudinary
        upload_result = cloudinary.uploader.upload(
            temp_path,
            folder="scans",
            resource_type="image"
        )

        # Supprimer le fichier temporaire
        os.remove(temp_path)

        # Cherche l'animal dans la base à partir du nom prédit
        animal = db.query(models.Animal).filter(models.Animal.name == result["animal_name"]).first()
        animal_id = animal.id if animal else None
        if animal_id is None:
            print(f"[WARNING] No animal found for predicted name: {result['animal_name']}")
        
        print(f"[INFO] Animal ID: {animal_id} , type: {type(animal_id)}")

        # Créer un nouveau scan dans la base de données
        scan_data = schemas.ScanCreate(
            image_url=upload_result["secure_url"],
            animal_name=result["animal_name"],
            confidence=result["confidence"],
            latitude=None,  # À implémenter plus tard
            longitude=None,  # À implémenter plus tard
            user_id=current_user.id,
            animal_id=animal_id
        )
        scan = crud.create_scan(db, scan_data, current_user.id)
        return scan

    except Exception as e:
        import traceback
        print("[Scan Error]", traceback.format_exc())
        if os.path.exists(temp_path):
            os.remove(temp_path)
        raise HTTPException(status_code=400, detail=f"Scan failed: {str(e)}")

@app.post("/test/analyze-image")
async def test_analyze_image(
    file: UploadFile = File(...)
):
    try:
        # Validate file type and size
        if not file.content_type.startswith("image/"):
            raise HTTPException(status_code=400, detail="Invalid file type")
        
        # Save the file temporarily
        temp_path = f"temp_{file.filename}"
        try:
            with open(temp_path, "wb") as buffer:
                shutil.copyfileobj(file.file, buffer)
            
            # Analyze the image
            result = inference.predict_image(temp_path)
            return result
            
        finally:
            if os.path.exists(temp_path):
                os.remove(temp_path)
                
    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
