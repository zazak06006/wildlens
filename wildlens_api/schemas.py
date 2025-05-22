from pydantic import BaseModel, Field
from typing import Optional, List
from datetime import date

class HabitatBase(BaseModel):
    name: str

class HabitatCreate(HabitatBase):
    pass

class Habitat(HabitatBase):
    id: int

    class Config:
        from_attributes = True

class SpeciesBase(BaseModel):
    description: str
    common_name: str
    scientific_name: str
    family: Optional[str] = None
    size: Optional[str] = None
    region: Optional[str] = None
    habitat_id: int
    fun_fact: Optional[str] = None
    animal_image_url: Optional[str] = None

class SpeciesCreate(SpeciesBase):
    pass

class Species(SpeciesBase):
    id: int
    habitat: Optional[Habitat] = None
    prints: List["Prints"] = []

    class Config:
        from_attributes = True

class PrintsBase(BaseModel):
    species_id: int
    image: str
    capture_date: Optional[date] = None
    location: Optional[str] = None
    analysis_score: Optional[int] = None

class PrintsCreate(PrintsBase):
    pass

class Prints(PrintsBase):
    id: int
    species: Optional[Species] = None

    class Config:
        from_attributes = True
