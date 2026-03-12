import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/app_exception.dart';
import '../network/api_client.dart';
import '../../features/auth/models/login_request.dart';
import '../../features/auth/models/signup_request.dart';
import '../../features/auth/models/token_response.dart';
import 'auth_state.dart';
import 'token_storage.dart';

/// Repository layer for all authentication operations.
/// Verified against backend/app/routes/auth.py.
///
/// All methods throw AppException subtypes on failure.
/// Callers (AuthNotifier) should propagate â€” screens catch and display.
class AuthRepository {
  AuthRepository({required Dio dio, required TokenStorage storage})
      : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final TokenStorage _storage;

  // â”€â”€ Login â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// POST /auth/login â€” JSON body (NOT OAuth2 form).
  Future<AuthStateAuthenticated> login({
    required String email,
    required String password,
  }) =>
      _run(() async {
        final body = LoginRequest(email: email, password: password);
        final res = await _dio.post<Map<String, dynamic>>(
          'auth/login',
          data: body.toJson(),
        );
        return _processResponse(res.data!);
      });

  // â”€â”€ Register â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// POST /auth/register â€” returns full TokenResponse on success.
  /// Throws [ValidationException] if email is already taken (400).
  Future<AuthStateAuthenticated> signup({
    required String fullName,
    required String email,
    required String password,
  }) =>
      _run(() async {
        final body =
            SignupRequest(fullName: fullName, email: email, password: password);
        final res = await _dio.post<Map<String, dynamic>>(
          'auth/register',
          data: body.toJson(),
        );
        return _processResponse(res.data!);
      });

  // â”€â”€ Forgot password â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// POST /auth/forgot-password.
  /// Always returns a message string â€” never throws for unknown email.
  Future<String> forgotPassword(String email) => _run(() async {
        final res = await _dio.post<Map<String, dynamic>>(
          'auth/forgot-password',
          data: {'email': email},
        );
        return (res.data?['message'] as String?) ??
            'If an account with that email exists, a reset link has been sent.';
      });

  // â”€â”€ Current user â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// GET /auth/me â€” validates current token server-side.
  /// Returns null when the token is missing or the server returns 401.
  Future<AuthStateAuthenticated?> getCurrentUser() async {
    try {
      final res = await _dio.get<Map<String, dynamic>>('auth/me');
      final user = AuthUserPayload.fromJson(res.data!);
      final token = await _storage.getAccessToken();
      if (token == null) return null;
      return _toAuthState(token: token, user: user);
    } on AppException {
      return null;
    } on DioException {
      return null;
    }
  }

  // â”€â”€ Logout â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Local-only logout. No backend endpoint â€” clears all secure storage.
  Future<void> logout() => _storage.clearAll();

  // â”€â”€ Cold-start check â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Called once at app launch.
  ///   1. Read stored token.
  ///   2. If none â†’ unauthenticated.
  ///   3. If present â†’ GET /auth/me to confirm validity.
  ///   4. If /auth/me fails â†’ clear storage â†’ unauthenticated.
  Future<AuthState> checkAuthStatus() async {
    if (!await _storage.hasToken()) {
      return const AuthState.unauthenticated();
    }
    final user = await getCurrentUser();
    if (user == null) {
      await _storage.clearAll();
      return const AuthState.unauthenticated();
    }
    return user;
  }

  // â”€â”€ Helpers â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

  /// Unwraps [DioException.error] → [AppException] so callers only need to
  /// catch [AppException]. Without this, Dio wraps every interceptor-thrown
  /// error in a DioException, swallowing the typed exception.
  Future<T> _run<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on DioException catch (e) {
      if (e.error is AppException) throw e.error as AppException;
      rethrow;
    }
  }

  Future<AuthStateAuthenticated> _processResponse(
      Map<String, dynamic> data) async {
    final response = TokenResponse.fromJson(data);
    await _storage.saveAuth(
      accessToken: response.accessToken,
      userId: response.user.id,
      email: response.user.email,
      initials: response.user.initials,
    );
    return _toAuthState(token: response.accessToken, user: response.user);
  }

  AuthStateAuthenticated _toAuthState({
    required String token,
    required AuthUserPayload user,
  }) {
    return AuthState.authenticated(
      userId: user.id,
      accessToken: token,
      email: user.email,
      initials: user.initials,
    ) as AuthStateAuthenticated;
  }
}

// â”€â”€ Provider â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    storage: ref.watch(tokenStorageProvider),
  );
});
