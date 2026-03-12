import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../auth/token_storage.dart';

/// Dio interceptor — handles 401 Unauthorized responses.
///
/// ⚠ No refresh token: clears storage and notifies auth provider on 401.
/// Auth endpoints (/auth/phone/*) are excluded — their 401s
/// are mapped to ValidationException by ErrorInterceptor so the screen
/// shows the inline server message.
///
/// Must be the SECOND interceptor (after AuthInterceptor, before ErrorInterceptor).
class RefreshInterceptor extends Interceptor {
  RefreshInterceptor(this._storage, {required this.onUnauthorized});

  final TokenStorage _storage;

  /// Called when an expired/invalid token 401 is detected.
  /// Typically: `ref.read(authNotifierProvider.notifier).forceUnauthenticated()`
  final VoidCallback onUnauthorized;

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      final path = err.requestOptions.path;
      // Auth endpoints legitimately return 401 — let ErrorInterceptor handle them.
      final isAuthEndpoint = path.contains('/auth/phone/');

      if (!isAuthEndpoint) {
        await _storage.clearAll();
        onUnauthorized();
      }
    }
    handler.next(err);
  }
}
