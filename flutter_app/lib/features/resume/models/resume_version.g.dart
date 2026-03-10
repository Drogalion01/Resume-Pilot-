// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'resume_version.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ResumeResponseImpl _$$ResumeResponseImplFromJson(Map<String, dynamic> json) =>
    _$ResumeResponseImpl(
      id: (json['id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      title: json['title'] as String,
      originalFilePath: json['original_file_path'] as String?,
      fileType: json['file_type'] as String?,
      rawText: json['raw_text'] as String?,
      parsedJson: json['parsed_json'],
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ResumeResponseImplToJson(
        _$ResumeResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'title': instance.title,
      'original_file_path': instance.originalFilePath,
      'file_type': instance.fileType,
      'raw_text': instance.rawText,
      'parsed_json': instance.parsedJson,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$ResumeVersionResponseImpl _$$ResumeVersionResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ResumeVersionResponseImpl(
      id: (json['id'] as num).toInt(),
      resumeId: (json['resume_id'] as num).toInt(),
      userId: (json['user_id'] as num).toInt(),
      versionName: json['version_name'] as String?,
      targetRole: json['target_role'] as String?,
      companyName: json['company_name'] as String?,
      tag: json['tag'] as String?,
      editedText: json['edited_text'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ResumeVersionResponseImplToJson(
        _$ResumeVersionResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'resume_id': instance.resumeId,
      'user_id': instance.userId,
      'version_name': instance.versionName,
      'target_role': instance.targetRole,
      'company_name': instance.companyName,
      'tag': instance.tag,
      'edited_text': instance.editedText,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };
