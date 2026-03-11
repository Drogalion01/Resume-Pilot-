from typing import List
import warnings
from pydantic_settings import BaseSettings, SettingsConfigDict

class Settings(BaseSettings):
    PROJECT_NAME: str = "Resume Pilot API"
    API_V1_STR: str = "/api/v1"
    SECRET_KEY: str = "YOUR_SUPER_SECRET_KEY_CHANGE_THIS_IN_PRODUCTION"
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 11520  # 8 days

    # CORS — covers Flutter web dev server and common localhost ports.
    # Override via BACKEND_CORS_ORIGINS env var (comma-separated or JSON list).
    BACKEND_CORS_ORIGINS: List[str] | str = [
        "http://localhost:3000",
        "http://localhost:5173",
        "http://localhost:8080",
        "http://localhost:8100",  # Flutter web (flutter run --web-port)
        "http://localhost:4040",
    ]

    # Database — override with Neon connection string in .env
    DATABASE_URL: str = "postgresql://postgres:1234@localhost:5433/resumepilot"

    # Cloudinary file storage — set all three to enable file uploads.
    # If any are empty, uploads are skipped (text extraction still works).
    CLOUDINARY_CLOUD_NAME: str = ""
    CLOUDINARY_API_KEY: str = ""
    CLOUDINARY_API_SECRET: str = ""

    model_config = SettingsConfigDict(
        case_sensitive=True,
        env_file=".env",
        extra="ignore"
    )

    def __init__(self, **kwargs):
        super().__init__(**kwargs)
        if self.SECRET_KEY == "YOUR_SUPER_SECRET_KEY_CHANGE_THIS_IN_PRODUCTION":
            warnings.warn(
                "SECRET_KEY is using the insecure default — set SECRET_KEY in your .env file!",
                stacklevel=2,
            )

settings = Settings()
