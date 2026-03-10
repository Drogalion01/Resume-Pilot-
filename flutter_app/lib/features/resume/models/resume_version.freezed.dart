// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'resume_version.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ResumeResponse _$ResumeResponseFromJson(Map<String, dynamic> json) {
  return _ResumeResponse.fromJson(json);
}

/// @nodoc
mixin _$ResumeResponse {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  @JsonKey(name: 'original_file_path')
  String? get originalFilePath => throw _privateConstructorUsedError;
  @JsonKey(name: 'file_type')
  String? get fileType => throw _privateConstructorUsedError;
  @JsonKey(name: 'raw_text')
  String? get rawText => throw _privateConstructorUsedError;
  @JsonKey(name: 'parsed_json')
  dynamic get parsedJson => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResumeResponseCopyWith<ResumeResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResumeResponseCopyWith<$Res> {
  factory $ResumeResponseCopyWith(
          ResumeResponse value, $Res Function(ResumeResponse) then) =
      _$ResumeResponseCopyWithImpl<$Res, ResumeResponse>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') int userId,
      String title,
      @JsonKey(name: 'original_file_path') String? originalFilePath,
      @JsonKey(name: 'file_type') String? fileType,
      @JsonKey(name: 'raw_text') String? rawText,
      @JsonKey(name: 'parsed_json') dynamic parsedJson,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$ResumeResponseCopyWithImpl<$Res, $Val extends ResumeResponse>
    implements $ResumeResponseCopyWith<$Res> {
  _$ResumeResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? originalFilePath = freezed,
    Object? fileType = freezed,
    Object? rawText = freezed,
    Object? parsedJson = freezed,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      originalFilePath: freezed == originalFilePath
          ? _value.originalFilePath
          : originalFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      fileType: freezed == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String?,
      rawText: freezed == rawText
          ? _value.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String?,
      parsedJson: freezed == parsedJson
          ? _value.parsedJson
          : parsedJson // ignore: cast_nullable_to_non_nullable
              as dynamic,
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
abstract class _$$ResumeResponseImplCopyWith<$Res>
    implements $ResumeResponseCopyWith<$Res> {
  factory _$$ResumeResponseImplCopyWith(_$ResumeResponseImpl value,
          $Res Function(_$ResumeResponseImpl) then) =
      __$$ResumeResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'user_id') int userId,
      String title,
      @JsonKey(name: 'original_file_path') String? originalFilePath,
      @JsonKey(name: 'file_type') String? fileType,
      @JsonKey(name: 'raw_text') String? rawText,
      @JsonKey(name: 'parsed_json') dynamic parsedJson,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$ResumeResponseImplCopyWithImpl<$Res>
    extends _$ResumeResponseCopyWithImpl<$Res, _$ResumeResponseImpl>
    implements _$$ResumeResponseImplCopyWith<$Res> {
  __$$ResumeResponseImplCopyWithImpl(
      _$ResumeResponseImpl _value, $Res Function(_$ResumeResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? originalFilePath = freezed,
    Object? fileType = freezed,
    Object? rawText = freezed,
    Object? parsedJson = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ResumeResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      originalFilePath: freezed == originalFilePath
          ? _value.originalFilePath
          : originalFilePath // ignore: cast_nullable_to_non_nullable
              as String?,
      fileType: freezed == fileType
          ? _value.fileType
          : fileType // ignore: cast_nullable_to_non_nullable
              as String?,
      rawText: freezed == rawText
          ? _value.rawText
          : rawText // ignore: cast_nullable_to_non_nullable
              as String?,
      parsedJson: freezed == parsedJson
          ? _value.parsedJson
          : parsedJson // ignore: cast_nullable_to_non_nullable
              as dynamic,
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
class _$ResumeResponseImpl extends _ResumeResponse {
  const _$ResumeResponseImpl(
      {required this.id,
      @JsonKey(name: 'user_id') required this.userId,
      required this.title,
      @JsonKey(name: 'original_file_path') this.originalFilePath,
      @JsonKey(name: 'file_type') this.fileType,
      @JsonKey(name: 'raw_text') this.rawText,
      @JsonKey(name: 'parsed_json') this.parsedJson,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : super._();

  factory _$ResumeResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResumeResponseImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  final String title;
  @override
  @JsonKey(name: 'original_file_path')
  final String? originalFilePath;
  @override
  @JsonKey(name: 'file_type')
  final String? fileType;
  @override
  @JsonKey(name: 'raw_text')
  final String? rawText;
  @override
  @JsonKey(name: 'parsed_json')
  final dynamic parsedJson;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ResumeResponse(id: $id, userId: $userId, title: $title, originalFilePath: $originalFilePath, fileType: $fileType, rawText: $rawText, parsedJson: $parsedJson, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResumeResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.originalFilePath, originalFilePath) ||
                other.originalFilePath == originalFilePath) &&
            (identical(other.fileType, fileType) ||
                other.fileType == fileType) &&
            (identical(other.rawText, rawText) || other.rawText == rawText) &&
            const DeepCollectionEquality()
                .equals(other.parsedJson, parsedJson) &&
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
      title,
      originalFilePath,
      fileType,
      rawText,
      const DeepCollectionEquality().hash(parsedJson),
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResumeResponseImplCopyWith<_$ResumeResponseImpl> get copyWith =>
      __$$ResumeResponseImplCopyWithImpl<_$ResumeResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResumeResponseImplToJson(
      this,
    );
  }
}

abstract class _ResumeResponse extends ResumeResponse {
  const factory _ResumeResponse(
          {required final int id,
          @JsonKey(name: 'user_id') required final int userId,
          required final String title,
          @JsonKey(name: 'original_file_path') final String? originalFilePath,
          @JsonKey(name: 'file_type') final String? fileType,
          @JsonKey(name: 'raw_text') final String? rawText,
          @JsonKey(name: 'parsed_json') final dynamic parsedJson,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$ResumeResponseImpl;
  const _ResumeResponse._() : super._();

  factory _ResumeResponse.fromJson(Map<String, dynamic> json) =
      _$ResumeResponseImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  String get title;
  @override
  @JsonKey(name: 'original_file_path')
  String? get originalFilePath;
  @override
  @JsonKey(name: 'file_type')
  String? get fileType;
  @override
  @JsonKey(name: 'raw_text')
  String? get rawText;
  @override
  @JsonKey(name: 'parsed_json')
  dynamic get parsedJson;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ResumeResponseImplCopyWith<_$ResumeResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ResumeVersionResponse _$ResumeVersionResponseFromJson(
    Map<String, dynamic> json) {
  return _ResumeVersionResponse.fromJson(json);
}

/// @nodoc
mixin _$ResumeVersionResponse {
  int get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'resume_id')
  int get resumeId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  int get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'version_name')
  String? get versionName => throw _privateConstructorUsedError;
  @JsonKey(name: 'target_role')
  String? get targetRole => throw _privateConstructorUsedError;
  @JsonKey(name: 'company_name')
  String? get companyName => throw _privateConstructorUsedError;
  String? get tag => throw _privateConstructorUsedError;
  @JsonKey(name: 'edited_text')
  String? get editedText => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ResumeVersionResponseCopyWith<ResumeVersionResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ResumeVersionResponseCopyWith<$Res> {
  factory $ResumeVersionResponseCopyWith(ResumeVersionResponse value,
          $Res Function(ResumeVersionResponse) then) =
      _$ResumeVersionResponseCopyWithImpl<$Res, ResumeVersionResponse>;
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'resume_id') int resumeId,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'version_name') String? versionName,
      @JsonKey(name: 'target_role') String? targetRole,
      @JsonKey(name: 'company_name') String? companyName,
      String? tag,
      @JsonKey(name: 'edited_text') String? editedText,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class _$ResumeVersionResponseCopyWithImpl<$Res,
        $Val extends ResumeVersionResponse>
    implements $ResumeVersionResponseCopyWith<$Res> {
  _$ResumeVersionResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? resumeId = null,
    Object? userId = null,
    Object? versionName = freezed,
    Object? targetRole = freezed,
    Object? companyName = freezed,
    Object? tag = freezed,
    Object? editedText = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      resumeId: null == resumeId
          ? _value.resumeId
          : resumeId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      versionName: freezed == versionName
          ? _value.versionName
          : versionName // ignore: cast_nullable_to_non_nullable
              as String?,
      targetRole: freezed == targetRole
          ? _value.targetRole
          : targetRole // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      tag: freezed == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String?,
      editedText: freezed == editedText
          ? _value.editedText
          : editedText // ignore: cast_nullable_to_non_nullable
              as String?,
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
abstract class _$$ResumeVersionResponseImplCopyWith<$Res>
    implements $ResumeVersionResponseCopyWith<$Res> {
  factory _$$ResumeVersionResponseImplCopyWith(
          _$ResumeVersionResponseImpl value,
          $Res Function(_$ResumeVersionResponseImpl) then) =
      __$$ResumeVersionResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      @JsonKey(name: 'resume_id') int resumeId,
      @JsonKey(name: 'user_id') int userId,
      @JsonKey(name: 'version_name') String? versionName,
      @JsonKey(name: 'target_role') String? targetRole,
      @JsonKey(name: 'company_name') String? companyName,
      String? tag,
      @JsonKey(name: 'edited_text') String? editedText,
      @JsonKey(name: 'created_at') DateTime createdAt,
      @JsonKey(name: 'updated_at') DateTime updatedAt});
}

/// @nodoc
class __$$ResumeVersionResponseImplCopyWithImpl<$Res>
    extends _$ResumeVersionResponseCopyWithImpl<$Res,
        _$ResumeVersionResponseImpl>
    implements _$$ResumeVersionResponseImplCopyWith<$Res> {
  __$$ResumeVersionResponseImplCopyWithImpl(_$ResumeVersionResponseImpl _value,
      $Res Function(_$ResumeVersionResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? resumeId = null,
    Object? userId = null,
    Object? versionName = freezed,
    Object? targetRole = freezed,
    Object? companyName = freezed,
    Object? tag = freezed,
    Object? editedText = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$ResumeVersionResponseImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      resumeId: null == resumeId
          ? _value.resumeId
          : resumeId // ignore: cast_nullable_to_non_nullable
              as int,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as int,
      versionName: freezed == versionName
          ? _value.versionName
          : versionName // ignore: cast_nullable_to_non_nullable
              as String?,
      targetRole: freezed == targetRole
          ? _value.targetRole
          : targetRole // ignore: cast_nullable_to_non_nullable
              as String?,
      companyName: freezed == companyName
          ? _value.companyName
          : companyName // ignore: cast_nullable_to_non_nullable
              as String?,
      tag: freezed == tag
          ? _value.tag
          : tag // ignore: cast_nullable_to_non_nullable
              as String?,
      editedText: freezed == editedText
          ? _value.editedText
          : editedText // ignore: cast_nullable_to_non_nullable
              as String?,
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
class _$ResumeVersionResponseImpl extends _ResumeVersionResponse {
  const _$ResumeVersionResponseImpl(
      {required this.id,
      @JsonKey(name: 'resume_id') required this.resumeId,
      @JsonKey(name: 'user_id') required this.userId,
      @JsonKey(name: 'version_name') this.versionName,
      @JsonKey(name: 'target_role') this.targetRole,
      @JsonKey(name: 'company_name') this.companyName,
      this.tag,
      @JsonKey(name: 'edited_text') this.editedText,
      @JsonKey(name: 'created_at') required this.createdAt,
      @JsonKey(name: 'updated_at') required this.updatedAt})
      : super._();

  factory _$ResumeVersionResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$ResumeVersionResponseImplFromJson(json);

  @override
  final int id;
  @override
  @JsonKey(name: 'resume_id')
  final int resumeId;
  @override
  @JsonKey(name: 'user_id')
  final int userId;
  @override
  @JsonKey(name: 'version_name')
  final String? versionName;
  @override
  @JsonKey(name: 'target_role')
  final String? targetRole;
  @override
  @JsonKey(name: 'company_name')
  final String? companyName;
  @override
  final String? tag;
  @override
  @JsonKey(name: 'edited_text')
  final String? editedText;
  @override
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime updatedAt;

  @override
  String toString() {
    return 'ResumeVersionResponse(id: $id, resumeId: $resumeId, userId: $userId, versionName: $versionName, targetRole: $targetRole, companyName: $companyName, tag: $tag, editedText: $editedText, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ResumeVersionResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.resumeId, resumeId) ||
                other.resumeId == resumeId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.versionName, versionName) ||
                other.versionName == versionName) &&
            (identical(other.targetRole, targetRole) ||
                other.targetRole == targetRole) &&
            (identical(other.companyName, companyName) ||
                other.companyName == companyName) &&
            (identical(other.tag, tag) || other.tag == tag) &&
            (identical(other.editedText, editedText) ||
                other.editedText == editedText) &&
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
      resumeId,
      userId,
      versionName,
      targetRole,
      companyName,
      tag,
      editedText,
      createdAt,
      updatedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ResumeVersionResponseImplCopyWith<_$ResumeVersionResponseImpl>
      get copyWith => __$$ResumeVersionResponseImplCopyWithImpl<
          _$ResumeVersionResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ResumeVersionResponseImplToJson(
      this,
    );
  }
}

abstract class _ResumeVersionResponse extends ResumeVersionResponse {
  const factory _ResumeVersionResponse(
          {required final int id,
          @JsonKey(name: 'resume_id') required final int resumeId,
          @JsonKey(name: 'user_id') required final int userId,
          @JsonKey(name: 'version_name') final String? versionName,
          @JsonKey(name: 'target_role') final String? targetRole,
          @JsonKey(name: 'company_name') final String? companyName,
          final String? tag,
          @JsonKey(name: 'edited_text') final String? editedText,
          @JsonKey(name: 'created_at') required final DateTime createdAt,
          @JsonKey(name: 'updated_at') required final DateTime updatedAt}) =
      _$ResumeVersionResponseImpl;
  const _ResumeVersionResponse._() : super._();

  factory _ResumeVersionResponse.fromJson(Map<String, dynamic> json) =
      _$ResumeVersionResponseImpl.fromJson;

  @override
  int get id;
  @override
  @JsonKey(name: 'resume_id')
  int get resumeId;
  @override
  @JsonKey(name: 'user_id')
  int get userId;
  @override
  @JsonKey(name: 'version_name')
  String? get versionName;
  @override
  @JsonKey(name: 'target_role')
  String? get targetRole;
  @override
  @JsonKey(name: 'company_name')
  String? get companyName;
  @override
  String? get tag;
  @override
  @JsonKey(name: 'edited_text')
  String? get editedText;
  @override
  @JsonKey(name: 'created_at')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime get updatedAt;
  @override
  @JsonKey(ignore: true)
  _$$ResumeVersionResponseImplCopyWith<_$ResumeVersionResponseImpl>
      get copyWith => throw _privateConstructorUsedError;
}
