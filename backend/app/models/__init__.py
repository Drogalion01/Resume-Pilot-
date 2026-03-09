from sqlalchemy import Column, DateTime, func
from app.database import Base

class TimestampMixin:
    """
    Mixin to automatically attach created_at and updated_at 
    columns to any SQLAlchemy model that inherits from it.
    """
    created_at = Column(DateTime(timezone=True), server_default=func.now(), nullable=False)
    updated_at = Column(DateTime(timezone=True), server_default=func.now(), onupdate=func.now(), nullable=False)

# Re-export Base for Alembic's env.py
__all__ = ["Base", "TimestampMixin"]

# Import all models here so Alembic can discover them
from app.models.user import User, UserSettings
from app.models.resume import Resume, ResumeVersion, AnalysisResult
from app.models.tracker import Application, Interview, Reminder, Note, TimelineEvent