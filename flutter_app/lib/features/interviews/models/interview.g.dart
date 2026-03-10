// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'interview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InterviewResponseImpl _$$InterviewResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$InterviewResponseImpl(
      id: (json['id'] as num).toInt(),
      applicationId: (json['application_id'] as num).toInt(),
      roundName: json['round_name'] as String,
      interviewType:
          $enumDecode(_$InterviewTypeEnumMap, json['interview_type']),
      date: DateTime.parse(json['date'] as String),
      time: json['time'] as String?,
      timezone: json['timezone'] as String?,
      interviewerName: json['interviewer_name'] as String?,
      meetingLink: json['meeting_link'] as String?,
      status: $enumDecode(_$InterviewStatusEnumMap, json['status']),
      notes: json['notes'] as String?,
      reminderEnabled: json['reminder_enabled'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$InterviewResponseImplToJson(
        _$InterviewResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application_id': instance.applicationId,
      'round_name': instance.roundName,
      'interview_type': _$InterviewTypeEnumMap[instance.interviewType]!,
      'date': instance.date.toIso8601String(),
      'time': instance.time,
      'timezone': instance.timezone,
      'interviewer_name': instance.interviewerName,
      'meeting_link': instance.meetingLink,
      'status': _$InterviewStatusEnumMap[instance.status]!,
      'notes': instance.notes,
      'reminder_enabled': instance.reminderEnabled,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$InterviewTypeEnumMap = {
  InterviewType.phone: 'phone',
  InterviewType.video: 'video',
  InterviewType.onsite: 'onsite',
};

const _$InterviewStatusEnumMap = {
  InterviewStatus.scheduled: 'scheduled',
  InterviewStatus.completed: 'completed',
  InterviewStatus.rescheduled: 'rescheduled',
  InterviewStatus.cancelled: 'cancelled',
};
