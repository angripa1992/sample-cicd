// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'affected_modifier_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AffectedModifierResponseModel _$AffectedModifierResponseModelFromJson(
        Map<String, dynamic> json) =>
    AffectedModifierResponseModel(
      affected: json['affected'] as bool?,
      items: (json['items'] as List<dynamic>?)
          ?.map((e) =>
              DisabledItemResponseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AffectedModifierResponseModelToJson(
        AffectedModifierResponseModel instance) =>
    <String, dynamic>{
      'affected': instance.affected,
      'items': instance.items,
    };

DisabledItemResponseModel _$DisabledItemResponseModelFromJson(
        Map<String, dynamic> json) =>
    DisabledItemResponseModel(
      itemId: json['item_id'] as int?,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$DisabledItemResponseModelToJson(
        DisabledItemResponseModel instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'title': instance.title,
    };
