import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../error/app_exception.dart';
import '../network/api_client.dart';
import '../../features/auth/models/token_response.dart';
import 'auth_state.dart';
import 'token_storage.dart';

class AuthRepository {
  AuthRepository({required Dio dio, required TokenStorage storage})
      : _dio = dio,
        _storage = storage;

  final Dio _dio;
  final TokenStorage _storage;

  Future<Map<String, dynamic>> checkSubscription(String phone) =>
      _run(() async {
        final res = await _dio.post<Map<String, dynamic>>(
          'auth/phone/check',
          data: {'phone': phone},
        );
        return res.data!;
      });

  Future<Map<String, dynamic>> sendOtp(String phone) => _run(() async {
        final res = await _dio.post<Map<String, dynamic>>(
          'auth/phone/send-otp',
          data: {'phone': phone},
        );
        return res.data!;
      });

  Future<AuthStateAuthenticated> verifyOtp({
    required String phone,
    required String otp,
    required String referenceNo,
  }) =>
      _run(() async {
        final res = await _dio.post<Map<String, dynamic>>(
          'auth/phone/verify-otp',
          data: {
            'phone': phone,
            'otp': otp,
            'referenceNo': referenceNo,
          },
        );
        return _processResponse(res.data!);
      });

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

  Future<void> logout() => _storage.clearAll();

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
      phone: response.user.phone,
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
      phone: user.phone,
    ) as AuthStateAuthenticated;
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    dio: ref.watch(dioProvider),
    storage: ref.watch(tokenStorageProvider),
  );
});
