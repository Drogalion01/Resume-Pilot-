import 'package:freezed_annotation/freezed_annotation.dart';

part 'resume_version.freezed.dart';
part 'resume_version.g.dart';

// ---------------------------------------------------------------------------
// ResumeResponse
// ---------------------------------------------------------------------------

@freezed
class ResumeResponse with _$ResumeResponse {
  const factory ResumeResponse({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    required String title,
    @JsonKey(name: 'original_file_path') String? originalFilePath,
    @JsonKey(name: 'file_type') String? fileType,
    @JsonKey(name: 'raw_text') String? rawText,
    @JsonKey(name: 'parsed_json') dynamic parsedJson,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ResumeResponse;

  const ResumeResponse._();

  factory ResumeResponse.fromJson(Map<String, dynamic> json) =>
      _$ResumeResponseFromJson(json);
}

extension ResumeResponseX on ResumeResponse {
  String get fileTypeLabel => fileType?.toUpperCase() ?? 'FILE';
}

// ---------------------------------------------------------------------------
// ResumeVersionResponse
// ---------------------------------------------------------------------------

@freezed
class ResumeVersionResponse with _$ResumeVersionResponse {
  const factory ResumeVersionResponse({
    required int id,
    @JsonKey(name: 'resume_id') required int resumeId,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'version_name') String? versionName,
    @JsonKey(name: 'target_role') String? targetRole,
    @JsonKey(name: 'company_name') String? companyName,
    String? tag,
    @JsonKey(name: 'edited_text') String? editedText,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ResumeVersionResponse;

  const ResumeVersionResponse._();

  factory ResumeVersionResponse.fromJson(Map<String, dynamic> json) =>
      _$ResumeVersionResponseFromJson(json);
}

extension ResumeVersionResponseX on ResumeVersionResponse {
  String get displayLabel => versionName ?? targetRole ?? 'Version #$id';
}
