"""
Cloudinary file storage service.

Cloudinary is used to store original resume files (PDF / DOCX / TXT).
Files are uploaded as raw resources so they are downloadable, not transformed.

Usage
-----
    from app.services.storage_service import cloudinary_storage

    # Upload a file and get back its permanent secure URL (or None if not configured)
    url = await cloudinary_storage.upload(file_bytes, filename="resume.pdf", user_id=42)

    # Delete a file by its Cloudinary public_id
    await cloudinary_storage.delete(public_id="resumes/42/abc123_resume")

Design
------
- Files are stored under the folder `resumes/{user_id}/` with a UUID prefix on the filename.
- resource_type="raw" is used so Cloudinary stores files as-is (no image transformation).
- If CLOUDINARY_CLOUD_NAME / API_KEY / API_SECRET are not set, all methods are no-ops
  that return None. The app remains fully functional without storage credentials
  (text extraction still works; the original file just isn't preserved).
- All cloudinary calls are run in a thread pool so they don't block the async event loop.
"""

import asyncio
import uuid
import io
import logging
from typing import Optional

import cloudinary
import cloudinary.uploader

from app.config import settings

logger = logging.getLogger(__name__)


class CloudinaryStorageService:
    """Thin async wrapper around the Cloudinary Python SDK for raw file storage."""

    def __init__(self) -> None:
        self._configured = False

    # ── Internal helpers ──────────────────────────────────────────────────────

    def _ensure_configured(self) -> bool:
        """Lazily configure the Cloudinary SDK on first use. Returns True if ready."""
        if self._configured:
            return True
        if not (settings.CLOUDINARY_CLOUD_NAME and
                settings.CLOUDINARY_API_KEY and
                settings.CLOUDINARY_API_SECRET):
            return False
        cloudinary.config(
            cloud_name=settings.CLOUDINARY_CLOUD_NAME,
            api_key=settings.CLOUDINARY_API_KEY,
            api_secret=settings.CLOUDINARY_API_SECRET,
            secure=True,
        )
        self._configured = True
        return True

    @staticmethod
    def _make_public_id(user_id: int, filename: str) -> str:
        """
        Build a unique Cloudinary public_id.
        Format: resumes/{user_id}/{uuid}_{basename_without_extension}
        Extension is stripped — Cloudinary re-attaches it for raw resources.
        """
        basename = filename.replace(" ", "_")
        if "." in basename:
            basename = basename.rsplit(".", 1)[0]
        return f"resumes/{user_id}/{uuid.uuid4().hex}_{basename}"

    # ── Public API ────────────────────────────────────────────────────────────

    async def upload(
        self,
        file_bytes: bytes,
        filename: str,
        user_id: int,
    ) -> Optional[str]:
        """
        Upload file_bytes to Cloudinary as a raw resource.

        Returns a permanent HTTPS URL on success, or None if not configured
        or if the upload fails (resume processing still continues either way).
        """
        if not self._ensure_configured():
            logger.debug("Cloudinary not configured — skipping upload for %s", filename)
            return None

        public_id = self._make_public_id(user_id, filename)
        ext = filename.rsplit(".", 1)[-1].lower() if "." in filename else "bin"

        def _do_upload():
            return cloudinary.uploader.upload(
                io.BytesIO(file_bytes),
                public_id=public_id,
                resource_type="raw",
                format=ext,
                overwrite=True,
                use_filename=False,
            )

        try:
            result = await asyncio.get_event_loop().run_in_executor(None, _do_upload)
            url = result.get("secure_url")
            logger.info("Uploaded %s to Cloudinary: %s", filename, url)
            return url
        except Exception as exc:
            logger.error("Cloudinary upload failed for %s: %s", filename, exc)
            return None

    async def delete(self, public_id: str) -> None:
        """Delete a stored file by its Cloudinary public_id. Silently ignores errors."""
        if not self._ensure_configured() or not public_id:
            return

        def _do_delete():
            return cloudinary.uploader.destroy(public_id, resource_type="raw")

        try:
            await asyncio.get_event_loop().run_in_executor(None, _do_delete)
            logger.info("Deleted Cloudinary resource public_id=%s", public_id)
        except Exception as exc:
            logger.error("Cloudinary delete failed for %s: %s", public_id, exc)


# Singleton — import and use `cloudinary_storage` directly in any module
cloudinary_storage = CloudinaryStorageService()
