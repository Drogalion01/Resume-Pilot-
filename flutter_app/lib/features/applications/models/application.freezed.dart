// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'application.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ApplicationResponse _$ApplicationResponseFromJson(Map<String, dynamic> json) {
  return _ApplicationResponse.fromJson(json);
}

/// @nodoc
mixin _$ApplicationResponse {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  ApplicationStatus get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'application_date')
  DateTime? get applicationDate => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'recruiter_name')
  String? get recruiterName => throw _privateConstructorUsedError;
  @JsonKey(name: 'notes_summary')
  String? get notesSummary => throw _privateConstructorUsedError;
  @JsonKey(name: 'resume_version_id')
  int? get resumeVersionId => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApplicationResponseCopyWith<ApplicationResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationResponseCopyWith<$Res> {
  factory $ApplicationResponseCopyWith(
          ApplicationResponse value, $Res Function(ApplicationResponse) then) =
      _$ApplicationResponseCopyWithImpl<$Res, ApplicationResponse>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'company_name') String companyName,
      String role,
      ApplicationStatus status,
      @JsonKey(name: 'application_date') DateTime? applicationDate,
      String? source,
      String? location,
      @JsonKey(name: 'recruiter_name') String? recruiterName,
      @JsonKey(name: 'notes_summary') String? notesSummary,
      @JsonKey(name: 'resume_version_id') int? resumeVersionId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$ApplicationResponseCopyWithImpl<$Res, $Val extends ApplicationResponse>
    implements $ApplicationResponseCopyWith<$Res> {
  _$ApplicationResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? companyName = null,
    Object? role = null,
    Object? status = null,
    Object? applicationDate = freezed,
    Object? source = freezed,
    Object? location = freezed,
    Object? recruiterName = freezed,
    Object? notesSummary = freezed,
    Object? resumeVersionId = freezed,
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
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      applicationDate: freezed == applicationDate
          ? _value.applicationDate
          : applicationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      recruiterName: freezed == recruiterName
          ? _value.recruiterName
          : recruiterName // ignore: cast_nullable_to_non_nullable
              as String?,
      notesSummary: freezed == notesSummary
          ? _value.notesSummary
          : notesSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      resumeVersionId: freezed == resumeVersionId
          ? _value.resumeVersionId
          : resumeVersionId // ignore: cast_nullable_to_non_nullable
              as int?,
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
abstract class _$$ApplicationResponseImplCopyWith<$Res>
    implements $ApplicationResponseCopyWith<$Res> {
  factory _$$ApplicationResponseImplCopyWith(_$ApplicationResponseImpl value,
          $Res Function(_$ApplicationResponseImpl) then) =
      __$$ApplicationResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'company_name') String companyName,
      String role,
      ApplicationStatus status,
      @JsonKey(name: 'application_date') DateTime? applicationDate,
      String? source,
      String? location,
      @JsonKey(name: 'recruiter_name') String? recruiterName,
      @JsonKey(name: 'notes_summary') String? notesSummary,
      @JsonKey(name: 'resume_version_id') int? resumeVersionId,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$ApplicationResponseImplCopyWithImpl<$Res>
    extends _$ApplicationResponseCopyWithImpl<$Res, _$ApplicationResponseImpl>
    implements _$$ApplicationResponseImplCopyWith<$Res> {
  __$$ApplicationResponseImplCopyWithImpl(_$ApplicationResponseImpl _value,
      $Res Function(_$ApplicationResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? companyName = null,
    Object? role = null,
    Object? status = null,
    Object? applicationDate = freezed,
    Object? source = freezed,
    Object? location = freezed,
    Object? recruiterName = freezed,
    Object? notesSummary = freezed,
    Object? resumeVersionId = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ApplicationResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus,
      applicationDate: freezed == applicationDate
          ? _value.applicationDate
          : applicationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      recruiterName: freezed == recruiterName
          ? _value.recruiterName
          : recruiterName // ignore: cast_nullable_to_non_nullable
              as String?,
      notesSummary: freezed == notesSummary
          ? _value.notesSummary
          : notesSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      resumeVersionId: freezed == resumeVersionId
          ? _value.resumeVersionId
          : resumeVersionId // ignore: cast_nullable_to_non_nullable
              as int?,
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
class _$ApplicationResponseImpl implements _ApplicationResponse {
  const _$ApplicationResponseImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'company_name') required this.companyName,
      required this.role,
      required this.status,
      @JsonKey(name: 'application_date') this.applicationDate,
      this.source,
      this.location,
      @JsonKey(name: 'recruiter_name') this.recruiterName,
      @JsonKey(name: 'notes_summary') this.notesSummary,
      @JsonKey(name: 'resume_version_id') this.resumeVersionId,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt});

  factory _$ApplicationResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationResponseImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  @JsonKey(name: 'company_name')
  final String companyName;
  @override
  final String role;
  @override
  final ApplicationStatus status;
  @override
  @JsonKey(name: 'application_date')
  final DateTime? applicationDate;
  @override
  final String? source;
  @override
  final String? location;
  @override
  @JsonKey(name: 'recruiter_name')
  final String? recruiterName;
  @override
  @JsonKey(name: 'notes_summary')
  final String? notesSummary;
  @override
  @JsonKey(name: 'resume_version_id')
  final int? resumeVersionId;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ApplicationResponse(id: $id, userId: $userId, companyName: $companyName, role: $role, status: $status, applicationDate: $applicationDate, source: $source, location: $location, recruiterName: $recruiterName, notesSummary: $notesSummary, resumeVersionId: $resumeVersionId, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.applicationDate, applicationDate) ||
                other.applicationDate == applicationDate) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.recruiterName, recruiterName) ||
                other.recruiterName == recruiterName) &&
            (identical(other.notesSummary, notesSummary) ||
                other.notesSummary == notesSummary) &&
            (identical(other.resumeVersionId, resumeVersionId) ||
                other.resumeVersionId == resumeVersionId) &&
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
      companyName,
      role,
      status,
      applicationDate,
      source,
      location,
      recruiterName,
      notesSummary,
      resumeVersionId,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationResponseImplCopyWith<_$ApplicationResponseImpl> get copyWith =>
      __$$ApplicationResponseImplCopyWithImpl<_$ApplicationResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationResponseImplToJson(
      this,
    );
  }
}

abstract class _ApplicationResponse implements ApplicationResponse {
  const factory _ApplicationResponse(
          {required final int id,
          @JsonKey(name: 'user_id') required final int userId,
          @JsonKey(name: 'company_name') required final String companyName,
          required final String role,
          required final ApplicationStatus status,
          @JsonKey(name: 'application_date') final DateTime? applicationDate,
          final String? source,
          final String? location,
          @JsonKey(name: 'recruiter_name') final String? recruiterName,
          @JsonKey(name: 'notes_summary') final String? notesSummary,
          @JsonKey(name: 'resume_version_id') final int? resumeVersionId,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$ApplicationResponseImpl;

  factory _ApplicationResponse.fromJson(Map<String, dynamic> json) =
      _$ApplicationResponseImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  @JsonKey(name: 'company_name')
  String get companyName;
  @override
  String get role;
  @override
  ApplicationStatus get status;
  @override
  @JsonKey(name: 'application_date')
  DateTime? get applicationDate;
  @override
  String? get source;
  @override
  String? get location;
  @override
  @JsonKey(name: 'recruiter_name')
  String? get recruiterName;
  @override
  @JsonKey(name: 'notes_summary')
  String? get notesSummary;
  @override
  @JsonKey(name: 'resume_version_id')
  int? get resumeVersionId;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ApplicationResponseImplCopyWith<_$ApplicationResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ApplicationCreate _$ApplicationCreateFromJson(Map<String, dynamic> json) {
  return _ApplicationCreate.fromJson(json);
}

/// @nodoc
mixin _$ApplicationCreate {
  @JsonKey(name: 'company_name')
  String get companyName => throw _privateConstructorUsedError;
  String get role => throw _privateConstructorUsedError;
  ApplicationStatus? get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'application_date')
  DateTime? get applicationDate => throw _privateConstructorUsedError;
  String? get source => throw _privateConstructorUsedError;
  String? get location => throw _privateConstructorUsedError;
  @JsonKey(name: 'recruiter_name')
  String? get recruiterName => throw _privateConstructorUsedError;
  @JsonKey(name: 'notes_summary')
  String? get notesSummary => throw _privateConstructorUsedError;
  @JsonKey(name: 'resume_version_id')
  int? get resumeVersionId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ApplicationCreateCopyWith<ApplicationCreate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApplicationCreateCopyWith<$Res> {
  factory $ApplicationCreateCopyWith(
          ApplicationCreate value, $Res Function(ApplicationCreate) then) =
      _$ApplicationCreateCopyWithImpl<$Res, ApplicationCreate>;
  @useResult
  $Res call(
      {@JsonKey(name: 'company_name') String companyName,
      String role,
      ApplicationStatus? status,
      @JsonKey(name: 'application_date') DateTime? applicationDate,
      String? source,
      String? location,
      @JsonKey(name: 'recruiter_name') String? recruiterName,
      @JsonKey(name: 'notes_summary') String? notesSummary,
      @JsonKey(name: 'resume_version_id') int? resumeVersionId});
}

/// @nodoc
class _$ApplicationCreateCopyWithImpl<$Res, $Val extends ApplicationCreate>
    implements $ApplicationCreateCopyWith<$Res> {
  _$ApplicationCreateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyName = null,
    Object? role = null,
    Object? status = freezed,
    Object? applicationDate = freezed,
    Object? source = freezed,
    Object? location = freezed,
    Object? recruiterName = freezed,
    Object? notesSummary = freezed,
    Object? resumeVersionId = freezed,
  }) {
    return _then(_value.copyWith(
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus?,
      applicationDate: freezed == applicationDate
          ? _value.applicationDate
          : applicationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      recruiterName: freezed == recruiterName
          ? _value.recruiterName
          : recruiterName // ignore: cast_nullable_to_non_nullable
              as String?,
      notesSummary: freezed == notesSummary
          ? _value.notesSummary
          : notesSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      resumeVersionId: freezed == resumeVersionId
          ? _value.resumeVersionId
          : resumeVersionId // ignore: cast_nullable_to_non_nullable
              as int?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ApplicationCreateImplCopyWith<$Res>
    implements $ApplicationCreateCopyWith<$Res> {
  factory _$$ApplicationCreateImplCopyWith(_$ApplicationCreateImpl value,
          $Res Function(_$ApplicationCreateImpl) then) =
      __$$ApplicationCreateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'company_name') String companyName,
      String role,
      ApplicationStatus? status,
      @JsonKey(name: 'application_date') DateTime? applicationDate,
      String? source,
      String? location,
      @JsonKey(name: 'recruiter_name') String? recruiterName,
      @JsonKey(name: 'notes_summary') String? notesSummary,
      @JsonKey(name: 'resume_version_id') int? resumeVersionId});
}

/// @nodoc
class __$$ApplicationCreateImplCopyWithImpl<$Res>
    extends _$ApplicationCreateCopyWithImpl<$Res, _$ApplicationCreateImpl>
    implements _$$ApplicationCreateImplCopyWith<$Res> {
  __$$ApplicationCreateImplCopyWithImpl(_$ApplicationCreateImpl _value,
      $Res Function(_$ApplicationCreateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? companyName = null,
    Object? role = null,
    Object? status = freezed,
    Object? applicationDate = freezed,
    Object? source = freezed,
    Object? location = freezed,
    Object? recruiterName = freezed,
    Object? notesSummary = freezed,
    Object? resumeVersionId = freezed,
  }) {
    return _then(_$ApplicationCreateImpl(
      companyName: null == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String,
      role: null == role
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as String,
      status: freezed == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as ApplicationStatus?,
      applicationDate: freezed == applicationDate
          ? _value.applicationDate
          : applicationDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      source: freezed == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String?,
      location: freezed == location
          ? _value.location
          : location // ignore: cast_nullable_to_non_nullable
              as String?,
      recruiterName: freezed == recruiterName
          ? _value.recruiterName
          : recruiterName // ignore: cast_nullable_to_non_nullable
              as String?,
      notesSummary: freezed == notesSummary
          ? _value.notesSummary
          : notesSummary // ignore: cast_nullable_to_non_nullable
              as String?,
      resumeVersionId: freezed == resumeVersionId
          ? _value.resumeVersionId
          : resumeVersionId // ignore: cast_nullable_to_non_nullable
              as int?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ApplicationCreateImpl implements _ApplicationCreate {
  const _$ApplicationCreateImpl(
      {@JsonKey(name: 'company_name') required this.companyName,
      required this.role,
      this.status,
      @JsonKey(name: 'application_date') this.applicationDate,
      this.source,
      this.location,
      @JsonKey(name: 'recruiter_name') this.recruiterName,
      @JsonKey(name: 'notes_summary') this.notesSummary,
      @JsonKey(name: 'resume_version_id') this.resumeVersionId});

  factory _$ApplicationCreateImpl.fromJson(Map<String, dynamic> json) =>
      _$$ApplicationCreateImplFromJson(json);

  @override
  @JsonKey(name: 'company_name')
  final String companyName;
  @override
  final String role;
  @override
  final ApplicationStatus? status;
  @override
  @JsonKey(name: 'application_date')
  final DateTime? applicationDate;
  @override
  final String? source;
  @override
  final String? location;
  @override
  @JsonKey(name: 'recruiter_name')
  final String? recruiterName;
  @override
  @JsonKey(name: 'notes_summary')
  final String? notesSummary;
  @override
  @JsonKey(name: 'resume_version_id')
  final int? resumeVersionId;

  @override
  String toString() {
    return 'ApplicationCreate(companyName: $companyName, role: $role, status: $status, applicationDate: $applicationDate, source: $source, location: $location, recruiterName: $recruiterName, notesSummary: $notesSummary, resumeVersionId: $resumeVersionId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ApplicationCreateImpl &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.role, role) || other.role == role) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.applicationDate, applicationDate) ||
                other.applicationDate == applicationDate) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.location, location) ||
                other.location == location) &&
            (identical(other.recruiterName, recruiterName) ||
                other.recruiterName == recruiterName) &&
            (identical(other.notesSummary, notesSummary) ||
                other.notesSummary == notesSummary) &&
            (identical(other.resumeVersionId, resumeVersionId) ||
                other.resumeVersionId == resumeVersionId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      companyName,
      role,
      status,
      applicationDate,
      source,
      location,
      recruiterName,
      notesSummary,
      resumeVersionId);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ApplicationCreateImplCopyWith<_$ApplicationCreateImpl> get copyWith =>
      __$$ApplicationCreateImplCopyWithImpl<_$ApplicationCreateImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ApplicationCreateImplToJson(
      this,
    );
  }
}

abstract class _ApplicationCreate implements ApplicationCreate {
  const factory _ApplicationCreate(
          {@JsonKey(name: 'company_name') required final String companyName,
          required final String role,
          final ApplicationStatus? status,
          @JsonKey(name: 'application_date') final DateTime? applicationDate,
          final String? source,
          final String? location,
          @JsonKey(name: 'recruiter_name') final String? recruiterName,
          @JsonKey(name: 'notes_summary') final String? notesSummary,
          @JsonKey(name: 'resume_version_id') final int? resumeVersionId}) =
      _$ApplicationCreateImpl;

  factory _ApplicationCreate.fromJson(Map<String, dynamic> json) =
      _$ApplicationCreateImpl.fromJson;

  @override
  @JsonKey(name: 'company_name')
  String get companyName;
  @override
  String get role;
  @override
  ApplicationStatus? get status;
  @override
  @JsonKey(name: 'application_date')
  DateTime? get applicationDate;
  @override
  String? get source;
  @override
  String? get location;
  @override
  @JsonKey(name: 'recruiter_name')
  String? get recruiterName;
  @override
  @JsonKey(name: 'notes_summary')
  String? get notesSummary;
  @override
  @JsonKey(name: 'resume_version_id')
  int? get resumeVersionId;
  @override
  @JsonKey(ignore: true)
  _$$ApplicationCreateImplCopyWith<_$ApplicationCreateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
