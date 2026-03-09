# ResumePilot

ResumePilot is an AI-powered resume analysis and job application tracking platform built for students, interns, and early-career professionals. It helps users analyze resumes for ATS and recruiter readiness, save tailored resume versions, track applications, manage interviews, and keep follow-up reminders in one place.

This repository currently contains:

- a **React + Vite + TypeScript frontend**
- a **FastAPI + PostgreSQL backend**
- a product structure designed to support a future **Flutter / native Android client**

---

## Core Features

### Resume Analysis
- Upload resume as **PDF** or **DOCX**
- Paste raw resume text manually
- Analyze resume against ATS and recruiter-style scoring
- Detect:
  - missing contact details
  - weak section coverage
  - weak action verbs
  - lack of measurable achievements
  - missing role-specific keywords
- Return:
  - ATS score
  - Recruiter score
  - overall score
  - issues to fix
  - missing keywords
  - action plan
  - rewrite suggestions placeholder

### Resume Version Management
- Save multiple resume versions
- Create role-specific / company-specific resume variants
- Duplicate versions
- View version details and analysis history

### Application Tracking
- Track job applications by status
- View recent applications
- View application detail timeline
- Attach a resume version to an application
- Store recruiter and job information

### Interview Tracking
- Add interview rounds to an application
- Store date, time, timezone, meeting link, interviewer, and notes
- Track interview stage progress

### Reminders and Notes
- Add follow-up reminders per application
- Add recruiter / personal notes
- View everything from one application detail screen

### User and Settings
- JWT-based authentication
- Login / signup / forgot password
- User profile
- Appearance and notification settings

---

## Product Philosophy

ResumePilot is designed around one core workflow:

**analyze resume → improve it → save a targeted version → attach it to an application → manage interviews and follow-ups**

The goal is not to be a generic job board or a bloated career platform.  
The goal is to be a focused workflow tool.

---

## Tech Stack

### Frontend
- React 18
- Vite
- TypeScript
- Tailwind CSS
- shadcn/ui
- Framer Motion
- React Router v6
- TanStack Query (integration-ready)

### Backend
- FastAPI
- Python 3.10+
- PostgreSQL
- SQLAlchemy 2.0
- Alembic
- Pydantic v2
- python-jose (JWT auth)
- passlib[bcrypt]
- pdfplumber
- python-docx

### Planned Mobile Layer
- Flutter (planned native/mobile rebuild)
- Existing web frontend currently acts as the design and product specification

---

## Repository Structure

```text
.
├── frontend/                       # React + Vite frontend (or project root if frontend is at root)
│   ├── src/
│   ├── public/
│   ├── package.json
│   └── ...
│
├── backend/
│   ├── .env
│   ├── alembic.ini
│   ├── requirements.txt
│   ├── alembic/
│   └── app/
│       ├── main.py
│       ├── config.py
│       ├── database.py
│       ├── dependencies.py
│       ├── models/
│       ├── schemas/
│       ├── routes/
│       ├── services/
│       └── utils/
│
└── README.md
