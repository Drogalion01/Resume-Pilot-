// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'application_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ApplicationDetailResponseImpl _$$ApplicationDetailResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ApplicationDetailResponseImpl(
      application: ApplicationResponse.fromJson(
          json['application'] as Map<String, dynamic>),
      timelineEvents: (json['timeline_events'] as List<dynamic>?)
              ?.map((e) =>
                  TimelineEventResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      interviews: (json['interviews'] as List<dynamic>?)
              ?.map(
                  (e) => InterviewResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      reminders: (json['reminders'] as List<dynamic>?)
              ?.map((e) => ReminderResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      notes: (json['notes'] as List<dynamic>?)
              ?.map((e) => NoteResponse.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      resumeVersion: json['resume_version'] == null
          ? null
          : ResumeVersionResponse.fromJson(
              json['resume_version'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ApplicationDetailResponseImplToJson(
        _$ApplicationDetailResponseImpl instance) =>
    <String, dynamic>{
      'application': instance.application,
      'timeline_events': instance.timelineEvents,
      'interviews': instance.interviews,
      'reminders': instance.reminders,
      'notes': instance.notes,
      'resume_version': instance.resumeVersion,
    };
