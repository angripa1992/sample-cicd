// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'modifiers_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ModifiersGroupModel _$ModifiersGroupModelFromJson(Map<String, dynamic> json) =>
    ModifiersGroupModel(
      groupId: json['group_id'] as int?,
      title: json['title'] as String?,
      defaultData: json['defaultData'] as bool?,
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => StatusesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      modifiers: (json['modifiers'] as List<dynamic>?)
          ?.map((e) => ModifiersModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModifiersGroupModelToJson(
        ModifiersGroupModel instance) =>
    <String, dynamic>{
      'group_id': instance.groupId,
      'title': instance.title,
      'defaultData': instance.defaultData,
      'statuses': instance.statuses,
      'modifiers': instance.modifiers,
    };
