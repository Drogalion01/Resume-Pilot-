"""
verify_db.py — ResumePilot database smoke-test script.

Run from the backend folder:
    python verify_db.py

Checks:
  1. Can import settings (validates .env is loadable)
  2. Can connect to the database
  3. All expected tables exist in the public schema
  4. Insecure default SECRET_KEY is flagged
"""

import sys
import os

# Allow running from any working directory
sys.path.insert(0, os.path.dirname(__file__))

EXPECTED_TABLES = {
    "users",
    "user_settings",
    "resumes",
    "resume_versions",
    "analysis_results",
    "applications",
    "interviews",
    "notes",
    "reminders",
    "timeline_events",
}

INSECURE_SECRET = "YOUR_SUPER_SECRET_KEY_CHANGE_THIS_IN_PRODUCTION"


def check(label: str, ok: bool, detail: str = "") -> bool:
    status = "✓" if ok else "✗"
    suffix = f"  ({detail})" if detail else ""
    print(f"  [{status}] {label}{suffix}")
    return ok


def main() -> int:
    print("\n── ResumePilot DB Verification ────────────────────────────────\n")
    failures = 0

    # 1. Load settings
    try:
        from app.config import settings
        ok = check("Settings loaded", True, f"DB: {settings.DATABASE_URL[:40]}…")
    except Exception as exc:
        check("Settings loaded", False, str(exc))
        print("\n  Cannot continue — fix settings/config first.\n")
        return 1

    # 2. Check SECRET_KEY
    if settings.SECRET_KEY == INSECURE_SECRET:
        failures += 1
        check("SECRET_KEY", False, "still using insecure default — set a real key in .env!")
    else:
        check("SECRET_KEY", True, "custom key detected")

    # 3. DB connection
    try:
        from sqlalchemy import create_engine, text

        _db_url = settings.DATABASE_URL.replace("postgresql+asyncpg", "postgresql")
        _neon = ".neon.tech" in _db_url
        _ssl_in_url = "sslmode=" in _db_url
        connect_args = {"sslmode": "require"} if (_neon and not _ssl_in_url) else {}
        engine = create_engine(_db_url, connect_args=connect_args)
        with engine.connect() as conn:
            conn.execute(text("SELECT 1"))
        ok = check("Database connection", True, "Neon" if _neon else "Local PostgreSQL")
    except Exception as exc:
        check("Database connection", False, str(exc))
        failures += 1
        print("\n  Cannot continue — fix DATABASE_URL and ensure the server is running.\n")
        return failures

    # 4. Table presence
    try:
        from sqlalchemy import inspect as sa_inspect
        inspector = sa_inspect(engine)
        existing = set(inspector.get_table_names(schema="public"))
        missing = EXPECTED_TABLES - existing
        if missing:
            check("All tables present", False, f"missing: {', '.join(sorted(missing))}")
            failures += 1
            print("  → Run:  alembic upgrade head")
        else:
            check("All tables present", True, f"{len(existing)} tables found")

        # Row counts for a quick sanity check
        print("\n  Table row counts:")
        with engine.connect() as conn:
            for table in sorted(EXPECTED_TABLES):
                try:
                    row = conn.execute(text(f"SELECT COUNT(*) FROM {table}")).fetchone()
                    print(f"    {table:25s}  {row[0]:>6} rows")
                except Exception:
                    print(f"    {table:25s}  ERROR")
    except Exception as exc:
        check("Inspect tables", False, str(exc))
        failures += 1

    verdict = "ALL CHECKS PASSED" if failures == 0 else f"{failures} CHECK(S) FAILED"
    print(f"\n── {verdict} {'─' * (50 - len(verdict))}\n")
    return failures


if __name__ == "__main__":
    sys.exit(main())
