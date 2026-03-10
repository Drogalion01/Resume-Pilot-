import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/theme/app_status_colors.dart';

// ApplicationStatus is defined in core/theme/app_status_colors.dart
// with @JsonValue annotations so json_serializable can serialise it.
// Import it here — do NOT re-declare a local enum.
export '../../../core/theme/app_status_colors.dart' show ApplicationStatus, ApplicationStatusX;

part 'application.freezed.dart';
part 'application.g.dart';

@freezed
class ApplicationResponse with _$ApplicationResponse {
  const factory ApplicationResponse({
    required int id,
    @JsonKey(name: 'user_id')           required int userId,
    @JsonKey(name: 'company_name')      required String companyName,
    required String role,
    required ApplicationStatus status,
    @JsonKey(name: 'application_date')  DateTime? applicationDate,
    String? source,
    String? location,
    @JsonKey(name: 'recruiter_name')    String? recruiterName,
    @JsonKey(name: 'notes_summary')     String? notesSummary,
    @JsonKey(name: 'resume_version_id') int? resumeVersionId,
    @JsonKey(name: 'created_at')        required DateTime createdAt,
    @JsonKey(name: 'updated_at')        required DateTime updatedAt,
  }) = _ApplicationResponse;

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) =>
      _$ApplicationResponseFromJson(json);
}

@freezed
class ApplicationCreate with _$ApplicationCreate {
  const factory ApplicationCreate({
    @JsonKey(name: 'company_name')      required String companyName,
    required String role,
    ApplicationStatus? status,
    @JsonKey(name: 'application_date')  DateTime? applicationDate,
    String? source,
    String? location,
    @JsonKey(name: 'recruiter_name')    String? recruiterName,
    @JsonKey(name: 'notes_summary')     String? notesSummary,
    @JsonKey(name: 'resume_version_id') int? resumeVersionId,
  }) = _ApplicationCreate;

  factory ApplicationCreate.fromJson(Map<String, dynamic> json) =>
      _$ApplicationCreateFromJson(json);
}
