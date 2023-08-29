// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_modifier_v2_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V2ItemModifierGroupModel _$V2ItemModifierGroupModelFromJson(
        Map<String, dynamic> json) =>
    V2ItemModifierGroupModel(
      id: json['id'] as int?,
      title: json['title'] == null
          ? null
          : V2TitleModel.fromJson(json['title'] as Map<String, dynamic>),
      description: json['description'] == null
          ? null
          : V2TitleModel.fromJson(json['description'] as Map<String, dynamic>),
      sequence: json['sequence'] as int?,
      enabled: json['enabled'] as bool?,
      min: json['min'] as int?,
      max: json['max'] as int?,
      visibilities: (json['visibilities'] as List<dynamic>?)
          ?.map((e) => V2VisibilityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      modifiers: (json['modifiers'] as List<dynamic>?)
          ?.map((e) => V2ItemModifierModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$V2ItemModifierGroupModelToJson(
        V2ItemModifierGroupModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'sequence': instance.sequence,
      'enabled': instance.enabled,
      'min': instance.min,
      'max': instance.max,
      'visibilities': instance.visibilities,
      'modifiers': instance.modifiers,
    };

V2ItemModifierModel _$V2ItemModifierModelFromJson(Map<String, dynamic> json) =>
    V2ItemModifierModel(
      id: json['id'] as int?,
      title: json['title'] == null
          ? null
          : V2TitleModel.fromJson(json['title'] as Map<String, dynamic>),
      description: json['description'] == null
          ? null
          : V2TitleModel.fromJson(json['description'] as Map<String, dynamic>),
      vat: json['vat'] as num?,
      enabled: json['enabled'] as bool?,
      visibilities: (json['visibilities'] as List<dynamic>?)
          ?.map((e) => V2VisibilityModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => V2PriceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      isCustomPrice: json['isCustomPrice'] as bool?,
      itemIsEnabled: json['itemIsEnabled'] as bool?,
      resources: (json['resources'] as List<dynamic>?)
          ?.map((e) => V2ResourcesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      maxQuantityPerDay: json['maxQuantityPerDay'] as int?,
      oos: json['oos'] == null
          ? null
          : V2OosModel.fromJson(json['oos'] as Map<String, dynamic>),
      groups: (json['groups'] as List<dynamic>?)
          ?.map((e) =>
              V2ItemModifierGroupModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$V2ItemModifierModelToJson(
        V2ItemModifierModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'vat': instance.vat,
      'enabled': instance.enabled,
      'visibilities': instance.visibilities,
      'prices': instance.prices,
      'isCustomPrice': instance.isCustomPrice,
      'itemIsEnabled': instance.itemIsEnabled,
      'resources': instance.resources,
      'maxQuantityPerDay': instance.maxQuantityPerDay,
      'oos': instance.oos,
      'groups': instance.groups,
    };
