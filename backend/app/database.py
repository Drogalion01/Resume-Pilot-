from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from app.config import settings

# Use SSL when connecting to Neon — but only if sslmode is not already embedded
# in the URL's query string (to avoid psycopg2 "duplicate sslmode" errors).
_neon = ".neon.tech" in settings.DATABASE_URL
_ssl_in_url = "sslmode=" in settings.DATABASE_URL
_connect_args = {"sslmode": "require"} if (_neon and not _ssl_in_url) else {}

# Create synchronous engine for PostgreSQL
engine = create_engine(
    settings.DATABASE_URL.replace("postgresql+asyncpg", "postgresql"),
    pool_pre_ping=True,  # Verify the connection is alive before routing the query
    connect_args=_connect_args,
    echo=False  # Set to True to debug SQL logs
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
