import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/auth/auth_state.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/welcome_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/signup_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/dashboard/screens/dashboard_screen.dart';
import '../../features/resume/screens/resume_versions_screen.dart';
import '../../features/applications/screens/applications_tracker_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/profile/screens/user_profile_screen.dart';
import '../../features/resume/screens/resume_upload_screen.dart';
import '../../features/resume/screens/resume_version_detail_screen.dart';
import '../../features/resume/screens/resume_analysis_screen.dart';
import '../../features/applications/screens/add_application_screen.dart';
import '../../features/applications/screens/application_detail_screen.dart';
import '../../features/interviews/screens/add_interview_screen.dart';
import '../screens/splash_screen.dart';
import 'routes.dart';
import 'shell_scaffold.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Router Provider
// ─────────────────────────────────────────────────────────────────────────────

final routerProvider = Provider<GoRouter>((ref) {
  // Bridge Riverpod auth state changes → GoRouter refreshListenable.
  // NotifierProvider has no .stream in Riverpod 2.x — use ref.listen instead.
  final refreshNotifier = _RouterRefreshNotifier();
  ref.listen<AuthState>(authNotifierProvider, (_, __) => refreshNotifier.notify());
  ref.onDispose(refreshNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: kDebugMode,
    refreshListenable: refreshNotifier,

    // ── Route guard ──────────────────────────────────────────────────────────
    //
    //   AuthState       │  on auth route?  │  action
    //   ────────────────┼──────────────────┼────────────────────────────────
    //   initial         │  any             │  → /splash (bootstrap pending)
    //   checking        │  any             │  → /splash
    //   unauthenticated │  /splash         │  → /welcome  (bootstrap done)
    //   unauthenticated │  other auth route│  allow
    //   unauthenticated │  non-auth route  │  → /welcome
    //   authenticated   │  /splash or auth │  → /  (redirect away from auth)
    //   authenticated   │  no              │  allow
    //
    redirect: (BuildContext context, GoRouterState state) {
      final authState = ref.read(authNotifierProvider);
      final onAuthRoute = AppRoutes.isAuthRoute(state.matchedLocation);

      switch (authState) {
        case AuthStateInitial():
        case AuthStateChecking():
          if (state.matchedLocation == AppRoutes.splash) return null;
          return AppRoutes.splash;

        case AuthStateUnauthenticated():
          // Splash must always exit once bootstrap resolves — even though
          // isAuthRoute('/splash') == true, staying there is never correct.
          if (state.matchedLocation == AppRoutes.splash) return AppRoutes.welcome;
          if (!onAuthRoute) return AppRoutes.welcome;
          return null;

        case AuthStateAuthenticated():
          if (onAuthRoute) return AppRoutes.dashboard;
          return null;
      }
    },

    // ── Route tree ───────────────────────────────────────────────────────────
    routes: [
      // Splash — shown during auth bootstrap
      GoRoute(
        path: AppRoutes.splash,
        name: 'splash',
        builder: (_, __) => const SplashScreen(),
      ),

      // ── Unauthenticated flow ───────────────────────────────────────────────
      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (_, __) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.signup,
        name: 'signup',
        builder: (_, __) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppRoutes.forgotPassword,
        name: 'forgot-password',
        builder: (_, __) => const ForgotPasswordScreen(),
      ),

      // ── Authenticated shell (bottom nav tabs) ──────────────────────────────
      StatefulShellRoute.indexedStack(
        builder: (_, __, navigationShell) =>
            ShellScaffold(navigationShell: navigationShell),
        branches: [
          // Tab 0 — Dashboard
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                name: 'dashboard',
                builder: (_, __) => const DashboardScreen(),
              ),
            ],
          ),

          // Tab 1 — Resumes
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.resumes,
                name: 'resumes',
                builder: (_, __) => const ResumeVersionsScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: 'resume-detail',
                    builder: (_, state) => ResumeVersionDetailScreen(
                      resumeId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                  GoRoute(
                    path: ':id/versions',
                    name: 'resume-versions',
                    builder: (_, state) => ResumeVersionDetailScreen(
                      resumeId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                  GoRoute(
                    path: ':id/analysis',
                    name: 'resume-analysis',
                    builder: (_, state) => ResumeAnalysisScreen(
                      resumeId: int.parse(state.pathParameters['id']!),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Tab 2 — Applications
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.applications,
                name: 'applications',
                builder: (_, __) => const ApplicationsTrackerScreen(),
                routes: [
                  GoRoute(
                    path: ':id',
                    name: 'application-detail',
                    builder: (_, state) => ApplicationDetailScreen(
                      applicationId: int.parse(state.pathParameters['id']!),
                    ),
                    routes: [
                      GoRoute(
                        path: 'interviews/add',
                        name: 'add-interview',
                        builder: (_, state) => AddInterviewScreen(
                          applicationId: int.parse(state.pathParameters['id']!),
                        ),
                      ),
                      GoRoute(
                        path: 'interviews/:interviewId/edit',
                        name: 'edit-interview',
                        builder: (_, state) => AddInterviewScreen(
                          applicationId: int.parse(state.pathParameters['id']!),
                          interviewId:
                              int.parse(state.pathParameters['interviewId']!),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),

          // Tab 3 — Settings
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: 'settings',
                builder: (_, __) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),

      // ── Full-screen push routes (no tab bar) ───────────────────────────────
      GoRoute(
        path: AppRoutes.upload,
        name: 'upload',
        builder: (_, __) => const ResumeUploadScreen(),
      ),
      GoRoute(
        path: AppRoutes.addApplication,
        name: 'add-application',
        builder: (_, __) => const AddApplicationScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (_, __) => const UserProfileScreen(),
      ),
    ],

    // Error fallback
    errorBuilder: (_, state) => _RouterErrorScreen(error: state.error),
  );
});

// ─────────────────────────────────────────────────────────────────────────────
// Internal error screen
// ─────────────────────────────────────────────────────────────────────────────

// Minimal ChangeNotifier bridge so GoRouter re-evaluates the redirect
// whenever auth state changes.
class _RouterRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

class _RouterErrorScreen extends StatelessWidget {
  const _RouterErrorScreen({this.error});
  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Page not found\n${error?.toString() ?? ''}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
