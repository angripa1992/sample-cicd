// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusesModel _$StatusesModelFromJson(Map<String, dynamic> json) =>
    StatusesModel(
      providerId: json['provider_id'] as int?,
      hidden: json['hidden'] as bool?,
      enabled: json['enabled'] as bool?,
    );

Map<String, dynamic> _$StatusesModelToJson(StatusesModel instance) =>
    <String, dynamic>{
      'provider_id': instance.providerId,
      'hidden': instance.hidden,
      'enabled': instance.enabled,
    };
