"Interraction base de données"
from sqlalchemy.orm import Session
from models import User, Animal, Scan, Ecosystem, Favorite, ActivityHistory, Badge
from auth import get_password_hash
import schemas
from datetime import date, datetime

def create_user(db: Session, user: schemas.UserCreate):
    db_user = User(
        name=user.name,
        email=user.email,
        hashed_password=get_password_hash(user.password),
        avatar=user.avatar,
        bio=user.bio,
        favorite_biome=user.favorite_biome,
        member_since=date.today()
    )
    db.add(db_user)
    db.commit()
    db.refresh(db_user)
    return db_user

def get_user_by_email(db: Session, email: str):
    return db.query(User).filter(User.email == email).first()

def get_user(db: Session, user_id: int):
    return db.query(User).filter(User.id == user_id).first()

def create_animal(db: Session, animal: schemas.AnimalCreate):
    db_animal = Animal(**animal.model_dump())
    db.add(db_animal)
    db.commit()
    db.refresh(db_animal)
    return db_animal

def get_animals(db: Session, skip: int = 0, limit: int = 100):
    return db.query(Animal).offset(skip).limit(limit).all()

def get_animal(db: Session, animal_id: int):
    return db.query(Animal).filter(Animal.id == animal_id).first()

def create_scan(db: Session, scan: schemas.ScanCreate, user_id: int):
    db_scan = Scan(
        user_id=user_id,
        image_url=scan.image_url,
        animal_name=scan.animal_name,
        confidence=scan.confidence,
        latitude=scan.latitude,
        longitude=scan.longitude,
        details=scan.details
    )
    db.add(db_scan)
    db.commit()
    db.refresh(db_scan)
    return db_scan

def update_user(db: Session, user_id: int, update: schemas.UserCreate):
    user = db.query(User).filter(User.id == user_id).first()
    if not user:
        return None
    user.name = update.name
    user.email = update.email
    if update.password:
        user.hashed_password = get_password_hash(update.password)
    user.avatar = update.avatar
    user.bio = update.bio
    user.favorite_biome = update.favorite_biome
    db.commit()
    db.refresh(user)
    return user

def update_animal(db: Session, animal_id: int, animal: schemas.AnimalCreate):
    db_animal = db.query(Animal).filter(Animal.id == animal_id).first()
    if not db_animal:
        return None
    for field, value in animal.model_dump().items():
        setattr(db_animal, field, value)
    db.commit()
    db.refresh(db_animal)
    return db_animal

def delete_animal(db: Session, animal_id: int):
    db_animal = db.query(Animal).filter(Animal.id == animal_id).first()
    if not db_animal:
        return None
    db.delete(db_animal)
    db.commit()
    return {"ok": True}

def create_ecosystem(db: Session, eco: schemas.EcosystemCreate):
    db_eco = Ecosystem(**eco.model_dump())
    db.add(db_eco)
    db.commit()
    db.refresh(db_eco)
    return db_eco

def get_ecosystems(db: Session, skip: int = 0, limit: int = 100):
    return db.query(Ecosystem).offset(skip).limit(limit).all()

def get_ecosystem(db: Session, eco_id: int):
    return db.query(Ecosystem).filter(Ecosystem.id == eco_id).first()

def update_ecosystem(db: Session, eco_id: int, eco: schemas.EcosystemCreate):
    db_eco = db.query(Ecosystem).filter(Ecosystem.id == eco_id).first()
    if not db_eco:
        return None
    for field, value in eco.model_dump().items():
        setattr(db_eco, field, value)
    db.commit()
    db.refresh(db_eco)
    return db_eco

def delete_ecosystem(db: Session, eco_id: int):
    db_eco = db.query(Ecosystem).filter(Ecosystem.id == eco_id).first()
    if not db_eco:
        return None
    db.delete(db_eco)
    db.commit()
    return {"ok": True}

def get_scans_by_user(db: Session, user_id: int, skip: int = 0, limit: int = 100):
    return db.query(Scan).filter(Scan.user_id == user_id).offset(skip).limit(limit).all()

def get_scan(db: Session, scan_id: int):
    return db.query(Scan).filter(Scan.id == scan_id).first()

def delete_scan(db: Session, scan_id: int, user_id: int):
    scan = db.query(Scan).filter(
        Scan.id == scan_id,
        Scan.user_id == user_id
    ).first()
    if scan:
        db.delete(scan)
        db.commit()
    return scan

def add_favorite(db: Session, user_id: int, animal_id: int):
    fav = Favorite(user_id=user_id, animal_id=animal_id, created_at=datetime.utcnow())
    db.add(fav)
    db.commit()
    db.refresh(fav)
    return fav

def remove_favorite(db: Session, user_id: int, animal_id: int):
    fav = db.query(Favorite).filter(Favorite.user_id == user_id, Favorite.animal_id == animal_id).first()
    if not fav:
        return None
    db.delete(fav)
    db.commit()
    return {"ok": True}

def get_favorites(db: Session, user_id: int):
    favs = db.query(Favorite).filter(Favorite.user_id == user_id).all()
    return [db.query(Animal).filter(Animal.id == fav.animal_id).first() for fav in favs]

def get_history(db: Session, user_id: int):
    return db.query(ActivityHistory).filter(ActivityHistory.user_id == user_id).all()

def add_history(db: Session, user_id: int, activity: schemas.ActivityHistoryCreate):
    act = ActivityHistory(user_id=user_id, **activity.model_dump())
    db.add(act)
    db.commit()
    db.refresh(act)
    return act

def delete_history(db: Session, activity_id: int, user_id: int):
    act = db.query(ActivityHistory).filter(ActivityHistory.id == activity_id, ActivityHistory.user_id == user_id).first()
    if not act:
        return None
    db.delete(act)
    db.commit()
    return {"ok": True}

def get_badges(db: Session, user_id: int):
    return db.query(Badge).filter(Badge.user_id == user_id).all()

def add_badge(db: Session, user_id: int, badge: schemas.BadgeCreate):
    b = Badge(user_id=user_id, badge_name=badge.badge_name, badge_image=badge.badge_image, awarded_at=datetime.utcnow())
    db.add(b)
    db.commit()
    db.refresh(b)
    return b

def remove_badge(db: Session, user_id: int, badge_id: int):
    b = db.query(Badge).filter(Badge.id == badge_id, Badge.user_id == user_id).first()
    if not b:
        return None
    db.delete(b)
    db.commit()
    return {"ok": True} 