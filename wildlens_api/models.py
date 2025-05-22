from sqlalchemy import Column, Integer, String, Text, ForeignKey, Date
from sqlalchemy.orm import relationship
from sqlalchemy.ext.declarative import declarative_base

Base = declarative_base()

class Habitat(Base):
    __tablename__ = "habitat"
    
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    
    species = relationship("Species", back_populates="habitat")

class Species(Base):
    __tablename__ = "species"
    
    id = Column(Integer, primary_key=True, index=True)
    description = Column(Text, nullable=False)
    common_name = Column(String(255), nullable=False)
    scientific_name = Column(String(255), nullable=False)
    family = Column(String(255))
    size = Column(String(255))
    region = Column(String(255))
    habitat_id = Column(Integer, ForeignKey("habitat.id"))
    fun_fact = Column(Text)
    animal_image_url = Column(String)
    
    habitat = relationship("Habitat", back_populates="species")
    prints = relationship("Prints", back_populates="species")

class Prints(Base):
    __tablename__ = "prints"
    
    id = Column(Integer, primary_key=True, index=True)
    species_id = Column(Integer, ForeignKey("species.id"))
    image = Column(String)  # Changed from BYTEA to String for simplicity
    capture_date = Column(Date)
    location = Column(String(255))
    analysis_score = Column(Integer)
    
    species = relationship("Species", back_populates="prints")
