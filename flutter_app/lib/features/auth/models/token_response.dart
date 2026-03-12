import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_response.freezed.dart';
part 'token_response.g.dart';

// ─────────────────────────────────────────────────────────────────────────────
// TokenResponse — shape of POST /auth/phone/verify-otp
// ─────────────────────────────────────────────────────────────────────────────
//
// Backend response shape (auth.py /phone/verify-otp):
// {
//   "access_token": "<jwt_string>",
//   "token_type":   "bearer",
//   "user": {
//     "id":        int,
//     "full_name": String?,
//     "email":     String?,
//     "phone":     String?,
//     "initials":  String?
//   }
// }

@freezed
class TokenResponse with _$TokenResponse {
  const factory TokenResponse({
    @JsonKey(name: 'access_token') required String accessToken,
    @JsonKey(name: 'token_type') required String tokenType,
    required AuthUserPayload user,
  }) = _TokenResponse;

  factory TokenResponse.fromJson(Map<String, dynamic> json) =>
      _$TokenResponseFromJson(json);
}

// ─────────────────────────────────────────────────────────────────────────────
// AuthUserPayload — embedded user fields in TokenResponse.user
// Also maps GET /auth/me response (same shape as UserResponse in backend).
// ─────────────────────────────────────────────────────────────────────────────

@freezed
class AuthUserPayload with _$AuthUserPayload {
  const factory AuthUserPayload({
    required int id,
    @JsonKey(name: 'full_name') String? fullName,
    String? email,
    String? phone,
    String? initials,
  }) = _AuthUserPayload;

  factory AuthUserPayload.fromJson(Map<String, dynamic> json) =>
      _$AuthUserPayloadFromJson(json);
}
