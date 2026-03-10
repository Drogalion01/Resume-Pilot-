// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardResponseImpl _$$DashboardResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardResponseImpl(
      user: UserProfile.fromJson(json['user'] as Map<String, dynamic>),
      summary:
          DashboardSummary.fromJson(json['summary'] as Map<String, dynamic>),
      insight:
          DashboardInsight.fromJson(json['insight'] as Map<String, dynamic>),
      recentResumes: (json['recent_resumes'] as List<dynamic>?)
              ?.map((e) => ResumeResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      upcomingInterviews: (json['upcoming_interviews'] as List<dynamic>?)
              ?.map(
                  (e) => InterviewResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      recentApplications: (json['recent_applications'] as List<dynamic>?)
              ?.map((e) =>
                  ApplicationResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$DashboardResponseImplToJson(
        _$DashboardResponseImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'summary': instance.summary,
      'insight': instance.insight,
      'recent_resumes': instance.recentResumes,
      'upcoming_interviews': instance.upcomingInterviews,
      'recent_applications': instance.recentApplications,
    };

_$DashboardSummaryImpl _$$DashboardSummaryImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardSummaryImpl(
      totalResumes: (json['total_resumes'] as num).toInt(),
      totalApplications: (json['total_applications'] as num).toInt(),
      totalInterviews: (json['total_interviews'] as num).toInt(),
    );

Map<String, dynamic> _$$DashboardSummaryImplToJson(
        _$DashboardSummaryImpl instance) =>
    <String, dynamic>{
      'total_resumes': instance.totalResumes,
      'total_applications': instance.totalApplications,
      'total_interviews': instance.totalInterviews,
    };

_$DashboardInsightImpl _$$DashboardInsightImplFromJson(
        Map<String, dynamic> json) =>
    _$DashboardInsightImpl(
      trendingStat: json['trending_stat'] as String,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$DashboardInsightImplToJson(
        _$DashboardInsightImpl instance) =>
    <String, dynamic>{
      'trending_stat': instance.trendingStat,
      'description': instance.description,
    };
