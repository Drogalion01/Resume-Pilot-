from pydantic import BaseModel
from typing import List

from app.schemas.user import UserResponse
from app.schemas.resume import ResumeResponse
from app.schemas.interview import InterviewResponse
from app.schemas.application import ApplicationResponse

class DashboardSummary(BaseModel):
    total_resumes: int
    total_applications: int
    total_interviews: int

class DashboardInsight(BaseModel):
    trending_stat: str
    description: str | None = None

class DashboardResponse(BaseModel):
    user: UserResponse
    summary: DashboardSummary
    insight: DashboardInsight
    recent_resumes: List[ResumeResponse] = []
    upcoming_interviews: List[InterviewResponse] = []
    recent_applications: List[ApplicationResponse] = []
