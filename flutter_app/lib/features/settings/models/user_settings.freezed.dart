// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'theme_preference')
  String get themePreference => throw _privateConstructorUsedError;
  @JsonKey(name: 'email_notifications_enabled')
  bool get emailNotificationsEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'interview_reminders_enabled')
  bool get interviewRemindersEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'marketing_emails_enabled')
  bool get marketingEmailsEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) then) =
      _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'theme_preference') String themePreference,
      @JsonKey(name: 'email_notifications_enabled')
      bool emailNotificationsEnabled,
      @JsonKey(name: 'interview_reminders_enabled')
      bool interviewRemindersEnabled,
      @JsonKey(name: 'marketing_emails_enabled') bool marketingEmailsEnabled,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? themePreference = null,
    Object? emailNotificationsEnabled = null,
    Object? interviewRemindersEnabled = null,
    Object? marketingEmailsEnabled = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      themePreference: null == themePreference
          ? _value.themePreference
          : themePreference // ignore: cast_nullable_to_non_nullable
              as String,
      emailNotificationsEnabled: null == emailNotificationsEnabled
          ? _value.emailNotificationsEnabled
          : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      interviewRemindersEnabled: null == interviewRemindersEnabled
          ? _value.interviewRemindersEnabled
          : interviewRemindersEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      marketingEmailsEnabled: null == marketingEmailsEnabled
          ? _value.marketingEmailsEnabled
          : marketingEmailsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
          _$UserSettingsImpl value, $Res Function(_$UserSettingsImpl) then) =
      __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'theme_preference') String themePreference,
      @JsonKey(name: 'email_notifications_enabled')
      bool emailNotificationsEnabled,
      @JsonKey(name: 'interview_reminders_enabled')
      bool interviewRemindersEnabled,
      @JsonKey(name: 'marketing_emails_enabled') bool marketingEmailsEnabled,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
      _$UserSettingsImpl _value, $Res Function(_$UserSettingsImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? themePreference = null,
    Object? emailNotificationsEnabled = null,
    Object? interviewRemindersEnabled = null,
    Object? marketingEmailsEnabled = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$UserSettingsImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      themePreference: null == themePreference
          ? _value.themePreference
          : themePreference // ignore: cast_nullable_to_non_nullable
              as String,
      emailNotificationsEnabled: null == emailNotificationsEnabled
          ? _value.emailNotificationsEnabled
          : emailNotificationsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      interviewRemindersEnabled: null == interviewRemindersEnabled
          ? _value.interviewRemindersEnabled
          : interviewRemindersEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      marketingEmailsEnabled: null == marketingEmailsEnabled
          ? _value.marketingEmailsEnabled
          : marketingEmailsEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$UserSettingsImpl implements _UserSettings {
  const _$UserSettingsImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'theme_preference') this.themePreference = 'system',
      @JsonKey(name: 'email_notifications_enabled')
      this.emailNotificationsEnabled = true,
      @JsonKey(name: 'interview_reminders_enabled')
      this.interviewRemindersEnabled = true,
      @JsonKey(name: 'marketing_emails_enabled')
      this.marketingEmailsEnabled = false,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  @JsonKey(name: 'theme_preference')
  final String themePreference;
  @override
  @JsonKey(name: 'email_notifications_enabled')
  final bool emailNotificationsEnabled;
  @override
  @JsonKey(name: 'interview_reminders_enabled')
  final bool interviewRemindersEnabled;
  @override
  @JsonKey(name: 'marketing_emails_enabled')
  final bool marketingEmailsEnabled;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'UserSettings(id: $id, userId: $userId, themePreference: $themePreference, emailNotificationsEnabled: $emailNotificationsEnabled, interviewRemindersEnabled: $interviewRemindersEnabled, marketingEmailsEnabled: $marketingEmailsEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.themePreference, themePreference) ||
                other.themePreference == themePreference) &&
            (identical(other.emailNotificationsEnabled,
                    emailNotificationsEnabled) ||
                other.emailNotificationsEnabled == emailNotificationsEnabled) &&
            (identical(other.interviewRemindersEnabled,
                    interviewRemindersEnabled) ||
                other.interviewRemindersEnabled == interviewRemindersEnabled) &&
            (identical(other.marketingEmailsEnabled, marketingEmailsEnabled) ||
                other.marketingEmailsEnabled == marketingEmailsEnabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      themePreference,
      emailNotificationsEnabled,
      interviewRemindersEnabled,
      marketingEmailsEnabled,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsImplToJson(
      this,
    );
  }
}

abstract class _UserSettings implements UserSettings {
  const factory _UserSettings(
          {required final int id,
          @JsonKey(name: 'user_id') required final int userId,
          @JsonKey(name: 'theme_preference') final String themePreference,
          @JsonKey(name: 'email_notifications_enabled')
          final bool emailNotificationsEnabled,
          @JsonKey(name: 'interview_reminders_enabled')
          final bool interviewRemindersEnabled,
          @JsonKey(name: 'marketing_emails_enabled')
          final bool marketingEmailsEnabled,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$UserSettingsImpl;

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  @JsonKey(name: 'theme_preference')
  String get themePreference;
  @override
  @JsonKey(name: 'email_notifications_enabled')
  bool get emailNotificationsEnabled;
  @override
  @JsonKey(name: 'interview_reminders_enabled')
  bool get interviewRemindersEnabled;
  @override
  @JsonKey(name: 'marketing_emails_enabled')
  bool get marketingEmailsEnabled;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
