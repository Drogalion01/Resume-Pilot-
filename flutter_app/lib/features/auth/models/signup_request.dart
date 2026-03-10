import 'package:freezed_annotation/freezed_annotation.dart';

part 'signup_request.freezed.dart';
part 'signup_request.g.dart';

/// Request body for POST /auth/register.
/// Backend schema: RegisterRequest { full_name: str, email: str, password: str }
@freezed
class SignupRequest with _$SignupRequest {
  const factory SignupRequest({
    @JsonKey(name: 'full_name') required String fullName,
    required String email,
    required String password,
  }) = _SignupRequest;

  factory SignupRequest.fromJson(Map<String, dynamic> json) =>
      _$SignupRequestFromJson(json);
}
