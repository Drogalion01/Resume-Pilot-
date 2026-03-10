// Freezed + json_serializable model for GET /dashboard response.
//
// Verified against backend/app/schemas/dashboard.py → DashboardResponse.
//
// ⚠ This is NOT a simple stats object — it is a composite response containing
//    the current user, summary counts, an insight string, and recent list data.
//
// ─── DashboardResponse ───────────────────────────────────────────────────────
//   user                  UserResponse
//   summary               DashboardSummary
//   insight               DashboardInsight
//   recent_resumes        List<ResumeResponse>       (recent base resumes)
//   upcoming_interviews   List<InterviewResponse>    (upcoming/scheduled)
//   recent_applications   List<ApplicationResponse>  (recent by created_at)
//
// ─── DashboardSummary ────────────────────────────────────────────────────────
//   total_resumes         int
//   total_applications    int
//   total_interviews      int
//
// ─── DashboardInsight ────────────────────────────────────────────────────────
//   trending_stat   String   — e.g. "3 applications this week"
//   description     String?  — optional supporting sentence
//
// The dashboard screen can derive the resume score from recent_resumes[0]
// if analyzed — there is no dedicated score field at the summary level.
//
// All nested types reuse the same Freezed models defined in their feature modules:
//   UserResponse       → features/profile/models/user_profile.dart
//   ResumeResponse     → features/resume/models/resume_version.dart
//   InterviewResponse  → features/interviews/models/interview.dart
//   ApplicationResponse → features/applications/models/application.dart
