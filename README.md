# ResumePilot

ResumePilot is an AI-powered resume analysis and job application tracking platform built for students, interns, and early-career professionals. It helps users analyze resumes for ATS and recruiter readiness, save tailored resume versions, track applications, manage interviews, and keep follow-up reminders in one place.

---

## Core Features

### Resume Analysis
- Upload resume as **PDF** or **DOCX**, or paste raw resume text
- Analyze against ATS and recruiter-style scoring
- Detect missing contact details, weak action verbs, lack of measurable achievements, and missing role-specific keywords
- Returns ATS score, recruiter score, overall score, issues list, missing keywords, and action plan

### Resume Version Management
- Save multiple resume versions; create role-specific or company-specific variants
- Duplicate versions, view version details and analysis history

### Application Tracking
- Track job applications by status with a full detail timeline
- Attach a resume version to an application; store recruiter and job information

### Interview Tracking
- Add interview rounds per application with date, time, timezone, meeting link, interviewer, and notes
- Track interview stage progress

### Reminders and Notes
- Add follow-up reminders and recruiter / personal notes per application

### User and Settings
- JWT-based authentication — login, signup, forgot password
- User profile, appearance, and notification settings

---

## Product Philosophy

ResumePilot is built around one core workflow:

**analyze resume → improve it → save a targeted version → attach it to an application → manage interviews and follow-ups**

The goal is a focused workflow tool — not a generic job board or a bloated career platform.

---

## Tech Stack

### Mobile Client
- Flutter 3.x (Dart)
- Material 3 design system
- Riverpod (state management)
- `go_router` (navigation)
- `dio` + `retrofit` (HTTP)
- `flutter_secure_storage` (token storage)

### Backend
- FastAPI (Python 3.10+)
- PostgreSQL via Neon (serverless)
- SQLAlchemy 2.0 (async)
- Alembic (migrations)
- Pydantic v2
- python-jose (JWT), passlib[bcrypt]
- pdfplumber + python-docx (resume parsing)

---

## Repository Structure

```
.
├── flutter_app/               # Flutter mobile client
│   ├── lib/
│   │   ├── main.dart
│   │   ├── app/               # App bootstrap, router, theme
│   │   ├── core/              # API client, constants, error handling
│   │   ├── features/          # Feature modules (auth, applications, resumes, …)
│   │   └── shared/            # Shared widgets, providers, utilities
│   ├── android/
│   ├── assets/
│   └── pubspec.yaml
│
├── backend/                   # FastAPI backend
│   ├── app/
│   │   ├── main.py
│   │   ├── config.py
│   │   ├── database.py
│   │   ├── dependencies.py
│   │   ├── models/
│   │   ├── schemas/
│   │   ├── routes/
│   │   ├── services/
│   │   └── utils/
│   ├── alembic/               # Database migrations
│   ├── alembic.ini
│   ├── requirements.txt
│   └── .env.example
│
├── uploads/                   # Backend file storage (gitignored)
├── resumepilotbdbackup.sql    # Database backup
└── README.md
```

---

## Getting Started

### Backend

```bash
cd backend

# Create and activate Python virtualenv
python -m venv ../myenv
# Windows:
..\myenv\Scripts\activate
# macOS/Linux:
source ../myenv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Configure environment
cp .env.example .env
# Edit .env — set DATABASE_URL, SECRET_KEY, etc.

# Run migrations
alembic upgrade head

# Start dev server
uvicorn app.main:app --reload --port 8000
```

Backend available at `http://localhost:8000`.  
Interactive docs at `http://localhost:8000/docs`.

### Flutter App

```bash
cd flutter_app

# Fetch dependencies
flutter pub get

# Run on connected device / emulator
flutter run

# Build release APK
flutter build apk --release
```

> The app points to `http://10.0.2.2:8000` (Android emulator localhost) by default.  
> Update `lib/core/constants/api_constants.dart` for a staging or production URL.

---

## Environment Variables

Copy `backend/.env.example` to `backend/.env` and fill in:

| Variable | Description |
|---|---|
| `DATABASE_URL` | PostgreSQL connection string (Neon or local) |
| `SECRET_KEY` | JWT signing secret (min 32 chars) |
| `ALGORITHM` | JWT algorithm — default `HS256` |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | Token TTL — default `30` |
| `ALLOWED_ORIGINS` | Comma-separated CORS origins |

---

## Database

Migrations are managed with **Alembic**.

```bash
# Apply all pending migrations
alembic upgrade head

# Create a new migration after model changes
alembic revision --autogenerate -m "description"

# Verify database tables
python verify_db.py
```
