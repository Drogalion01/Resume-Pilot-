import 'package:freezed_annotation/freezed_annotation.dart';

part 'analysis_result.freezed.dart';
part 'analysis_result.g.dart';

// ── Nested items ─────────────────────────────────────────────────────────────

@freezed
class BreakdownItem with _$BreakdownItem {
  const factory BreakdownItem({
    required String category,
    required int score,
    @JsonKey(name: 'max_score') required int maxScore,
  }) = _BreakdownItem;

  factory BreakdownItem.fromJson(Map<String, dynamic> json) =>
      _$BreakdownItemFromJson(json);
}

extension BreakdownItemX on BreakdownItem {
  double get fraction =>
      maxScore > 0 ? (score / maxScore).clamp(0.0, 1.0) : 0.0;
}

// ─────────────────────────────────────────────────────────────────────────────

@freezed
class IssueItem with _$IssueItem {
  const factory IssueItem({
    required String severity,
    required String description,
  }) = _IssueItem;

  factory IssueItem.fromJson(Map<String, dynamic> json) =>
      _$IssueItemFromJson(json);
}

// ─────────────────────────────────────────────────────────────────────────────

@freezed
class MissingKeywordItem with _$MissingKeywordItem {
  const factory MissingKeywordItem({
    required String word,
    required String priority,
  }) = _MissingKeywordItem;

  factory MissingKeywordItem.fromJson(Map<String, dynamic> json) =>
      _$MissingKeywordItemFromJson(json);
}

// ─────────────────────────────────────────────────────────────────────────────

@freezed
class RewriteItem with _$RewriteItem {
  const factory RewriteItem({
    required String original,
    required String improved,
  }) = _RewriteItem;

  factory RewriteItem.fromJson(Map<String, dynamic> json) =>
      _$RewriteItemFromJson(json);
}

// ─────────────────────────────────────────────────────────────────────────────

@freezed
class ActionPlanItem with _$ActionPlanItem {
  const factory ActionPlanItem({
    required int step,
    required String description,
    @JsonKey(name: 'potential_gain') String? potentialGain,
  }) = _ActionPlanItem;

  factory ActionPlanItem.fromJson(Map<String, dynamic> json) =>
      _$ActionPlanItemFromJson(json);
}

// ── Root response ─────────────────────────────────────────────────────────────

@freezed
class AnalysisResultResponse with _$AnalysisResultResponse {
  const factory AnalysisResultResponse({
    required int id,
    @JsonKey(name: 'resume_id') required int resumeId,
    @JsonKey(name: 'resume_version_id') int? resumeVersionId,
    @JsonKey(name: 'overall_score') int? overallScore,
    @JsonKey(name: 'ats_score') int? atsScore,
    @JsonKey(name: 'recruiter_score') int? recruiterScore,
    @JsonKey(name: 'overall_label') String? overallLabel,
    @Default([]) List<BreakdownItem> breakdown,
    @Default([]) List<IssueItem> issues,
    @JsonKey(name: 'missing_keywords')
    @Default([])
    List<MissingKeywordItem> missingKeywords,
    @Default([]) List<RewriteItem> rewrites,
    @JsonKey(name: 'action_plan') @Default([]) List<ActionPlanItem> actionPlan,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    @Default('completed') String status,
  }) = _AnalysisResultResponse;

  factory AnalysisResultResponse.fromJson(Map<String, dynamic> json) =>
      _$AnalysisResultResponseFromJson(json);
}
