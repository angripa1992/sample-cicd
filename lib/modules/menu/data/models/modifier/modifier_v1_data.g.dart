// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_v1_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V1ModifierGroupModel _$V1ModifierGroupModelFromJson(
        Map<String, dynamic> json) =>
    V1ModifierGroupModel(
      groupId: json['group_id'] as int?,
      title: json['title'] as String?,
      defaultData: json['defaultData'] as bool?,
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => V1StatusesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      modifiers: (json['modifiers'] as List<dynamic>?)
          ?.map((e) =>
              V1GroupedModifierItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$V1ModifierGroupModelToJson(
        V1ModifierGroupModel instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'title': instance.title,
      'defaultData': instance.defaultData,
      'statuses': instance.statuses,
      'modifiers': instance.modifiers,
    };

V1GroupedModifierItemModel _$V1GroupedModifierItemModelFromJson(
        Map<String, dynamic> json) =>
    V1GroupedModifierItemModel(
      modifierId: json['modifier_id'] as int?,
      title: json['title'] as String?,
      sequence: json['sequence'] as int?,
      defaultData: json['defaultData'] as bool?,
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => V1PricesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => V1StatusesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'],
    );

Map<String, dynamic> _$V1GroupedModifierItemModelToJson(
        V1GroupedModifierItemModel instance) =>
    <String, dynamic>{
      'modifier_id': instance.modifierId,
      'title': instance.title,
      'sequence': instance.sequence,
      'defaultData': instance.defaultData,
      'prices': instance.prices,
      'statuses': instance.statuses,
      'meta': instance.meta,
    };

V1StatusesModel _$V1StatusesModelFromJson(Map<String, dynamic> json) =>
    V1StatusesModel(
      providerId: json['provider_id'] as int?,
      hidden: json['hidden'] as bool?,
      enabled: json['enabled'] as bool?,
    );

Map<String, dynamic> _$V1StatusesModelToJson(V1StatusesModel instance) =>
    <String, dynamic>{
      'provider_id': instance.providerId,
      'hidden': instance.hidden,
      'enabled': instance.enabled,
    };
