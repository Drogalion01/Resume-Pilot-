import 'package:freezed_annotation/freezed_annotation.dart';

part 'auth_state.freezed.dart';

/// Global authentication state managed by [AuthNotifier].
///
/// State machine:
///
///   ┌──────────┐  app launch   ┌─────────────┐  token found + /me OK  ┌───────────────┐
///   │ initial  │ ────────────► │  checking   │ ─────────────────────► │ authenticated │
///   └──────────┘               └─────────────┘                         └───────────────┘
///                                     │  no token / /me returns 401          │
///                                     ▼                                      │ logout / 401
///                               ┌──────────────────┐ ◄────────────────────── ┘
///                               │ unauthenticated  │
///                               └──────────────────┘
///
/// GoRouter reads this state in its redirect callback on every navigation event.
@freezed
sealed class AuthState with _$AuthState {
  /// App just launched — token check not yet complete. Router shows /splash.
  const factory AuthState.initial() = AuthStateInitial;

  /// Token check in progress (cold start or explicit re-validation).
  const factory AuthState.checking() = AuthStateChecking;

  /// Valid token confirmed via GET /auth/me.
  const factory AuthState.authenticated({
    required int userId,
    required String accessToken,
    required String email,
    required String initials,
  }) = AuthStateAuthenticated;

  /// No token, expired session, or explicit logout.
  const factory AuthState.unauthenticated() = AuthStateUnauthenticated;
}

extension AuthStateX on AuthState {
  bool get isAuthenticated => this is AuthStateAuthenticated;
  bool get isInitial       => this is AuthStateInitial;
  bool get isChecking      => this is AuthStateChecking;
  bool get isUnauthenticated => this is AuthStateUnauthenticated;

  /// Convenience — returns null if not authenticated.
  AuthStateAuthenticated? get asAuthenticated =>
      isAuthenticated ? this as AuthStateAuthenticated : null;
}

