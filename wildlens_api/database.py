from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from dotenv import load_dotenv
import os
from models import Base

load_dotenv()

# Use environment variable for database URL with a fallback for local development
DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:postgres@localhost/wildlens")

# Ensure the database URL is properly formatted
if not DATABASE_URL.startswith('postgresql://'):
    raise ValueError("DATABASE_URL must start with postgresql://")

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,  # Verify the connection before using it
    pool_recycle=300,     # Recycle connections after 5 minutes
)

SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

def get_db():
    """Dependency for getting DB session"""
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
