// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      themePreference: json['theme_preference'] as String? ?? 'system',
      emailNotificationsEnabled:
          json['email_notifications_enabled'] as bool? ?? true,
      interviewRemindersEnabled:
          json['interview_reminders_enabled'] as bool? ?? true,
      marketingEmailsEnabled:
          json['marketing_emails_enabled'] as bool? ?? false,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'theme_preference': instance.themePreference,
      'email_notifications_enabled': instance.emailNotificationsEnabled,
      'interview_reminders_enabled': instance.interviewRemindersEnabled,
      'marketing_emails_enabled': instance.marketingEmailsEnabled,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
