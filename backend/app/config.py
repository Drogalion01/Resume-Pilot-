from typing import List
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    PROJECT_NAME: str = "Resume Pilot API"
    API_V1_STR: str = "/api/v1"
    SECRET_KEY: str = "YOUR_SUPER_SECRET_KEY_CHANGE_THIS_IN_PRODUCTION"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 11520  # 8 days
    
    # CORS setup for Vite frontend (typically runs on 5173). Can accept lists or comma-separated strings.
    BACKEND_CORS_ORIGINS: List[str] | str = ["http://localhost:5173", "http://localhost:3000", "http://localhost:8080"]

    # Database
    DATABASE_URL: str = "postgresql://postgres:1234@localhost:5433/resumepilot"

    model_config = SettingsConfigDict(
        case_sensitive=True, 
        env_file=".env",
        extra="ignore"
    )

settings = Settings()
