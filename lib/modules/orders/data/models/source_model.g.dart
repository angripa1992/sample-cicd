// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SourcesModel _$SourcesModelFromJson(Map<String, dynamic> json) => SourcesModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      sources: (json['sources'] as List<dynamic>?)
          ?.map((e) => SourceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SourcesModelToJson(SourcesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'sources': instance.sources,
    };

SourceModel _$SourceModelFromJson(Map<String, dynamic> json) => SourceModel(
      id: json['id'] as int?,
      name: json['name'] as String?,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$SourceModelToJson(SourceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
    };
