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
///     /signup
///     /forgot-password
///
///   Shell (authenticated bottom-nav tabs):
///     /             — Dashboard (tab 0)
///     /resumes      — Resumes   (tab 1)
///     /applications — Tracker   (tab 2)
///     /settings     — Settings  (tab 3)
///
///   Push-over-shell (no tab bar visible):
///     /resumes/:id
///     /resumes/:id/versions
///     /resumes/:id/analysis
///     /upload
///     /add-application
///     /applications/:id
///     /applications/:id/interviews/add
///     /profile
abstract class AppRoutes {
  // ── Unauthenticated flow ─────────────────────────────────────────────────

  static const splash          = '/splash';
  static const welcome         = '/welcome';
  static const onboarding      = '/onboarding';
  static const login           = '/login';
  static const signup          = '/signup';
  static const forgotPassword  = '/forgot-password';

  // ── Authenticated shell (bottom nav) ──────────────────────────────────

  static const dashboard        = '/';
  static const resumes          = '/resumes';
  static const applications     = '/applications';
  static const settings         = '/settings';

  // ── Push destinations (no tab bar) ─────────────────────────────────

  static const upload           = '/upload';
  static const addApplication   = '/add-application';
  static const profile          = '/profile';

  // ── Dynamic route paths (param templates) ───────────────────────────

  static const resumeDetailPath      = '/resumes/:id';
  static const resumeVersionsPath    = '/resumes/:id/versions';
  static const resumeAnalysisPath    = '/resumes/:id/analysis';
  static const applicationDetailPath = '/applications/:id';
  static const addInterviewPath       = '/applications/:id/interviews/add';
  static const editInterviewPath      = '/applications/:id/interviews/:interviewId/edit';

  // ── Dynamic route builders (call these for context.go / context.push) ───

  static String resumeDetail(int id)      => '/resumes/$id';
  static String resumeVersions(int id)    => '/resumes/$id/versions';
  static String resumeAnalysis(int id)    => '/resumes/$id/analysis';
  static String applicationDetail(int id) => '/applications/$id';
  static String addInterview(int appId)            => '/applications/$appId/interviews/add';
  static String editInterview(int appId, int iId)  => '/applications/$appId/interviews/$iId/edit';

  // ── Auth flow routes (for easy set containment check) ────────────────

  static const _authRoutes = {
    splash, welcome, onboarding, login, signup, forgotPassword,
  };

  /// True when [path] belongs to the unauthenticated flow.
  static bool isAuthRoute(String path) => _authRoutes.contains(path);
}

