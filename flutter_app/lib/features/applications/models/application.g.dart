// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationResponseImpl _$$ApplicationResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ApplicationResponseImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      companyName: json['company_name'] as String,
      role: json['role'] as String,
      status: $enumDecode(_$ApplicationStatusEnumMap, json['status']),
      applicationDate: json['application_date'] == null
          ? null
          : DateTime.parse(json['application_date'] as String),
      source: json['source'] as String?,
      location: json['location'] as String?,
      recruiterName: json['recruiter_name'] as String?,
      notesSummary: json['notes_summary'] as String?,
      resumeVersionId: (json['resume_version_id'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ApplicationResponseImplToJson(
        _$ApplicationResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'company_name': instance.companyName,
      'role': instance.role,
      'status': _$ApplicationStatusEnumMap[instance.status]!,
      'application_date': instance.applicationDate?.toIso8601String(),
      'source': instance.source,
      'location': instance.location,
      'recruiter_name': instance.recruiterName,
      'notes_summary': instance.notesSummary,
      'resume_version_id': instance.resumeVersionId,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$ApplicationStatusEnumMap = {
  ApplicationStatus.saved: 'saved',
  ApplicationStatus.applied: 'applied',
  ApplicationStatus.assessment: 'assessment',
  ApplicationStatus.hr: 'hr',
  ApplicationStatus.technical: 'technical',
  ApplicationStatus.finalRound: 'final',
  ApplicationStatus.offer: 'offer',
  ApplicationStatus.rejected: 'rejected',
};

_$ApplicationCreateImpl _$$ApplicationCreateImplFromJson(
        Map<String, dynamic> json) =>
    _$ApplicationCreateImpl(
      companyName: json['company_name'] as String,
      role: json['role'] as String,
      status: $enumDecodeNullable(_$ApplicationStatusEnumMap, json['status']),
      applicationDate: json['application_date'] == null
          ? null
          : DateTime.parse(json['application_date'] as String),
      source: json['source'] as String?,
      location: json['location'] as String?,
      recruiterName: json['recruiter_name'] as String?,
      notesSummary: json['notes_summary'] as String?,
      resumeVersionId: (json['resume_version_id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$ApplicationCreateImplToJson(
        _$ApplicationCreateImpl instance) =>
    <String, dynamic>{
      'company_name': instance.companyName,
      'role': instance.role,
      'status': _$ApplicationStatusEnumMap[instance.status],
      'application_date': instance.applicationDate?.toIso8601String(),
      'source': instance.source,
      'location': instance.location,
      'recruiter_name': instance.recruiterName,
      'notes_summary': instance.notesSummary,
      'resume_version_id': instance.resumeVersionId,
    };
