# ResumePilot — Deployment Checklist

Use this checklist before every production deployment.  
Tick each item when confirmed. All P0/P1 items must pass before going live.

---

## Phase 1 — Backend Readiness

### P0 — Blockers
- [ ] `SECRET_KEY` is set to a strong random value (not the placeholder)
- [ ] `DATABASE_URL` is set and points to Neon with `?sslmode=require`
- [ ] `BACKEND_CORS_ORIGINS` is set if serving any web client
- [ ] `alembic upgrade head` has been run against the production DB
- [ ] `python verify_db.py` passes all 10 table checks

### P1 — Important
- [ ] `ACCESS_TOKEN_EXPIRE_MINUTES` reviewed (default 11520 = 8 days)
- [ ] Procfile is present: `web: gunicorn app.main:app ...`
- [ ] `requirements.txt` is up to date (run `pip freeze > requirements.txt` after any installs)
- [ ] `runtime.txt` matches your production Python version

### P2 — Recommended
- [ ] Health endpoints verified: `GET /api/v1/health` and `GET /api/v1/health/db`
- [ ] OpenAPI docs at `/docs` are accessible (consider disabling in production if not needed)

---

## Phase 2 — Neon / Database

- [ ] Neon project is on an appropriate plan (Free tier OK for MVP)
- [ ] All 10 tables present: `users`, `user_settings`, `resumes`, `resume_versions`, `analysis_results`, `applications`, `interviews`, `notes`, `reminders`, `timeline_events`
- [ ] DB connection string includes `sslmode=require`
- [ ] Reviewed Neon connection pooling settings (default is fine for MVP)
- [ ] Alembic migration history is clean: `alembic history` shows linear chain

---

## Phase 3 — Flutter Android Release

### P0 — Blockers
- [ ] `flutter_app/android/key.properties` exists with correct keystore path and passwords
- [ ] `INTERNET` permission present in `AndroidManifest.xml` ✅ (already fixed)
- [ ] `API_BASE_URL` --dart-define points to the **production** backend URL (not localhost)
- [ ] Release APK or AAB built with `--release` flag
- [ ] APK installs and launches on a physical device

### P1 — Important
- [ ] `applicationId = "com.resumepilot.app"` (already set)
- [ ] App version code incremented in `pubspec.yaml` for each Play Store upload
- [ ] `debugShowCheckedModeBanner: false` (already set in `app.dart`)
- [ ] `kDebugMode` guards `debugLogDiagnostics` in router (already fixed)
- [ ] End-to-end smoke test: register → login → upload resume → view analysis

### P2 — Recommended
- [ ] Custom launcher icon added (currently using default Flutter icon)
- [ ] `.vscode/launch.json` staging/production URLs updated with real backend URL
- [ ] App tested on Android 8+ (API 26+) physical device

---

## Phase 4 — Infrastructure

- [ ] Platform (Railway/Render) set up with auto-deploy from main branch
- [ ] All environment variables configured in platform dashboard
- [ ] Health check path set to `/api/v1/health` in platform settings
- [ ] Custom domain (if any) configured with HTTPS
- [ ] Deploy logs reviewed — no errors on first startup

---

## Phase 5 — Final Checks

- [ ] Login flow works end-to-end (register → login → dashboard)
- [ ] Resume upload and analysis returns a score
- [ ] Application tracker: add / view / delete application
- [ ] Interview tracker: add / view interview
- [ ] Settings: theme preference persists across restarts
- [ ] Token expiry handled correctly (app redirects to login on 401)
- [ ] No secrets or `.env` files committed to git (`git status` is clean)
- [ ] `.gitignore` covers: `*.jks`, `key.properties`, `.env`, `__pycache__/`, `build/`

---

## Quick Commands Reference

```bash
# Backend — run smoke test
cd backend && python verify_db.py

# Backend — apply migrations
cd backend && alembic upgrade head

# Backend — run locally
cd backend && uvicorn app.main:app --reload --port 8000

# Flutter — build release APK
cd flutter_app && flutter build apk --release \
  --dart-define=API_BASE_URL=https://your-backend.railway.app/api/v1

# Flutter — build release AAB (Play Store)
cd flutter_app && flutter build appbundle --release \
  --dart-define=API_BASE_URL=https://your-backend.railway.app/api/v1

# Flutter — run debug on emulator
cd flutter_app && flutter run --debug \
  --dart-define=API_BASE_URL=http://10.0.2.2:8000/api/v1
```

---

## Files Reference

| File | Purpose |
|---|---|
| `backend/DEPLOYMENT.md` | Full backend deployment guide |
| `flutter_app/RELEASE.md` | Flutter release build guide |
| `backend/.env.example` | Required environment variables |
| `backend/Procfile` | Production process start command |
| `backend/runtime.txt` | Required Python version |
| `backend/alembic/` | Database migration scripts |
| `backend/verify_db.py` | Database smoke test |
| `flutter_app/android/key.properties.example` | Keystore config template |
| `.vscode/launch.json` | VS Code run/debug configurations |
