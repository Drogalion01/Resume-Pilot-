# ResumePilot Backend — Deployment Guide

## Architecture

- **Runtime:** Python 3.13 · FastAPI · SQLAlchemy (sync) · Alembic · psycopg2-binary
- **Process manager:** Gunicorn + UvicornWorker (see `Procfile`)
- **Database:** Neon Serverless PostgreSQL (SSL required)
- **File storage:** In-memory only — no filesystem writes; no object storage needed

---

## 1. Environment Variables

Copy `.env.example` to `.env` for local dev. In production, set these as platform environment variables:

| Variable | Required | Description |
|---|---|---|
| `SECRET_KEY` | **Yes** | Min 32-char random secret. Generate: `openssl rand -hex 32` |
| `ALGORITHM` | No | JWT algorithm. Default: `HS256` |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | No | Token TTL. Default: `11520` (8 days) |
| `DATABASE_URL` | **Yes** | Full Neon connection string (must include `?sslmode=require`) |
| `BACKEND_CORS_ORIGINS` | For web clients | Comma-separated list of allowed origins, e.g. `https://app.resumepilot.com` |

### Generate SECRET_KEY (PowerShell)
```powershell
-join ((65..90) + (97..122) + (48..57) | Get-Random -Count 64 | ForEach-Object {[char]$_})
```

### Generate SECRET_KEY (bash / macOS / Linux)
```bash
openssl rand -hex 32
```

---

## 2. Neon Database Setup

1. Create a project at [console.neon.tech](https://console.neon.tech)
2. Copy the **Connection string** — it looks like:
   ```
   postgresql://user:password@ep-xxx.us-east-2.aws.neon.tech/neondb?sslmode=require
   ```
3. Set it as `DATABASE_URL` in your environment

### Run migrations
```bash
cd backend
alembic upgrade head
```

### Verify
```bash
python verify_db.py
```
Expected: all 10 tables present, no errors.

---

## 3. Local Development

```bash
cd backend
python -m venv myenv
myenv\Scripts\activate          # Windows
# source myenv/bin/activate     # macOS/Linux
pip install -r requirements.txt
cp .env.example .env            # then fill in real values
alembic upgrade head
uvicorn app.main:app --reload --port 8000
```

Health check: `http://localhost:8000/api/v1/health`

---

## 4. Production Deployment

### Railway

1. Create a new project → **Deploy from GitHub Repo**
2. Set root directory to `backend/`
3. Railway auto-detects Procfile — no build command needed
4. Add environment variables (see §1)
5. Deploy

Procfile is:
```
web: gunicorn app.main:app --workers 2 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:$PORT
```

**After first deploy — run migrations:**
```bash
railway run alembic upgrade head
```
Or open a Railway shell and run `alembic upgrade head`.

### Render

1. New Web Service → connect repo, root dir = `backend/`
2. Build command: `pip install -r requirements.txt`
3. Start command: `gunicorn app.main:app --workers 2 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:$PORT`
4. Add environment variables
5. Deploy, then run migrations from Render Shell

### Workers

For most MVP loads, 2 Gunicorn workers is fine. Formula: `(2 × CPU cores) + 1`.  
Scale up by changing `--workers` in the Procfile **or** setting a `WEB_CONCURRENCY` env var:

```
web: gunicorn app.main:app --workers ${WEB_CONCURRENCY:-2} --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:$PORT
```

---

## 5. Database Migrations (Alembic)

| Task | Command |
|---|---|
| Apply all pending migrations | `alembic upgrade head` |
| Roll back one migration | `alembic downgrade -1` |
| Check current revision | `alembic current` |
| Show migration history | `alembic history` |
| Generate new migration | `alembic revision --autogenerate -m "description"` |

---

## 6. API Endpoints

Base URL: `https://<your-domain>/api/v1`

| Route | Description |
|---|---|
| `GET /health` | Liveness probe |
| `GET /health/db` | DB connectivity probe |
| `POST /auth/register` | Create account |
| `POST /auth/login` | JWT login |
| `POST /resumes/analyze` | Upload & score resume |
| `GET /resumes/` | List resume versions |
| `GET /applications/` | Application tracker |
| `GET /dashboard/` | Dashboard stats |
| `GET /interviews/` | Interview list |
| `GET /reminders/` | Reminders |
| `GET /user/me` | Current user profile |

Full OpenAPI docs: `https://<your-domain>/docs`

---

## 7. Health Checks & Monitoring

- **Liveness:** `GET /api/v1/health` → `{"status": "ok"}`
- **DB readiness:** `GET /api/v1/health/db` → `{"status": "ok", "db": "connected"}`

Configure your platform to use `GET /api/v1/health` as the health check path.

---

## 8. CORS

For native Android/iOS clients CORS is **not relevant** — mobile apps don't send `Origin` headers.

For web clients or tools like Swagger UI, set:
```
BACKEND_CORS_ORIGINS=https://app.resumepilot.com,https://www.resumepilot.com
```

---

## 9. File Uploads

The backend processes `PDF`, `DOCX`, and `TXT` files **entirely in memory** using `io.BytesIO`. No filesystem writes occur. No object storage (S3/GCS) is needed. The 30-second client timeout in the Flutter app covers analysis time for typical documents.

Maximum practical file size: ~5 MB (web server default). No explicit size limit is set in the current code.

---

## 10. Security Checklist

- [ ] `SECRET_KEY` is a strong random string (≥32 chars), not the default placeholder
- [ ] `DATABASE_URL` uses `sslmode=require`
- [ ] `DEBUG=False` (default in pydantic-settings for production)
- [ ] No `.env` file committed to git (covered by `.gitignore`)
- [ ] HTTPS enforced by platform (Railway/Render handle this automatically)
- [ ] `BACKEND_CORS_ORIGINS` is set to your domain(s) if serving web clients

---

## 11. Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `500` on login | `SECRET_KEY` not set | Set `SECRET_KEY` env var |
| `SSL connection error` | Wrong DB URL format | Ensure `?sslmode=require` in DATABASE_URL |
| `relation "users" does not exist` | Migrations not run | Run `alembic upgrade head` |
| Workers crash on startup | Missing env var | Check platform logs; verify all required env vars are set |
| `verify_db.py` SSL error locally | sslmode already in URL | Correct — the script auto-detects this, no double-SSL |
