from pydantic import BaseModel, EmailStr, Field
from typing import Optional, List
from datetime import date, datetime

# User Schemas
class UserBase(BaseModel):
    name: str
    email: EmailStr
    avatar: Optional[str] = None
    bio: Optional[str] = None
    favorite_biome: Optional[str] = None

class UserCreate(UserBase):
    password: str

class UserLogin(BaseModel):
    email: EmailStr
    password: str

class UserOut(UserBase):
    id: int
    total_scans: int
    animals_identified: int
    member_since: Optional[date]

    class Config:
        from_attributes = True

# JWT Token
class Token(BaseModel):
    access_token: str
    token_type: str = "bearer"

# Ecosystem Schemas
class EcosystemBase(BaseModel):
    name: str
    animal_count: Optional[int] = 0
    location: Optional[str] = None
    image: Optional[str] = None
    description: Optional[str] = None

class EcosystemCreate(EcosystemBase):
    pass

class EcosystemOut(EcosystemBase):
    id: int
    class Config:
        from_attributes = True

# Animal Schemas
class AnimalBase(BaseModel):
    name: str
    scientific_name: Optional[str] = None
    category: Optional[str] = None
    image: Optional[str] = None
    endangered: Optional[bool] = False
    tags: Optional[List[str]] = None
    conservation_status: Optional[str] = None
    habitat: Optional[str] = None
    footprint_type: Optional[str] = None
    ecosystem_id: Optional[int] = None

class AnimalCreate(AnimalBase):
    pass

class AnimalOut(AnimalBase):
    id: int
    class Config:
        from_attributes = True

# Scan Schemas
class ScanBase(BaseModel):
    user_id: int
    animal_id: Optional[int] = None
    name: Optional[str] = None
    scan_date: Optional[date] = None
    location: Optional[str] = None
    image: Optional[str] = None
    accuracy: Optional[str] = None
    analysis_score: Optional[int] = None

class ScanCreate(ScanBase):
    pass

class ScanOut(ScanBase):
    id: int
    class Config:
        from_attributes = True

# Activity History
class ActivityHistoryBase(BaseModel):
    user_id: int
    type: str
    title: str
    activity_date: Optional[date] = None
    location: Optional[str] = None
    image: Optional[str] = None

class ActivityHistoryCreate(ActivityHistoryBase):
    pass

class ActivityHistoryOut(ActivityHistoryBase):
    id: int
    class Config:
        from_attributes = True

# Favorite
class FavoriteBase(BaseModel):
    user_id: int
    animal_id: int

class FavoriteCreate(FavoriteBase):
    pass

class FavoriteOut(FavoriteBase):
    id: int
    created_at: Optional[datetime]
    class Config:
        from_attributes = True

# Badge
class BadgeBase(BaseModel):
    user_id: int
    badge_name: str
    badge_image: Optional[str] = None

class BadgeCreate(BadgeBase):
    pass

class BadgeOut(BadgeBase):
    id: int
    awarded_at: Optional[datetime]
    class Config:
        from_attributes = True

# Footprint Analysis
class FootprintAnalysisResult(BaseModel):
    animal_name: str
    confidence: float
    details: Optional[str] = None
