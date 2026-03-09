import enum
from sqlalchemy import Column, Integer, String, Text, ForeignKey, Date, Time, Boolean, Enum, DateTime
from sqlalchemy.orm import relationship
from app.models import Base, TimestampMixin

class ApplicationStatus(str, enum.Enum):
    saved = "saved"
    applied = "applied"
    assessment = "assessment"
    hr = "hr"
    technical = "technical"
    final = "final"
    offer = "offer"
    rejected = "rejected"

class InterviewStatus(str, enum.Enum):
    scheduled = "scheduled"
    completed = "completed"
    rescheduled = "rescheduled"
    cancelled = "cancelled"

class InterviewType(str, enum.Enum):
    phone = "phone"
    video = "video"
    onsite = "onsite"

class Application(Base, TimestampMixin):
    __tablename__ = "applications"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    company_name = Column(String, index=True, nullable=False)
    role = Column(String, nullable=False)
    status = Column(Enum(ApplicationStatus), default=ApplicationStatus.saved, nullable=False)
    application_date = Column(Date)
    source = Column(String)
    location = Column(String)
    recruiter_name = Column(String)
    resume_version_id = Column(Integer, ForeignKey("resume_versions.id", ondelete="SET NULL"), nullable=True)
    notes_summary = Column(Text, nullable=True)

    # Relationships
    user = relationship("User", back_populates="applications")
    resume_version = relationship("ResumeVersion", back_populates="applications")
    interviews = relationship("Interview", back_populates="application", cascade="all, delete-orphan")
    reminders = relationship("Reminder", back_populates="application", cascade="all, delete-orphan")
    notes = relationship("Note", back_populates="application", cascade="all, delete-orphan")
    timeline_events = relationship("TimelineEvent", back_populates="application", cascade="all, delete-orphan")

class Interview(Base, TimestampMixin):
    __tablename__ = "interviews"
    
    id = Column(Integer, primary_key=True, index=True)
    application_id = Column(Integer, ForeignKey("applications.id", ondelete="CASCADE"), nullable=False)
    round_name = Column(String, nullable=False)
    interview_type = Column(Enum(InterviewType), nullable=False)
    date = Column(Date, nullable=False)
    time = Column(Time)
    timezone = Column(String)
    interviewer_name = Column(String)
    meeting_link = Column(String)
    status = Column(Enum(InterviewStatus), default=InterviewStatus.scheduled, nullable=False)
    notes = Column(Text)
    reminder_enabled = Column(Boolean, default=False)

    # Relationships
    application = relationship("Application", back_populates="interviews")

class Reminder(Base, TimestampMixin):
    __tablename__ = "reminders"
    
    id = Column(Integer, primary_key=True, index=True)
    application_id = Column(Integer, ForeignKey("applications.id", ondelete="CASCADE"), nullable=False)
    title = Column(String, nullable=False)
    scheduled_for = Column(DateTime)
    completed = Column(Boolean, default=False)
    is_enabled = Column(Boolean, default=True)

    # Relationships
    application = relationship("Application", back_populates="reminders")

class Note(Base, TimestampMixin):
    __tablename__ = "notes"
    
    id = Column(Integer, primary_key=True, index=True)
    application_id = Column(Integer, ForeignKey("applications.id", ondelete="CASCADE"), nullable=False)
    content = Column(Text, nullable=False)

    # Relationships
    application = relationship("Application", back_populates="notes")

class TimelineEvent(Base, TimestampMixin):
    __tablename__ = "timeline_events"
    
    id = Column(Integer, primary_key=True, index=True)
    application_id = Column(Integer, ForeignKey("applications.id", ondelete="CASCADE"), nullable=False)
    event_type = Column(String, nullable=False)
    title = Column(String, nullable=False)
    detail = Column(Text)
    timestamp = Column(DateTime)

    # Relationships
    application = relationship("Application", back_populates="timeline_events")
