import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_settings.freezed.dart';
part 'user_settings.g.dart';

// ─── UserSettings ────────────────────────────────────────────────────────────
//
// Maps GET /user/settings → SettingsResponse
//   id, user_id, theme_preference, email_notifications_enabled,
//   interview_reminders_enabled, marketing_emails_enabled,
//   created_at, updated_at
// ─────────────────────────────────────────────────────────────────────────────

@freezed
class UserSettings with _$UserSettings {
  const factory UserSettings({
    required int id,
    @JsonKey(name: 'user_id') required int userId,
    @JsonKey(name: 'theme_preference')
    @Default('system')
    String themePreference,
    @JsonKey(name: 'email_notifications_enabled')
    @Default(true)
    bool emailNotificationsEnabled,
    @JsonKey(name: 'interview_reminders_enabled')
    @Default(true)
    bool interviewRemindersEnabled,
    @JsonKey(name: 'marketing_emails_enabled')
    @Default(false)
    bool marketingEmailsEnabled,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _UserSettings;

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);
}

extension UserSettingsX on UserSettings {
  /// 'system' | 'light' | 'dark'
  bool get isDark => themePreference == 'dark';
  bool get isLight => themePreference == 'light';
  bool get isSystemTheme => themePreference == 'system';
}
