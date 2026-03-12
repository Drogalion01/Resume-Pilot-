// ignore_for_file: constant_identifier_names

/// Static constants for the ResumePilot FastAPI backend.
///
/// ─── ENVIRONMENT SWITCHING ──────────────────────────────────────────────────
/// Pass `--dart-define=API_BASE_URL=http://...` to override at build / run time.
///
/// Defaults (when dart-define is NOT passed):
///   Web (browser)        → http://localhost:8000/api/v1
///   Android emulator     → http://10.0.2.2:8000/api/v1   (10.0.2.2 = host localhost)
///   Windows / macOS / Linux / iOS → http://localhost:8000/api/v1
///
/// VS Code launch.json examples — see .vscode/launch.json.
///
/// ─── ID TYPE ────────────────────────────────────────────────────────────────
/// ALL resource IDs are int (PostgreSQL serial). Never use String/UUID.
abstract final class ApiConstants {
  // ── Base URL ───────────────────────────────────────────────────────────────

  /// Resolved at compile time via `--dart-define=API_BASE_URL=<url>`.
  /// Falls back to a platform-appropriate localhost address when not set.
  static final String baseUrl = () {
    const env = String.fromEnvironment('API_BASE_URL',
        defaultValue: 'https://resume-pilot-lc1i.onrender.com/api/v1/');
    var result = env;
    if (env.isNotEmpty &&
        env != 'https://resume-pilot-lc1i.onrender.com/api/v1/' &&
        !env.contains('localhost')) {
      result = env;
    } else {
      result = 'https://resume-pilot-lc1i.onrender.com/api/v1/';
    }

    if (!result.endsWith('/')) {
      result += '/';
    }
    return result;
  }();

  // ── Auth ───────────────────────────────────────────────────────────────────
  //   POST  /auth/register    → AuthResponse (token + user inline)
  //   POST  /auth/login       → AuthResponse
  //   POST  /auth/forgot-password → {message: String}
  //   GET   /auth/me          → UserResponse
  //
  //   ⚠ JSON body login (NOT OAuth2 form).  Token lifetime = 8 days (11520 min).
  //     No refresh token — 401 anywhere triggers forceUnauthenticated() + re-login.

  static const authRegister = '/auth/register';
  static const authLogin = '/auth/login';
  static const authForgotPw = '/auth/forgot-password';
  static const authMe = '/auth/me';

  // ── User / Profile ─────────────────────────────────────────────────────────
  //   GET   /user/me          → UserResponse
  //   PUT   /user/me          → UserResponse
  //   GET   /user/settings    → UserSettingsResponse
  //   PATCH /user/settings    → UserSettingsResponse

  static const userMe = '/user/me';
  static const userSettings = '/user/settings';

  // ── Dashboard ──────────────────────────────────────────────────────────────
  //   GET   /dashboard        → DashboardResponse
  //   Returns: { user, summary, insight, recent_resumes,
  //              upcoming_interviews, recent_applications }

  static const dashboard = '/dashboard';

  // ── Resumes ────────────────────────────────────────────────────────────────
  //   GET   /resumes              → List<ResumeResponse>
  //   GET   /resumes/{id}         → ResumeResponse
  //   GET   /resumes/{id}/versions        → List<ResumeVersionResponse>
  //   POST  /resumes/{id}/versions        → ResumeVersionResponse
  //   GET   /resumes/{id}/analysis        → AnalysisResultResponse
  //   POST  /resumes/analyze              → AnalysisResultResponse
  //     Body: multipart/form-data — file? | pasted_text?, target_role?, company_name?, jd_text?
  //   ⚠ POST /resumes/analyze is atomic: creates Resume row AND runs AI analysis.

  static const resumes = '/resumes';
  static const resumeAnalyze = '/resumes/analyze';
  static String resumeById(int id) => '/resumes/$id';
  static String resumeVersions(int id) => '/resumes/$id/versions';
  static String resumeAnalysis(int id) => '/resumes/$id/analysis';

  // ── Resume Versions ────────────────────────────────────────────────────────
  //   PATCH /resume-versions/{id}           → ResumeVersionResponse
  //   POST  /resume-versions/{id}/duplicate → ResumeVersionResponse

  static String resumeVersionById(int id) => '/resume-versions/$id';
  static String resumeVersionDupe(int id) => '/resume-versions/$id/duplicate';

  // ── Applications ───────────────────────────────────────────────────────────
  //   GET    /applications        → List<ApplicationResponse>
  //   POST   /applications        → ApplicationResponse
  //   GET    /applications/{id}   → ApplicationDetailResponse  (MEGA payload — nested)
  //   PATCH  /applications/{id}   → ApplicationResponse  (partial update)
  //   DELETE /applications/{id}   → void (204)
  //
  //   ⚠ Field names: company_name, role (NOT job_title), status,
  //     application_date (date not datetime), source, location,
  //     recruiter_name, notes_summary, resume_version_id (int?)

  static const applications = '/applications';
  static String applicationById(int id) => '/applications/$id';

  // ── Interviews ─────────────────────────────────────────────────────────────
  //   GET    /interviews/{id}                   → InterviewResponse  (single)
  //   POST   /applications/{id}/interviews      → InterviewResponse
  //   PATCH  /interviews/{id}                   → InterviewResponse
  //   DELETE /interviews/{id}                   → void (204)
  //
  //   ⚠ No GET /interviews list endpoint — read interviews from ApplicationDetail.
  //   ⚠ Fields: round_name, interview_type (enum), date (YYYY-MM-DD),
  //     time (HH:mm:ss?), timezone, interviewer_name, meeting_link,
  //     status, notes, reminder_enabled

  static String interviewById(int id) => '/interviews/$id';
  static String applicationInterviews(int appId) =>
      '/applications/$appId/interviews';

  // ── Reminders ──────────────────────────────────────────────────────────────
  //   GET    /reminders/{id}                    → ReminderResponse  (single)
  //   POST   /applications/{id}/reminders       → ReminderResponse
  //   PATCH  /reminders/{id}                    → ReminderResponse
  //   DELETE /reminders/{id}                    → void (204)
  //
  //   ⚠ No GET /reminders list endpoint — read reminders from ApplicationDetail.
  //   ⚠ Fields: title, scheduled_for (DateTime?), completed, is_enabled

  static String reminderById(int id) => '/reminders/$id';
  static String applicationReminders(int appId) =>
      '/applications/$appId/reminders';

  // ── Notes ──────────────────────────────────────────────────────────────────
  //   GET    /applications/{id}/notes           → List<NoteResponse>
  //   POST   /applications/{id}/notes           → NoteResponse  (body: {content: String})
  //   PATCH  /notes/{id}                        → NoteResponse
  //   DELETE /notes/{id}                        → void (204)

  static String applicationNotes(int appId) => '/applications/$appId/notes';
  static String noteById(int id) => '/notes/$id';
}
