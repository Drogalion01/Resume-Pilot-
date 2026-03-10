// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reminder_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ReminderResponse _$ReminderResponseFromJson(Map<String, dynamic> json) {
  return _ReminderResponse.fromJson(json);
}

/// @nodoc
mixin _$ReminderResponse {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'application_id')
  int get applicationId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'scheduled_for')
  DateTime? get scheduledFor => throw _privateConstructorUsedError;
  bool get completed => throw _privateConstructorUsedError;
  @JsonKey(name: 'is_enabled')
  bool get isEnabled => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReminderResponseCopyWith<ReminderResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReminderResponseCopyWith<$Res> {
  factory $ReminderResponseCopyWith(
          ReminderResponse value, $Res Function(ReminderResponse) then) =
      _$ReminderResponseCopyWithImpl<$Res, ReminderResponse>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'application_id') int applicationId,
      String title,
      @JsonKey(name: 'scheduled_for') DateTime? scheduledFor,
      bool completed,
      @JsonKey(name: 'is_enabled') bool isEnabled,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$ReminderResponseCopyWithImpl<$Res, $Val extends ReminderResponse>
    implements $ReminderResponseCopyWith<$Res> {
  _$ReminderResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? applicationId = null,
    Object? title = null,
    Object? scheduledFor = freezed,
    Object? completed = null,
    Object? isEnabled = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledFor: freezed == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
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
abstract class _$$ReminderResponseImplCopyWith<$Res>
    implements $ReminderResponseCopyWith<$Res> {
  factory _$$ReminderResponseImplCopyWith(_$ReminderResponseImpl value,
          $Res Function(_$ReminderResponseImpl) then) =
      __$$ReminderResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'application_id') int applicationId,
      String title,
      @JsonKey(name: 'scheduled_for') DateTime? scheduledFor,
      bool completed,
      @JsonKey(name: 'is_enabled') bool isEnabled,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$ReminderResponseImplCopyWithImpl<$Res>
    extends _$ReminderResponseCopyWithImpl<$Res, _$ReminderResponseImpl>
    implements _$$ReminderResponseImplCopyWith<$Res> {
  __$$ReminderResponseImplCopyWithImpl(_$ReminderResponseImpl _value,
      $Res Function(_$ReminderResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? applicationId = null,
    Object? title = null,
    Object? scheduledFor = freezed,
    Object? completed = null,
    Object? isEnabled = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ReminderResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      scheduledFor: freezed == scheduledFor
          ? _value.scheduledFor
          : scheduledFor // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as bool,
      isEnabled: null == isEnabled
          ? _value.isEnabled
          : isEnabled // ignore: cast_nullable_to_non_nullable
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
class _$ReminderResponseImpl implements _ReminderResponse {
  const _$ReminderResponseImpl(
      {required this.id,
      @JsonKey(name: 'application_id') required this.applicationId,
      required this.title,
      @JsonKey(name: 'scheduled_for') this.scheduledFor,
      this.completed = false,
      @JsonKey(name: 'is_enabled') this.isEnabled = true,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$ReminderResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReminderResponseImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'application_id')
  final int applicationId;
  @override
  final String title;
  @override
  @JsonKey(name: 'scheduled_for')
  final DateTime? scheduledFor;
  @override
  @JsonKey()
  final bool completed;
  @override
  @JsonKey(name: 'is_enabled')
  final bool isEnabled;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ReminderResponse(id: $id, applicationId: $applicationId, title: $title, scheduledFor: $scheduledFor, completed: $completed, isEnabled: $isEnabled, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReminderResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.scheduledFor, scheduledFor) ||
                other.scheduledFor == scheduledFor) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.isEnabled, isEnabled) ||
                other.isEnabled == isEnabled) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, applicationId, title,
      scheduledFor, completed, isEnabled, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReminderResponseImplCopyWith<_$ReminderResponseImpl> get copyWith =>
      __$$ReminderResponseImplCopyWithImpl<_$ReminderResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReminderResponseImplToJson(
      this,
    );
  }
}

abstract class _ReminderResponse implements ReminderResponse {
  const factory _ReminderResponse(
          {required final int id,
          @JsonKey(name: 'application_id') required final int applicationId,
          required final String title,
          @JsonKey(name: 'scheduled_for') final DateTime? scheduledFor,
          final bool completed,
          @JsonKey(name: 'is_enabled') final bool isEnabled,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$ReminderResponseImpl;

  factory _ReminderResponse.fromJson(Map<String, dynamic> json) =
      _$ReminderResponseImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'application_id')
  int get applicationId;
  @override
  String get title;
  @override
  @JsonKey(name: 'scheduled_for')
  DateTime? get scheduledFor;
  @override
  bool get completed;
  @override
  @JsonKey(name: 'is_enabled')
  bool get isEnabled;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ReminderResponseImplCopyWith<_$ReminderResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

NoteResponse _$NoteResponseFromJson(Map<String, dynamic> json) {
  return _NoteResponse.fromJson(json);
}

/// @nodoc
mixin _$NoteResponse {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'application_id')
  int get applicationId => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $NoteResponseCopyWith<NoteResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NoteResponseCopyWith<$Res> {
  factory $NoteResponseCopyWith(
          NoteResponse value, $Res Function(NoteResponse) then) =
      _$NoteResponseCopyWithImpl<$Res, NoteResponse>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'application_id') int applicationId,
      String content,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$NoteResponseCopyWithImpl<$Res, $Val extends NoteResponse>
    implements $NoteResponseCopyWith<$Res> {
  _$NoteResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? applicationId = null,
    Object? content = null,
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
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
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
abstract class _$$NoteResponseImplCopyWith<$Res>
    implements $NoteResponseCopyWith<$Res> {
  factory _$$NoteResponseImplCopyWith(
          _$NoteResponseImpl value, $Res Function(_$NoteResponseImpl) then) =
      __$$NoteResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'application_id') int applicationId,
      String content,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$NoteResponseImplCopyWithImpl<$Res>
    extends _$NoteResponseCopyWithImpl<$Res, _$NoteResponseImpl>
    implements _$$NoteResponseImplCopyWith<$Res> {
  __$$NoteResponseImplCopyWithImpl(
      _$NoteResponseImpl _value, $Res Function(_$NoteResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? applicationId = null,
    Object? content = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$NoteResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as int,
      content: null == content
          ? _value.content
          : content // ignore: cast_nullable_to_non_nullable
              as String,
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
class _$NoteResponseImpl implements _NoteResponse {
  const _$NoteResponseImpl(
      {required this.id,
      @JsonKey(name: 'application_id') required this.applicationId,
      required this.content,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$NoteResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$NoteResponseImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'application_id')
  final int applicationId;
  @override
  final String content;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'NoteResponse(id: $id, applicationId: $applicationId, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NoteResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, id, applicationId, content, createdAt, updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NoteResponseImplCopyWith<_$NoteResponseImpl> get copyWith =>
      __$$NoteResponseImplCopyWithImpl<_$NoteResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$NoteResponseImplToJson(
      this,
    );
  }
}

abstract class _NoteResponse implements NoteResponse {
  const factory _NoteResponse(
          {required final int id,
          @JsonKey(name: 'application_id') required final int applicationId,
          required final String content,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$NoteResponseImpl;

  factory _NoteResponse.fromJson(Map<String, dynamic> json) =
      _$NoteResponseImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'application_id')
  int get applicationId;
  @override
  String get content;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$NoteResponseImplCopyWith<_$NoteResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TimelineEventResponse _$TimelineEventResponseFromJson(
    Map<String, dynamic> json) {
  return _TimelineEventResponse.fromJson(json);
}

/// @nodoc
mixin _$TimelineEventResponse {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'application_id')
  int get applicationId => throw _privateConstructorUsedError;
  @JsonKey(name: 'event_type')
  String get eventType => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String? get detail => throw _privateConstructorUsedError;
  DateTime? get timestamp => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $TimelineEventResponseCopyWith<TimelineEventResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TimelineEventResponseCopyWith<$Res> {
  factory $TimelineEventResponseCopyWith(TimelineEventResponse value,
          $Res Function(TimelineEventResponse) then) =
      _$TimelineEventResponseCopyWithImpl<$Res, TimelineEventResponse>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'application_id') int applicationId,
      @JsonKey(name: 'event_type') String eventType,
      String title,
      String? detail,
      DateTime? timestamp,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class _$TimelineEventResponseCopyWithImpl<$Res,
        $Val extends TimelineEventResponse>
    implements $TimelineEventResponseCopyWith<$Res> {
  _$TimelineEventResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? applicationId = null,
    Object? eventType = null,
    Object? title = null,
    Object? detail = freezed,
    Object? timestamp = freezed,
    Object? createdAt = null,
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
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      detail: freezed == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TimelineEventResponseImplCopyWith<$Res>
    implements $TimelineEventResponseCopyWith<$Res> {
  factory _$$TimelineEventResponseImplCopyWith(
          _$TimelineEventResponseImpl value,
          $Res Function(_$TimelineEventResponseImpl) then) =
      __$$TimelineEventResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'application_id') int applicationId,
      @JsonKey(name: 'event_type') String eventType,
      String title,
      String? detail,
      DateTime? timestamp,
      @JsonKey(name: 'created_at') DateTime createdAt});
}

/// @nodoc
class __$$TimelineEventResponseImplCopyWithImpl<$Res>
    extends _$TimelineEventResponseCopyWithImpl<$Res,
        _$TimelineEventResponseImpl>
    implements _$$TimelineEventResponseImplCopyWith<$Res> {
  __$$TimelineEventResponseImplCopyWithImpl(_$TimelineEventResponseImpl _value,
      $Res Function(_$TimelineEventResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? applicationId = null,
    Object? eventType = null,
    Object? title = null,
    Object? detail = freezed,
    Object? timestamp = freezed,
    Object? createdAt = null,
  }) {
    return _then(_$TimelineEventResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      applicationId: null == applicationId
          ? _value.applicationId
          : applicationId // ignore: cast_nullable_to_non_nullable
              as int,
      eventType: null == eventType
          ? _value.eventType
          : eventType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      detail: freezed == detail
          ? _value.detail
          : detail // ignore: cast_nullable_to_non_nullable
              as String?,
      timestamp: freezed == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TimelineEventResponseImpl implements _TimelineEventResponse {
  const _$TimelineEventResponseImpl(
      {required this.id,
      @JsonKey(name: 'application_id') required this.applicationId,
      @JsonKey(name: 'event_type') required this.eventType,
      required this.title,
      this.detail,
      this.timestamp,
      @JsonKey(name: 'created_at') required this.createdAt});

  factory _$TimelineEventResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$TimelineEventResponseImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'application_id')
  final int applicationId;
  @override
  @JsonKey(name: 'event_type')
  final String eventType;
  @override
  final String title;
  @override
  final String? detail;
  @override
  final DateTime? timestamp;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;

  @override
  String toString() {
    return 'TimelineEventResponse(id: $id, applicationId: $applicationId, eventType: $eventType, title: $title, detail: $detail, timestamp: $timestamp, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimelineEventResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.applicationId, applicationId) ||
                other.applicationId == applicationId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.detail, detail) || other.detail == detail) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, applicationId, eventType,
      title, detail, timestamp, createdAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimelineEventResponseImplCopyWith<_$TimelineEventResponseImpl>
      get copyWith => __$$TimelineEventResponseImplCopyWithImpl<
          _$TimelineEventResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TimelineEventResponseImplToJson(
      this,
    );
  }
}

abstract class _TimelineEventResponse implements TimelineEventResponse {
  const factory _TimelineEventResponse(
          {required final int id,
          @JsonKey(name: 'application_id') required final int applicationId,
          @JsonKey(name: 'event_type') required final String eventType,
          required final String title,
          final String? detail,
          final DateTime? timestamp,
          @JsonKey(name: 'created_at') required final DateTime createdAt}) =
      _$TimelineEventResponseImpl;

  factory _TimelineEventResponse.fromJson(Map<String, dynamic> json) =
      _$TimelineEventResponseImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'application_id')
  int get applicationId;
  @override
  @JsonKey(name: 'event_type')
  String get eventType;
  @override
  String get title;
  @override
  String? get detail;
  @override
  DateTime? get timestamp;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(ignore: true)
  _$$TimelineEventResponseImplCopyWith<_$TimelineEventResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
