from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from app.config import settings

# Create synchronous engine for PostgreSQL (keeps it DB-friendly for MVP without async overhead)
engine = create_engine(
    settings.DATABASE_URL.replace("postgresql+asyncpg", "postgresql"), 
    pool_pre_ping=True, # Verify the connection is alive before routing the query
    echo=False # Set to True to debug SQL logs
)

# Standard synchronous session factory
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

# Declarative base for all SQLAlchemy models
Base = declarative_base()

# Dependency to yield a DB session for FastAPI routes
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()
