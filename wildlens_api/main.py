from fastapi import FastAPI, Depends, HTTPException
from sqlalchemy.orm import Session
from typing import List
import models
import schemas
from database import engine, get_db

models.Base.metadata.create_all(bind=engine)

app = FastAPI(title="WildLens API")

# Habitat endpoints
@app.post("/habitats/", response_model=schemas.Habitat)
def create_habitat(habitat: schemas.HabitatCreate, db: Session = Depends(get_db)):
    db_habitat = models.Habitat(**habitat.model_dump())
    db.add(db_habitat)
    db.commit()
    db.refresh(db_habitat)
    return db_habitat

@app.get("/habitats/", response_model=List[schemas.Habitat])
def read_habitats(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    habitats = db.query(models.Habitat).offset(skip).limit(limit).all()
    return habitats

@app.get("/habitats/{habitat_id}", response_model=schemas.Habitat)
def read_habitat(habitat_id: int, db: Session = Depends(get_db)):
    db_habitat = db.query(models.Habitat).filter(models.Habitat.id == habitat_id).first()
    if db_habitat is None:
        raise HTTPException(status_code=404, detail="Habitat not found")
    return db_habitat

# Species endpoints
@app.post("/species/", response_model=schemas.Species)
def create_species(species: schemas.SpeciesCreate, db: Session = Depends(get_db)):
    db_species = models.Species(**species.model_dump())
    db.add(db_species)
    db.commit()
    db.refresh(db_species)
    return db_species

@app.get("/species/", response_model=List[schemas.Species])
def read_species(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    species = db.query(models.Species).offset(skip).limit(limit).all()
    return species

@app.get("/species/{species_id}", response_model=schemas.Species)
def read_species(species_id: int, db: Session = Depends(get_db)):
    db_species = db.query(models.Species).filter(models.Species.id == species_id).first()
    if db_species is None:
        raise HTTPException(status_code=404, detail="Species not found")
    return db_species

# Prints endpoints
@app.post("/prints/", response_model=schemas.Prints)
def create_print(print: schemas.PrintsCreate, db: Session = Depends(get_db)):
    db_print = models.Prints(**print.model_dump())
    db.add(db_print)
    db.commit()
    db.refresh(db_print)
    return db_print

@app.get("/prints/", response_model=List[schemas.Prints])
def read_prints(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    prints = db.query(models.Prints).offset(skip).limit(limit).all()
    return prints

@app.get("/prints/{print_id}", response_model=schemas.Prints)
def read_print(print_id: int, db: Session = Depends(get_db)):
    db_print = db.query(models.Prints).filter(models.Prints.id == print_id).first()
    if db_print is None:
        raise HTTPException(status_code=404, detail="Print not found")
    return db_print
