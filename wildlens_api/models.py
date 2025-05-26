from sqlalchemy import Column, Integer, String, Text, Boolean, ForeignKey, Date, Table, ARRAY, TIMESTAMP
from sqlalchemy.orm import relationship, declarative_base

Base = declarative_base()

class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    email = Column(String(255), unique=True, nullable=False, index=True)
    hashed_password = Column(String(255), nullable=False)
    avatar = Column(Text)
    bio = Column(Text)
    total_scans = Column(Integer, default=0)
    animals_identified = Column(Integer, default=0)
    favorite_biome = Column(String(255))
    member_since = Column(Date)
    scans = relationship('Scan', back_populates='user')
    activity_history = relationship('ActivityHistory', back_populates='user')
    favorites = relationship('Favorite', back_populates='user')
    badges = relationship('Badge', back_populates='user')

class Ecosystem(Base):
    __tablename__ = 'ecosystems'
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    animal_count = Column(Integer, default=0)
    location = Column(String(255))
    image = Column(Text)
    description = Column(Text)
    animals = relationship('Animal', back_populates='ecosystem')

class Animal(Base):
    __tablename__ = 'animals'
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String(255), nullable=False)
    scientific_name = Column(String(255))
    category = Column(String(255))
    image = Column(Text)
    endangered = Column(Boolean, default=False)
    tags = Column(ARRAY(Text))
    conservation_status = Column(String(255))
    habitat = Column(String(255))
    footprint_type = Column(String(255))
    ecosystem_id = Column(Integer, ForeignKey('ecosystems.id'))
    ecosystem = relationship('Ecosystem', back_populates='animals')
    scans = relationship('Scan', back_populates='animal')
    favorites = relationship('Favorite', back_populates='animal')

class Scan(Base):
    __tablename__ = 'scans'
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    animal_id = Column(Integer, ForeignKey('animals.id'))
    name = Column(String(255))
    scan_date = Column(Date)
    location = Column(String(255))
    image = Column(Text)
    accuracy = Column(String(10))
    analysis_score = Column(Integer)
    user = relationship('User', back_populates='scans')
    animal = relationship('Animal', back_populates='scans')

class ActivityHistory(Base):
    __tablename__ = 'activity_history'
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    type = Column(String(50))
    title = Column(String(255))
    activity_date = Column(Date)
    location = Column(String(255))
    image = Column(Text)
    user = relationship('User', back_populates='activity_history')

class Favorite(Base):
    __tablename__ = 'favorites'
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    animal_id = Column(Integer, ForeignKey('animals.id'))
    created_at = Column(TIMESTAMP)
    user = relationship('User', back_populates='favorites')
    animal = relationship('Animal', back_populates='favorites')

class Badge(Base):
    __tablename__ = 'badges'
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id'))
    badge_name = Column(String(255))
    badge_image = Column(Text)
    awarded_at = Column(TIMESTAMP)
    user = relationship('User', back_populates='badges')
