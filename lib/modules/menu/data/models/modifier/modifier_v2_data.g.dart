// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_v2_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V2ModifierGroupModel _$V2ModifierGroupModelFromJson(
        Map<String, dynamic> json) =>
    V2ModifierGroupModel(
      id: json['id'] as int?,
      businessID: json['businessID'] as int?,
      title: json['title'] == null
          ? null
          : V2TitleModel.fromJson(json['title'] as Map<String, dynamic>),
      description: json['description'] == null
          ? null
          : V2TitleModel.fromJson(json['description'] as Map<String, dynamic>),
      visibilities: (json['visibilities'] as List<dynamic>?)
          ?.map((e) => V2VisibilityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isEnabled: json['isEnabled'] as bool?,
      groupedModifiers: (json['groupedModifiers'] as List<dynamic>?)
          ?.map((e) =>
              V2GroupedModifiersModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$V2ModifierGroupModelToJson(
        V2ModifierGroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'businessID': instance.businessID,
      'title': instance.title,
      'description': instance.description,
      'visibilities': instance.visibilities,
      'isEnabled': instance.isEnabled,
      'groupedModifiers': instance.groupedModifiers,
    };

V2GroupedModifiersModel _$V2GroupedModifiersModelFromJson(
        Map<String, dynamic> json) =>
    V2GroupedModifiersModel(
      id: json['id'] as int?,
      title: json['title'] == null
          ? null
          : V2TitleModel.fromJson(json['title'] as Map<String, dynamic>),
      description: json['description'] == null
          ? null
          : V2TitleModel.fromJson(json['description'] as Map<String, dynamic>),
      visibilities: (json['visibilities'] as List<dynamic>?)
          ?.map((e) => V2VisibilityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isEnabled: json['isEnabled'] as bool?,
      sequence: json['sequence'] as int?,
    );

Map<String, dynamic> _$V2GroupedModifiersModelToJson(
        V2GroupedModifiersModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'visibilities': instance.visibilities,
      'isEnabled': instance.isEnabled,
      'sequence': instance.sequence,
    };
