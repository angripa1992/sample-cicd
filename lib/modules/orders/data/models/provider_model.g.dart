// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderModel _$ProviderModelFromJson(Map<String, dynamic> json) =>
    ProviderModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      value: json['value'] as String?,
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$ProviderModelToJson(ProviderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'value': instance.value,
      'logo': instance.logo,
    };
