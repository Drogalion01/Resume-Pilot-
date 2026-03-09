from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.database import get_db
from app.dependencies import get_current_active_user
from app.models.user import User
from app.schemas.dashboard import DashboardResponse
from app.services.dashboard_service import get_dashboard_data

router = APIRouter()

@router.get("", response_model=DashboardResponse)
@router.get("/", response_model=DashboardResponse, include_in_schema=False)
def read_dashboard(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_active_user)
):
    """
    Get aggregated dashboard data tailored for the Home screen, 
    combining stats, recent resumes, recent applications, and upcoming interviews.
    """
    return get_dashboard_data(db, current_user)
