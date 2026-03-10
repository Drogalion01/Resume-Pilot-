// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReminderResponseImpl _$$ReminderResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ReminderResponseImpl(
      id: (json['id'] as num).toInt(),
      applicationId: (json['application_id'] as num).toInt(),
      title: json['title'] as String,
      scheduledFor: json['scheduled_for'] == null
          ? null
          : DateTime.parse(json['scheduled_for'] as String),
      completed: json['completed'] as bool? ?? false,
      isEnabled: json['is_enabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ReminderResponseImplToJson(
        _$ReminderResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application_id': instance.applicationId,
      'title': instance.title,
      'scheduled_for': instance.scheduledFor?.toIso8601String(),
      'completed': instance.completed,
      'is_enabled': instance.isEnabled,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$NoteResponseImpl _$$NoteResponseImplFromJson(Map<String, dynamic> json) =>
    _$NoteResponseImpl(
      id: (json['id'] as num).toInt(),
      applicationId: (json['application_id'] as num).toInt(),
      content: json['content'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$NoteResponseImplToJson(_$NoteResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application_id': instance.applicationId,
      'content': instance.content,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$TimelineEventResponseImpl _$$TimelineEventResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$TimelineEventResponseImpl(
      id: (json['id'] as num).toInt(),
      applicationId: (json['application_id'] as num).toInt(),
      eventType: json['event_type'] as String,
      title: json['title'] as String,
      detail: json['detail'] as String?,
      timestamp: json['timestamp'] == null
          ? null
          : DateTime.parse(json['timestamp'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$TimelineEventResponseImplToJson(
        _$TimelineEventResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'application_id': instance.applicationId,
      'event_type': instance.eventType,
      'title': instance.title,
      'detail': instance.detail,
      'timestamp': instance.timestamp?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
    };
