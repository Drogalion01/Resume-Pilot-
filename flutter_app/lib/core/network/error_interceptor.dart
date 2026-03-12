import 'package:dio/dio.dart';

import '../error/app_exception.dart';

/// Dio interceptor — converts DioException → typed AppException.
///
/// Must be the LAST interceptor in the chain so it catches errors
/// from all upstream interceptors.
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    handler.reject(
      err.copyWith(error: _map(err)),
    );
  }

  AppException _map(DioException err) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException(
            'Connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.cancel:
        return const NetworkException('Request was cancelled.');
      case DioExceptionType.badResponse:
        return _mapResponse(err);
      default:
        return ParseException(err.message);
    }
  }

  AppException _mapResponse(DioException err) {
    final status = err.response?.statusCode ?? 0;
    final data = err.response?.data;

    switch (status) {
      case 400:
        return ValidationException(_extractDetail(data));
      case 401:
        final path = err.requestOptions.path;
        if (path.contains('/auth/phone/')) {
          return ValidationException(_extractDetail(data));
        }
        return const UnauthorizedException();
      case 403:
        return const ForbiddenException();
      case 404:
        return NotFoundException('Resource', _extractDetail(data));
      case 422:
        return ValidationException(_extract422(data));
      default:
        if (status >= 500) {
          return ServerException(status);
        }
        return ParseException(_extractDetail(data));
    }
  }

  String _extractDetail(dynamic data) {
    if (data == null) return 'An unexpected error occurred.';
    if (data is Map) {
      final d = data['detail'];
      if (d is String) return d;
    }
    return 'An unexpected error occurred.';
  }

  String _extract422(dynamic data) {
    if (data is Map) {
      final detail = data['detail'];
      if (detail is List) {
        final parts = detail.map((e) {
          final loc = (e['loc'] as List?)?.last?.toString() ?? 'field';
          final msg = e['msg'] as String? ?? 'invalid';
          return '$loc: $msg';
        }).join(', ');
        if (parts.isNotEmpty) return parts;
      }
    }
    return 'Please check your input and try again.';
  }
}
