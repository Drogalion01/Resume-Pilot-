from fastapi import FastAPI, Depends, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.requests import Request
from sqlalchemy.orm import Session
from sqlalchemy import text
from slowapi import _rate_limit_exceeded_handler
from slowapi.errors import RateLimitExceeded
from app.config import settings
from app.database import get_db
from app.limiter import limiter

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

    # Wire up rate-limiter state and its 429 exception handler
    _app.state.limiter = limiter
    _app.add_exception_handler(RateLimitExceeded, _rate_limit_exceeded_handler)

    # CORS — use the origins list from settings (set BACKEND_CORS_ORIGINS in .env / host env vars).
    # In local dev the defaults cover all common Flutter web ports.
    # In production set BACKEND_CORS_ORIGINS to your deployed frontend domain(s).
    # JWT is sent in Authorization header — no cookie/credentials mode needed.
    _app.add_middleware(
        CORSMiddleware,
        allow_origins=origins,
        allow_credentials=False,
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

    @_app.api_route(f"{settings.API_V1_STR}/health", methods=["GET", "HEAD"], tags=["health"])
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
