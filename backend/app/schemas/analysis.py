from datetime import datetime
from typing import List, Any
from pydantic import BaseModel, ConfigDict

class BreakdownItem(BaseModel):
    category: str
    score: int
    max_score: int

class IssueItem(BaseModel):
    severity: str
    description: str

class MissingKeywordItem(BaseModel):
    word: str
    priority: str

class RewriteItem(BaseModel):
    original: str
    improved: str

class ActionPlanItem(BaseModel):
    step: int
    description: str
    potential_gain: str | None = None

class AnalysisResultResponse(BaseModel):
    id: int
    resume_id: int
    resume_version_id: int | None = None
    overall_score: int | None = None
    ats_score: int | None = None
    recruiter_score: int | None = None
    overall_label: str | None = None
    status: str = "completed"
    
    breakdown: List[BreakdownItem] = []
    issues: List[IssueItem] = []
    missing_keywords: List[MissingKeywordItem] = []
    rewrites: List[RewriteItem] = []
    action_plan: List[ActionPlanItem] = []

    created_at: datetime
    updated_at: datetime

    model_config = ConfigDict(from_attributes=True)
