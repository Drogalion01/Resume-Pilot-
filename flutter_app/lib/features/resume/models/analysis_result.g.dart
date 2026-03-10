// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analysis_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BreakdownItemImpl _$$BreakdownItemImplFromJson(Map<String, dynamic> json) =>
    _$BreakdownItemImpl(
      category: json['category'] as String,
      score: (json['score'] as num).toInt(),
      maxScore: (json['max_score'] as num).toInt(),
    );

Map<String, dynamic> _$$BreakdownItemImplToJson(_$BreakdownItemImpl instance) =>
    <String, dynamic>{
      'category': instance.category,
      'score': instance.score,
      'max_score': instance.maxScore,
    };

_$IssueItemImpl _$$IssueItemImplFromJson(Map<String, dynamic> json) =>
    _$IssueItemImpl(
      severity: json['severity'] as String,
      description: json['description'] as String,
    );

Map<String, dynamic> _$$IssueItemImplToJson(_$IssueItemImpl instance) =>
    <String, dynamic>{
      'severity': instance.severity,
      'description': instance.description,
    };

_$MissingKeywordItemImpl _$$MissingKeywordItemImplFromJson(
        Map<String, dynamic> json) =>
    _$MissingKeywordItemImpl(
      word: json['word'] as String,
      priority: json['priority'] as String,
    );

Map<String, dynamic> _$$MissingKeywordItemImplToJson(
        _$MissingKeywordItemImpl instance) =>
    <String, dynamic>{
      'word': instance.word,
      'priority': instance.priority,
    };

_$RewriteItemImpl _$$RewriteItemImplFromJson(Map<String, dynamic> json) =>
    _$RewriteItemImpl(
      original: json['original'] as String,
      improved: json['improved'] as String,
    );

Map<String, dynamic> _$$RewriteItemImplToJson(_$RewriteItemImpl instance) =>
    <String, dynamic>{
      'original': instance.original,
      'improved': instance.improved,
    };

_$ActionPlanItemImpl _$$ActionPlanItemImplFromJson(Map<String, dynamic> json) =>
    _$ActionPlanItemImpl(
      step: (json['step'] as num).toInt(),
      description: json['description'] as String,
      potentialGain: json['potential_gain'] as String?,
    );

Map<String, dynamic> _$$ActionPlanItemImplToJson(
        _$ActionPlanItemImpl instance) =>
    <String, dynamic>{
      'step': instance.step,
      'description': instance.description,
      'potential_gain': instance.potentialGain,
    };

_$AnalysisResultResponseImpl _$$AnalysisResultResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$AnalysisResultResponseImpl(
      id: (json['id'] as num).toInt(),
      resumeId: (json['resume_id'] as num).toInt(),
      resumeVersionId: (json['resume_version_id'] as num?)?.toInt(),
      overallScore: (json['overall_score'] as num?)?.toInt(),
      atsScore: (json['ats_score'] as num?)?.toInt(),
      recruiterScore: (json['recruiter_score'] as num?)?.toInt(),
      overallLabel: json['overall_label'] as String?,
      breakdown: (json['breakdown'] as List<dynamic>?)
              ?.map((e) => BreakdownItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      issues: (json['issues'] as List<dynamic>?)
              ?.map((e) => IssueItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      missingKeywords: (json['missing_keywords'] as List<dynamic>?)
              ?.map(
                  (e) => MissingKeywordItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      rewrites: (json['rewrites'] as List<dynamic>?)
              ?.map((e) => RewriteItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      actionPlan: (json['action_plan'] as List<dynamic>?)
              ?.map((e) => ActionPlanItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$AnalysisResultResponseImplToJson(
        _$AnalysisResultResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'resume_id': instance.resumeId,
      'resume_version_id': instance.resumeVersionId,
      'overall_score': instance.overallScore,
      'ats_score': instance.atsScore,
      'recruiter_score': instance.recruiterScore,
      'overall_label': instance.overallLabel,
      'breakdown': instance.breakdown,
      'issues': instance.issues,
      'missing_keywords': instance.missingKeywords,
      'rewrites': instance.rewrites,
      'action_plan': instance.actionPlan,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
