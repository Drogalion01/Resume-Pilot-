import 'package:dio/dio.dart';

import '../auth/token_storage.dart';

/// Dio interceptor — injects JWT Bearer token into every outbound request.
///
/// Must be the FIRST interceptor so every downstream interceptor
/// and the server see the token.
///
/// Uses try/finally to guarantee handler.next() is always called — even
/// if flutter_secure_storage throws a WebCrypto OperationError on web.
class AuthInterceptor extends Interceptor {
  AuthInterceptor(this._storage);
  final TokenStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await _storage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    } catch (_) {
      // Storage read failed (e.g. WebCrypto OperationError on web).
      // Proceed without a token — the backend will return 401 and
      // RefreshInterceptor will force-unauthenticate the user.
    }
    handler.next(options);
  }
}
