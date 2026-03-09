from sqlalchemy import Column, Integer, String, ForeignKey, JSON
from sqlalchemy.orm import relationship
from app.models import Base, TimestampMixin

class Resume(Base, TimestampMixin):
    __tablename__ = "resumes"
    
    id = Column(Integer, primary_key=True, index=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    title = Column(String, nullable=False)
    original_file_path = Column(String)
    file_type = Column(String)
    raw_text = Column(String)
    parsed_json = Column(JSON)

    # Relationships
    user = relationship("User", back_populates="resumes")
    versions = relationship("ResumeVersion", back_populates="resume", cascade="all, delete-orphan")
    analysis_results = relationship("AnalysisResult", back_populates="resume", cascade="all, delete-orphan")

class ResumeVersion(Base, TimestampMixin):
    __tablename__ = "resume_versions"
    
    id = Column(Integer, primary_key=True, index=True)
    resume_id = Column(Integer, ForeignKey("resumes.id", ondelete="CASCADE"), nullable=False)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    version_name = Column(String)
    target_role = Column(String)
    company_name = Column(String)
    tag = Column(String)
    edited_text = Column(String)

    # Relationships
    user = relationship("User", back_populates="resume_versions")
    resume = relationship("Resume", back_populates="versions")
    analysis_results = relationship("AnalysisResult", back_populates="resume_version", cascade="all, delete-orphan")
    applications = relationship("Application", back_populates="resume_version")

class AnalysisResult(Base, TimestampMixin):
    __tablename__ = "analysis_results"
    
    id = Column(Integer, primary_key=True, index=True)
    resume_id = Column(Integer, ForeignKey("resumes.id", ondelete="CASCADE"), nullable=False)
    resume_version_id = Column(Integer, ForeignKey("resume_versions.id", ondelete="CASCADE"), nullable=True)
    overall_score = Column(Integer)
    ats_score = Column(Integer)
    recruiter_score = Column(Integer)
    overall_label = Column(String)
    
    # JSON mapped structures for frontend breakdown
    breakdown_json = Column(JSON)
    issues_json = Column(JSON)
    missing_keywords_json = Column(JSON)
    rewrites_json = Column(JSON)
    action_plan_json = Column(JSON)

    # Relationships
    resume = relationship("Resume", back_populates="analysis_results")
    resume_version = relationship("ResumeVersion", back_populates="analysis_results")
