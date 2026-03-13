import 'package:dio/dio.dart';

import '../error/app_exception.dart';

class ErrorInterceptor extends Interceptor {
	@override
	void onError(DioException err, ErrorInterceptorHandler handler) {
		handler.reject(_map(err));
	}

	DioException _map(DioException err) {
		final mapped = switch (err.type) {
			DioExceptionType.connectionTimeout ||
			DioExceptionType.receiveTimeout ||
			DioExceptionType.sendTimeout =>
				const NetworkException('Connection timed out. Please try again.'),
			DioExceptionType.connectionError =>
				const NetworkException('No internet connection. Check your network and try again.'),
			DioExceptionType.cancel => const NetworkException('Request cancelled.'),
			DioExceptionType.badResponse => _mapByStatus(err),
			_ => const ParseException(),
		};

		return DioException(
			requestOptions: err.requestOptions,
			response: err.response,
			type: err.type,
			error: mapped,
			stackTrace: err.stackTrace,
			message: err.message,
		);
	}

	AppException _mapByStatus(DioException err) {
		final statusCode = err.response?.statusCode ?? 0;
		final data = err.response?.data;

		switch (statusCode) {
			case 400:
				return ValidationException(_extractDetail(data) ?? 'Invalid request.');
			case 401:
				return const UnauthorizedException();
			case 403:
				return const ForbiddenException();
			case 404:
				return NotFoundException('Resource', _extractDetail(data));
			case 422:
				return ValidationException(_extract422Detail(data) ?? 'Validation failed.');
			default:
				if (statusCode >= 500) {
					return ServerException(statusCode, _extractDetail(data) ?? 'Server error. Please try again.');
				}
				return ParseException(_extractDetail(data));
		}
	}

	String? _extractDetail(dynamic data) {
		if (data is Map<String, dynamic>) {
			final detail = data['detail'];
			if (detail is String && detail.trim().isNotEmpty) {
				return detail.trim();
			}
			final message = data['message'];
			if (message is String && message.trim().isNotEmpty) {
				return message.trim();
			}
			final statusDetail = data['statusDetail'];
			if (statusDetail is String && statusDetail.trim().isNotEmpty) {
				return statusDetail.trim();
			}
		}
		return null;
	}

	String? _extract422Detail(dynamic data) {
		if (data is! Map<String, dynamic>) return null;
		final detail = data['detail'];
		if (detail is! List) return null;

		final messages = <String>[];
		for (final item in detail) {
			if (item is! Map<String, dynamic>) continue;
			final loc = item['loc'];
			final msg = item['msg'];
			if (msg is! String || msg.trim().isEmpty) continue;

			String? field;
			if (loc is List && loc.length >= 2) {
				final candidate = loc.last;
				if (candidate is String && candidate.trim().isNotEmpty) {
					field = candidate.trim();
				}
			}

			if (field != null) {
				messages.add('$field: ${msg.trim()}');
			} else {
				messages.add(msg.trim());
			}
		}

		if (messages.isEmpty) return null;
		return messages.join(', ');
	}
}
