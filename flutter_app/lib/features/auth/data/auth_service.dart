import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../models/token_response.dart';

/// Thin Dio layer for /auth/* endpoints.
/// Does NOT manage token storage — that is AuthRepository's responsibility.
/// Does NOT catch exceptions — ErrorInterceptor converts them to AppException.
class AuthService {
  const AuthService(this._dio);

  final Dio _dio;

  /// POST /auth/login — JSON body, returns TokenResponse.
  Future<TokenResponse> login(String email, String password) async {
    final res = await _dio.post<Map<String, dynamic>>(
      'auth/login',
      data: {'email': email, 'password': password},
    );
    return TokenResponse.fromJson(res.data!);
  }

  /// POST /auth/register — returns TokenResponse.
  Future<TokenResponse> signup({
    required String fullName,
    required String email,
    required String password,
  }) async {
    final res = await _dio.post<Map<String, dynamic>>(
      'auth/register',
      data: {'full_name': fullName, 'email': email, 'password': password},
    );
    return TokenResponse.fromJson(res.data!);
  }

  /// POST /auth/forgot-password — always returns a message string.
  Future<String> forgotPassword(String email) async {
    final res = await _dio.post<Map<String, dynamic>>(
      'auth/forgot-password',
      data: {'email': email},
    );
    return (res.data?['message'] as String?) ??
        'If an account with that email exists, a reset link has been sent.';
  }

  /// GET /auth/me — validate token and return current user payload.
  Future<AuthUserPayload> getMe() async {
    final res = await _dio.get<Map<String, dynamic>>('auth/me');
    return AuthUserPayload.fromJson(res.data!);
  }
}

final authServiceProvider = Provider<AuthService>(
  (ref) => AuthService(ref.watch(dioProvider)),
);
