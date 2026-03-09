from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import settings

def get_application() -> FastAPI:
    """
    Application factory pattern for clean testing and initialization.
    """
    _app = FastAPI(
        title=settings.PROJECT_NAME,
        openapi_url=f"{settings.API_V1_STR}/openapi.json",
        description="JSON API backend for ResumePilot React frontend",
        version="1.0.0"
    )

    # Convert setting to standard strings array, handling comma-separated env vars if supplied
    origins = settings.BACKEND_CORS_ORIGINS
    if isinstance(origins, str):
        origins = [origin.strip() for origin in origins.split(",")]

    # Configured CORS perfectly for the React/Vite frontend
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

    @_app.get("/")
    async def root():
        return {"message": "Welcome to the Resume Pilot API"}

    @_app.get(f"{settings.API_V1_STR}/health", tags=["health"])
    async def health_check():
        """Ping endpoint to verify server is up."""
        return {"status": "healthy", "version": "1.0.0"}

    return _app

app = get_application()
