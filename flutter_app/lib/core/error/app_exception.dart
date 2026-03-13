/// Sealed exception hierarchy — every failure surface maps to a subtype.
///
/// Use pattern matching for exhaustive handling:
///   switch (e) {
///     case ValidationException(:final detail) => showInlineError(detail),
///     case NetworkException(:final message)   => showSnackBar(message),
///     case UnauthorizedException()            => // handled by router
///     ...
///   }
sealed class AppException implements Exception {
  const AppException();

  /// Safe human-readable message for display in SnackBars / error widgets.
  String get userMessage;
}

// ─────────────────────────────────────────────────────────────────────────────

/// Thrown on connection timeout, receive timeout, or no internet.
class NetworkException extends AppException {
  const NetworkException(
      [this.message =
          'No internet connection. Check your network and try again.']);
  final String message;
  @override
  String get userMessage => message;
}

/// Thrown on 5xx server responses.
class ServerException extends AppException {
  const ServerException(this.statusCode,
      [this.message = 'Something went wrong on our end. Please try again.']);
  final int statusCode;
  final String message;
  @override
  String get userMessage => message;
}

/// Thrown on 401 responses outside /auth/login and /auth/register.
/// The auth guard + router handle redirect; screens don't need to catch this.
class UnauthorizedException extends AppException {
  const UnauthorizedException();
  @override
  String get userMessage => 'Your session has expired. Please sign in again.';
}

/// Thrown on 403 responses.
class ForbiddenException extends AppException {
  const ForbiddenException();
  @override
  String get userMessage =>
      'You don\'t have permission to perform that action.';
}

/// Thrown on 404 responses.
class NotFoundException extends AppException {
  const NotFoundException([this.resource = 'Resource', this.detail]);
  final String resource;
  final String? detail;
  @override
  String get userMessage => detail ?? '$resource not found.';
}

/// Thrown on 400 (detail string) and 422 (Pydantic validation errors).
///
/// For 400: `detail` is the plain string from FastAPI, e.g. "Email already registered".
/// For 422: `detail` is a flattened, comma-joined string of all field errors,
///   e.g. "email: value is not a valid email, password: field required".
class ValidationException extends AppException {
  const ValidationException(this.detail);
  final String detail;
  @override
  String get userMessage => detail;
}

/// Thrown on JSON decode failures or unexpected response shapes.
class ParseException extends AppException {
  const ParseException([this.detail]);
  final String? detail;
  @override
  String get userMessage =>
      'Received an unexpected response. Please try again.';
}
