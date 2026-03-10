// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interview.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

InterviewResponse _$InterviewResponseFromJson(Map<String, dynamic> json) {
  return _InterviewResponse.fromJson(json);
}

/// @nodoc
mixin _$InterviewResponse {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'application_id')
  int get applicationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'round_name')
  String get roundName => throw _privateConstructorUsedError;
  @JsonKey(name: 'interview_type')
  InterviewType get interviewType => throw _privateConstructorUsedError;
  DateTime get date => throw _privateConstructorUsedError;
  String? get time => throw _privateConstructorUsedError;
  String? get timezone => throw _privateConstructorUsedError;
  @JsonKey(name: 'interviewer_name')
  String? get interviewerName => throw _privateConstructorUsedError;
  @JsonKey(name: 'meeting_link')
  String? get meetingLink => throw _privateConstructorUsedError;
  InterviewStatus get status => throw _privateConstructorUsedError;
  String? get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'reminder_enabled')
  bool get reminderEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $InterviewResponseCopyWith<InterviewResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterviewResponseCopyWith<$Res> {
  factory $InterviewResponseCopyWith(
          InterviewResponse value, $Res Function(InterviewResponse) then) =
      _$InterviewResponseCopyWithImpl<$Res, InterviewResponse>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'application_id') int applicationId,
      @JsonKey(name: 'round_name') String roundName,
      @JsonKey(name: 'interview_type') InterviewType interviewType,
      DateTime date,
      String? time,
      String? timezone,
      @JsonKey(name: 'interviewer_name') String? interviewerName,
      @JsonKey(name: 'meeting_link') String? meetingLink,
      InterviewStatus status,
      String? notes,
      @JsonKey(name: 'reminder_enabled') bool reminderEnabled,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$InterviewResponseCopyWithImpl<$Res, $Val extends InterviewResponse>
    implements $InterviewResponseCopyWith<$Res> {
  _$InterviewResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? applicationId = null,
    Object? roundName = null,
    Object? interviewType = null,
    Object? date = null,
    Object? time = freezed,
    Object? timezone = freezed,
    Object? interviewerName = freezed,
    Object? meetingLink = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? reminderEnabled = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as int,
      roundName: null == roundName
          ? _value.roundName
          : roundName // ignore: cast_nullable_to_non_nullable
              as String,
      interviewType: null == interviewType
          ? _value.interviewType
          : interviewType // ignore: cast_nullable_to_non_nullable
              as InterviewType,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      interviewerName: freezed == interviewerName
          ? _value.interviewerName
          : interviewerName // ignore: cast_nullable_to_non_nullable
              as String?,
      meetingLink: freezed == meetingLink
          ? _value.meetingLink
          : meetingLink // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InterviewStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      reminderEnabled: null == reminderEnabled
          ? _value.reminderEnabled
          : reminderEnabled // ignore: cast_nullable_to_non_nullable
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
abstract class _$$InterviewResponseImplCopyWith<$Res>
    implements $InterviewResponseCopyWith<$Res> {
  factory _$$InterviewResponseImplCopyWith(_$InterviewResponseImpl value,
          $Res Function(_$InterviewResponseImpl) then) =
      __$$InterviewResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'application_id') int applicationId,
      @JsonKey(name: 'round_name') String roundName,
      @JsonKey(name: 'interview_type') InterviewType interviewType,
      DateTime date,
      String? time,
      String? timezone,
      @JsonKey(name: 'interviewer_name') String? interviewerName,
      @JsonKey(name: 'meeting_link') String? meetingLink,
      InterviewStatus status,
      String? notes,
      @JsonKey(name: 'reminder_enabled') bool reminderEnabled,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$InterviewResponseImplCopyWithImpl<$Res>
    extends _$InterviewResponseCopyWithImpl<$Res, _$InterviewResponseImpl>
    implements _$$InterviewResponseImplCopyWith<$Res> {
  __$$InterviewResponseImplCopyWithImpl(_$InterviewResponseImpl _value,
      $Res Function(_$InterviewResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? applicationId = null,
    Object? roundName = null,
    Object? interviewType = null,
    Object? date = null,
    Object? time = freezed,
    Object? timezone = freezed,
    Object? interviewerName = freezed,
    Object? meetingLink = freezed,
    Object? status = null,
    Object? notes = freezed,
    Object? reminderEnabled = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$InterviewResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as int,
      roundName: null == roundName
          ? _value.roundName
          : roundName // ignore: cast_nullable_to_non_nullable
              as String,
      interviewType: null == interviewType
          ? _value.interviewType
          : interviewType // ignore: cast_nullable_to_non_nullable
              as InterviewType,
      date: null == date
          ? _value.date
          : date // ignore: cast_nullable_to_non_nullable
              as DateTime,
      time: freezed == time
          ? _value.time
          : time // ignore: cast_nullable_to_non_nullable
              as String?,
      timezone: freezed == timezone
          ? _value.timezone
          : timezone // ignore: cast_nullable_to_non_nullable
              as String?,
      interviewerName: freezed == interviewerName
          ? _value.interviewerName
          : interviewerName // ignore: cast_nullable_to_non_nullable
              as String?,
      meetingLink: freezed == meetingLink
          ? _value.meetingLink
          : meetingLink // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as InterviewStatus,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      reminderEnabled: null == reminderEnabled
          ? _value.reminderEnabled
          : reminderEnabled // ignore: cast_nullable_to_non_nullable
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
class _$InterviewResponseImpl implements _InterviewResponse {
  const _$InterviewResponseImpl(
      {required this.id,
      @JsonKey(name: 'application_id') required this.applicationId,
      @JsonKey(name: 'round_name') required this.roundName,
      @JsonKey(name: 'interview_type') required this.interviewType,
      required this.date,
      this.time,
      this.timezone,
      @JsonKey(name: 'interviewer_name') this.interviewerName,
      @JsonKey(name: 'meeting_link') this.meetingLink,
      required this.status,
      this.notes,
      @JsonKey(name: 'reminder_enabled') required this.reminderEnabled,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$InterviewResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$InterviewResponseImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'application_id')
  final int applicationId;
  @override
  @JsonKey(name: 'round_name')
  final String roundName;
  @override
  @JsonKey(name: 'interview_type')
  final InterviewType interviewType;
  @override
  final DateTime date;
  @override
  final String? time;
  @override
  final String? timezone;
  @override
  @JsonKey(name: 'interviewer_name')
  final String? interviewerName;
  @override
  @JsonKey(name: 'meeting_link')
  final String? meetingLink;
  @override
  final InterviewStatus status;
  @override
  final String? notes;
  @override
  @JsonKey(name: 'reminder_enabled')
  final bool reminderEnabled;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'InterviewResponse(id: $id, applicationId: $applicationId, roundName: $roundName, interviewType: $interviewType, date: $date, time: $time, timezone: $timezone, interviewerName: $interviewerName, meetingLink: $meetingLink, status: $status, notes: $notes, reminderEnabled: $reminderEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InterviewResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.roundName, roundName) ||
                other.roundName == roundName) &&
            (identical(other.interviewType, interviewType) ||
                other.interviewType == interviewType) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.time, time) || other.time == time) &&
            (identical(other.timezone, timezone) ||
                other.timezone == timezone) &&
            (identical(other.interviewerName, interviewerName) ||
                other.interviewerName == interviewerName) &&
            (identical(other.meetingLink, meetingLink) ||
                other.meetingLink == meetingLink) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.reminderEnabled, reminderEnabled) ||
                other.reminderEnabled == reminderEnabled) &&
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
      applicationId,
      roundName,
      interviewType,
      date,
      time,
      timezone,
      interviewerName,
      meetingLink,
      status,
      notes,
      reminderEnabled,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$InterviewResponseImplCopyWith<_$InterviewResponseImpl> get copyWith =>
      __$$InterviewResponseImplCopyWithImpl<_$InterviewResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$InterviewResponseImplToJson(
      this,
    );
  }
}

abstract class _InterviewResponse implements InterviewResponse {
  const factory _InterviewResponse(
      {required final int id,
      @JsonKey(name: 'application_id') required final int applicationId,
      @JsonKey(name: 'round_name') required final String roundName,
      @JsonKey(name: 'interview_type')
      required final InterviewType interviewType,
      required final DateTime date,
      final String? time,
      final String? timezone,
      @JsonKey(name: 'interviewer_name') final String? interviewerName,
      @JsonKey(name: 'meeting_link') final String? meetingLink,
      required final InterviewStatus status,
      final String? notes,
      @JsonKey(name: 'reminder_enabled') required final bool reminderEnabled,
      @JsonKey(name: 'created_at') required final DateTime createdAt,
      @JsonKey(name: 'updated_at')
      required final DateTime updatedAt}) = _$InterviewResponseImpl;

  factory _InterviewResponse.fromJson(Map<String, dynamic> json) =
      _$InterviewResponseImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'application_id')
  int get applicationId;
  @override
  @JsonKey(name: 'round_name')
  String get roundName;
  @override
  @JsonKey(name: 'interview_type')
  InterviewType get interviewType;
  @override
  DateTime get date;
  @override
  String? get time;
  @override
  String? get timezone;
  @override
  @JsonKey(name: 'interviewer_name')
  String? get interviewerName;
  @override
  @JsonKey(name: 'meeting_link')
  String? get meetingLink;
  @override
  InterviewStatus get status;
  @override
  String? get notes;
  @override
  @JsonKey(name: 'reminder_enabled')
  bool get reminderEnabled;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$InterviewResponseImplCopyWith<_$InterviewResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
