/// Named route path constants — single source of truth for all navigation.
///
/// All [context.go()] / [context.push()] calls use these constants.
/// Never hardcode path strings outside this file.
///
/// Hierarchy:
///   Unauthenticated (outside ShellRoute):
///     /splash
///     /welcome
///     /onboarding
///     /login
///     /otp-verification
///
///   Shell (authenticated bottom-nav tabs):
///     /                — Dashboard      (tab 0)
///     /applications    — Track (Kanban) (tab 1)
///     /resume-lab      — Resume Lab     (tab 2)
///
///   Push-over-shell (no tab bar visible):
///     /resumes/:id
///     /resumes/:id/versions
///     /resumes/:id/analysis
///     /interview-calendar
///     /upload
///     /add-application
///     /applications/:id
///     /applications/:id/interviews/add
///     /settings
///     /profile
abstract class AppRoutes {
  // ── Unauthenticated flow ─────────────────────────────────────────────────

  static const splash = '/splash';
  static const welcome = '/welcome';
  static const onboarding = '/onboarding';
  static const login = '/login';

  static const otpVerification = '/otp-verification';

  // ── Authenticated shell (bottom nav) ──────────────────────────────────

  static const dashboard = '/';
  static const applications = '/applications';
  static const resumeLab = '/resume-lab';

  // ── Push destinations (no tab bar) ─────────────────────────────────

  static const interviewCalendar = '/interview-calendar';
  static const settings = '/settings';
  static const upload = '/upload';
  static const addApplication = '/add-application';
  static const profile = '/profile';

  // ── Dynamic route paths (param templates) ───────────────────────────

  static const resumeDetailPath = '/resumes/:id';
  static const resumeVersionsPath = '/resumes/:id/versions';
  static const resumeAnalysisPath = '/resumes/:id/analysis';
  static const applicationDetailPath = '/applications/:id';
  static const addInterviewPath = '/applications/:id/interviews/add';
  static const editInterviewPath =
      '/applications/:id/interviews/:interviewId/edit';

  // ── Dynamic route builders (call these for context.go / context.push) ───

  static String resumeDetail(int id) => '/resumes/$id';
  static String resumeVersions(int id) => '/resumes/$id/versions';
  static String resumeAnalysis(int id) => '/resumes/$id/analysis';
  static String applicationDetail(int id) => '/applications/$id';
  static String addInterview(int appId) =>
      '/applications/$appId/interviews/add';
  static String editInterview(int appId, int iId) =>
      '/applications/$appId/interviews/$iId/edit';

  // ── Auth flow routes (for easy set containment check) ────────────────

  static const _authRoutes = {
    splash,
    welcome,
    onboarding,
    login,
    otpVerification,
  };

  /// True when [path] belongs to the unauthenticated flow.
  static bool isAuthRoute(String path) => _authRoutes.contains(path);
}
