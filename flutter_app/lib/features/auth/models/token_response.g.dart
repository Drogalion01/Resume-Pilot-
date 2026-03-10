// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TokenResponseImpl _$$TokenResponseImplFromJson(Map<String, dynamic> json) =>
    _$TokenResponseImpl(
      accessToken: json['access_token'] as String,
      tokenType: json['token_type'] as String,
      user: AuthUserPayload.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$TokenResponseImplToJson(_$TokenResponseImpl instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'token_type': instance.tokenType,
      'user': instance.user,
    };

_$AuthUserPayloadImpl _$$AuthUserPayloadImplFromJson(
        Map<String, dynamic> json) =>
    _$AuthUserPayloadImpl(
      id: (json['id'] as num).toInt(),
      fullName: json['full_name'] as String,
      email: json['email'] as String,
      initials: json['initials'] as String,
    );

Map<String, dynamic> _$$AuthUserPayloadImplToJson(
        _$AuthUserPayloadImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'full_name': instance.fullName,
      'email': instance.email,
      'initials': instance.initials,
    };
