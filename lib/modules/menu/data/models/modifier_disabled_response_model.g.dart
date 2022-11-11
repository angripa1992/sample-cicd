// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifier_disabled_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifierDisabledResponseModel _$ModifierDisabledResponseModelFromJson(
        Map<String, dynamic> json) =>
    ModifierDisabledResponseModel(
      affected: json['affected'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => DisabledItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModifierDisabledResponseModelToJson(
        ModifierDisabledResponseModel instance) =>
    <String, dynamic>{
      'affected': instance.affected,
      'items': instance.items,
    };

DisabledItemModel _$DisabledItemModelFromJson(Map<String, dynamic> json) =>
    DisabledItemModel(
      itemId: json['item_id'] as int?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$DisabledItemModelToJson(DisabledItemModel instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'title': instance.title,
    };
