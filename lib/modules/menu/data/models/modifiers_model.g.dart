// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifiers_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifiersModel _$ModifiersModelFromJson(Map<String, dynamic> json) =>
    ModifiersModel(
      modifierId: json['modifier_id'] as int?,
      title: json['title'] as String?,
      sequence: json['sequence'] as int?,
      defaultData: json['defaultData'] as bool?,
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => PricesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => StatusesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: json['meta'],
    );

Map<String, dynamic> _$ModifiersModelToJson(ModifiersModel instance) =>
    <String, dynamic>{
      'modifier_id': instance.modifierId,
      'title': instance.title,
      'sequence': instance.sequence,
      'defaultData': instance.defaultData,
      'prices': instance.prices,
      'statuses': instance.statuses,
      'meta': instance.meta,
    };
