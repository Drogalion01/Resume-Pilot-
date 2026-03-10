from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy.orm import Session
from sqlalchemy import text
from app.config import settings
from app.database import get_db

def get_application() -> FastAPI:
    """
    Application factory pattern for clean testing and initialization.
    """
    _app = FastAPI(
        title=settings.PROJECT_NAME,
        openapi_url=f"{settings.API_V1_STR}/openapi.json",
        description="JSON API backend for ResumePilot Flutter frontend",
        version="1.0.0"
    )

    # Convert setting to standard strings array, handling comma-separated env vars if supplied
    origins = settings.BACKEND_CORS_ORIGINS
    if isinstance(origins, str):
        origins = [o.strip() for o in origins.split(",") if o.strip()]

    # Configured CORS for Flutter web and native clients, plus local tooling
    if origins:
        _app.add_middleware(
            CORSMiddleware,
            allow_origins=origins,
            allow_credentials=True,
            allow_methods=["*"],
            allow_headers=["*"],
        )

    # Register standard routers correctly
    from app.routes import auth, user, dashboard, resumes, applications, interviews, reminders
    
    _app.include_router(auth.router, prefix=f"{settings.API_V1_STR}/auth", tags=["auth"])
    _app.include_router(user.router, prefix=f"{settings.API_V1_STR}/user", tags=["user"])
    _app.include_router(dashboard.router, prefix=f"{settings.API_V1_STR}/dashboard", tags=["dashboard"])
    _app.include_router(resumes.router, prefix=f"{settings.API_V1_STR}/resumes", tags=["resumes"])
    _app.include_router(resumes.versions_router, prefix=f"{settings.API_V1_STR}/resume-versions", tags=["resume-versions"])
    _app.include_router(applications.router, prefix=f"{settings.API_V1_STR}/applications", tags=["applications"])
    _app.include_router(interviews.router, prefix=f"{settings.API_V1_STR}/interviews", tags=["interviews"])
    _app.include_router(interviews.app_sub_router, prefix=f"{settings.API_V1_STR}/applications", tags=["application-interviews"])
    _app.include_router(reminders.router, prefix=f"{settings.API_V1_STR}/reminders", tags=["reminders"])
    _app.include_router(reminders.app_sub_router, prefix=f"{settings.API_V1_STR}/applications", tags=["application-reminders-notes"])
    _app.include_router(reminders.notes_router, prefix=f"{settings.API_V1_STR}/notes", tags=["notes"])

    @_app.get("/")
    async def root():
        return {"message": "Welcome to the Resume Pilot API"}

    @_app.get(f"{settings.API_V1_STR}/health", tags=["health"])
    async def health_check():
        """Ping endpoint to verify server is up."""
        return {"status": "healthy", "version": "1.0.0"}

    @_app.get(f"{settings.API_V1_STR}/health/db", tags=["health"])
    async def db_health(db: Session = Depends(get_db)):
        """Verify the database connection is reachable."""
        try:
            db.execute(text("SELECT 1"))
            return {"status": "healthy", "database": "connected"}
        except Exception as exc:
            raise HTTPException(status_code=503, detail=f"Database unreachable: {exc}")

    return _app

app = get_application()
