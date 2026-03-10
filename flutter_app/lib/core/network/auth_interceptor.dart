import 'package:dio/dio.dart';

import '../auth/token_storage.dart';

/// Dio interceptor — injects JWT Bearer token into every outbound request.
///
/// Must be the FIRST interceptor so every downstream interceptor
/// and the server see the token.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);
  final TokenStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.getAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
