// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApplicationDetailResponse _$ApplicationDetailResponseFromJson(
    Map<String, dynamic> json) {
  return _ApplicationDetailResponse.fromJson(json);
}

/// @nodoc
mixin _$ApplicationDetailResponse {
  ApplicationResponse get application => throw _privateConstructorUsedError;
  @JsonKey(name: 'timeline_events')
  List<TimelineEventResponse> get timelineEvents =>
      throw _privateConstructorUsedError;
  List<InterviewResponse> get interviews => throw _privateConstructorUsedError;
  List<ReminderResponse> get reminders => throw _privateConstructorUsedError;
  List<NoteResponse> get notes => throw _privateConstructorUsedError;
  @JsonKey(name: 'resume_version')
  ResumeVersionResponse? get resumeVersion =>
      throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApplicationDetailResponseCopyWith<ApplicationDetailResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationDetailResponseCopyWith<$Res> {
  factory $ApplicationDetailResponseCopyWith(ApplicationDetailResponse value,
          $Res Function(ApplicationDetailResponse) then) =
      _$ApplicationDetailResponseCopyWithImpl<$Res, ApplicationDetailResponse>;
  @useResult
  $Res call(
      {ApplicationResponse application,
      @JsonKey(name: 'timeline_events')
      List<TimelineEventResponse> timelineEvents,
      List<InterviewResponse> interviews,
      List<ReminderResponse> reminders,
      List<NoteResponse> notes,
      @JsonKey(name: 'resume_version') ResumeVersionResponse? resumeVersion});

  $ApplicationResponseCopyWith<$Res> get application;
  $ResumeVersionResponseCopyWith<$Res>? get resumeVersion;
}

/// @nodoc
class _$ApplicationDetailResponseCopyWithImpl<$Res,
        $Val extends ApplicationDetailResponse>
    implements $ApplicationDetailResponseCopyWith<$Res> {
  _$ApplicationDetailResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? application = null,
    Object? timelineEvents = null,
    Object? interviews = null,
    Object? reminders = null,
    Object? notes = null,
    Object? resumeVersion = freezed,
  }) {
    return _then(_value.copyWith(
      application: null == application
          ? _value.application
          : application // ignore: cast_nullable_to_non_nullable
              as ApplicationResponse,
      timelineEvents: null == timelineEvents
          ? _value.timelineEvents
          : timelineEvents // ignore: cast_nullable_to_non_nullable
              as List<TimelineEventResponse>,
      interviews: null == interviews
          ? _value.interviews
          : interviews // ignore: cast_nullable_to_non_nullable
              as List<InterviewResponse>,
      reminders: null == reminders
          ? _value.reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<ReminderResponse>,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<NoteResponse>,
      resumeVersion: freezed == resumeVersion
          ? _value.resumeVersion
          : resumeVersion // ignore: cast_nullable_to_non_nullable
              as ResumeVersionResponse?,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $ApplicationResponseCopyWith<$Res> get application {
    return $ApplicationResponseCopyWith<$Res>(_value.application, (value) {
      return _then(_value.copyWith(application: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ResumeVersionResponseCopyWith<$Res>? get resumeVersion {
    if (_value.resumeVersion == null) {
      return null;
    }

    return $ResumeVersionResponseCopyWith<$Res>(_value.resumeVersion!, (value) {
      return _then(_value.copyWith(resumeVersion: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$ApplicationDetailResponseImplCopyWith<$Res>
    implements $ApplicationDetailResponseCopyWith<$Res> {
  factory _$$ApplicationDetailResponseImplCopyWith(
          _$ApplicationDetailResponseImpl value,
          $Res Function(_$ApplicationDetailResponseImpl) then) =
      __$$ApplicationDetailResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {ApplicationResponse application,
      @JsonKey(name: 'timeline_events')
      List<TimelineEventResponse> timelineEvents,
      List<InterviewResponse> interviews,
      List<ReminderResponse> reminders,
      List<NoteResponse> notes,
      @JsonKey(name: 'resume_version') ResumeVersionResponse? resumeVersion});

  @override
  $ApplicationResponseCopyWith<$Res> get application;
  @override
  $ResumeVersionResponseCopyWith<$Res>? get resumeVersion;
}

/// @nodoc
class __$$ApplicationDetailResponseImplCopyWithImpl<$Res>
    extends _$ApplicationDetailResponseCopyWithImpl<$Res,
        _$ApplicationDetailResponseImpl>
    implements _$$ApplicationDetailResponseImplCopyWith<$Res> {
  __$$ApplicationDetailResponseImplCopyWithImpl(
      _$ApplicationDetailResponseImpl _value,
      $Res Function(_$ApplicationDetailResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? application = null,
    Object? timelineEvents = null,
    Object? interviews = null,
    Object? reminders = null,
    Object? notes = null,
    Object? resumeVersion = freezed,
  }) {
    return _then(_$ApplicationDetailResponseImpl(
      application: null == application
          ? _value.application
          : application // ignore: cast_nullable_to_non_nullable
              as ApplicationResponse,
      timelineEvents: null == timelineEvents
          ? _value._timelineEvents
          : timelineEvents // ignore: cast_nullable_to_non_nullable
              as List<TimelineEventResponse>,
      interviews: null == interviews
          ? _value._interviews
          : interviews // ignore: cast_nullable_to_non_nullable
              as List<InterviewResponse>,
      reminders: null == reminders
          ? _value._reminders
          : reminders // ignore: cast_nullable_to_non_nullable
              as List<ReminderResponse>,
      notes: null == notes
          ? _value._notes
          : notes // ignore: cast_nullable_to_non_nullable
              as List<NoteResponse>,
      resumeVersion: freezed == resumeVersion
          ? _value.resumeVersion
          : resumeVersion // ignore: cast_nullable_to_non_nullable
              as ResumeVersionResponse?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationDetailResponseImpl implements _ApplicationDetailResponse {
  const _$ApplicationDetailResponseImpl(
      {required this.application,
      @JsonKey(name: 'timeline_events')
      final List<TimelineEventResponse> timelineEvents = const [],
      final List<InterviewResponse> interviews = const [],
      final List<ReminderResponse> reminders = const [],
      final List<NoteResponse> notes = const [],
      @JsonKey(name: 'resume_version') this.resumeVersion})
      : _timelineEvents = timelineEvents,
        _interviews = interviews,
        _reminders = reminders,
        _notes = notes;

  factory _$ApplicationDetailResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationDetailResponseImplFromJson(json);

  @override
  final ApplicationResponse application;
  final List<TimelineEventResponse> _timelineEvents;
  @override
  @JsonKey(name: 'timeline_events')
  List<TimelineEventResponse> get timelineEvents {
    if (_timelineEvents is EqualUnmodifiableListView) return _timelineEvents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_timelineEvents);
  }

  final List<InterviewResponse> _interviews;
  @override
  @JsonKey()
  List<InterviewResponse> get interviews {
    if (_interviews is EqualUnmodifiableListView) return _interviews;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_interviews);
  }

  final List<ReminderResponse> _reminders;
  @override
  @JsonKey()
  List<ReminderResponse> get reminders {
    if (_reminders is EqualUnmodifiableListView) return _reminders;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reminders);
  }

  final List<NoteResponse> _notes;
  @override
  @JsonKey()
  List<NoteResponse> get notes {
    if (_notes is EqualUnmodifiableListView) return _notes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_notes);
  }

  @override
  @JsonKey(name: 'resume_version')
  final ResumeVersionResponse? resumeVersion;

  @override
  String toString() {
    return 'ApplicationDetailResponse(application: $application, timelineEvents: $timelineEvents, interviews: $interviews, reminders: $reminders, notes: $notes, resumeVersion: $resumeVersion)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationDetailResponseImpl &&
            (identical(other.application, application) ||
                other.application == application) &&
            const DeepCollectionEquality()
                .equals(other._timelineEvents, _timelineEvents) &&
            const DeepCollectionEquality()
                .equals(other._interviews, _interviews) &&
            const DeepCollectionEquality()
                .equals(other._reminders, _reminders) &&
            const DeepCollectionEquality().equals(other._notes, _notes) &&
            (identical(other.resumeVersion, resumeVersion) ||
                other.resumeVersion == resumeVersion));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      application,
      const DeepCollectionEquality().hash(_timelineEvents),
      const DeepCollectionEquality().hash(_interviews),
      const DeepCollectionEquality().hash(_reminders),
      const DeepCollectionEquality().hash(_notes),
      resumeVersion);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationDetailResponseImplCopyWith<_$ApplicationDetailResponseImpl>
      get copyWith => __$$ApplicationDetailResponseImplCopyWithImpl<
          _$ApplicationDetailResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationDetailResponseImplToJson(
      this,
    );
  }
}

abstract class _ApplicationDetailResponse implements ApplicationDetailResponse {
  const factory _ApplicationDetailResponse(
          {required final ApplicationResponse application,
          @JsonKey(name: 'timeline_events')
          final List<TimelineEventResponse> timelineEvents,
          final List<InterviewResponse> interviews,
          final List<ReminderResponse> reminders,
          final List<NoteResponse> notes,
          @JsonKey(name: 'resume_version')
          final ResumeVersionResponse? resumeVersion}) =
      _$ApplicationDetailResponseImpl;

  factory _ApplicationDetailResponse.fromJson(Map<String, dynamic> json) =
      _$ApplicationDetailResponseImpl.fromJson;

  @override
  ApplicationResponse get application;
  @override
  @JsonKey(name: 'timeline_events')
  List<TimelineEventResponse> get timelineEvents;
  @override
  List<InterviewResponse> get interviews;
  @override
  List<ReminderResponse> get reminders;
  @override
  List<NoteResponse> get notes;
  @override
  @JsonKey(name: 'resume_version')
  ResumeVersionResponse? get resumeVersion;
  @override
  @JsonKey(ignore: true)
  _$$ApplicationDetailResponseImplCopyWith<_$ApplicationDetailResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
