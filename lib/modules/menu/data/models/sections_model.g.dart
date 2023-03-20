// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sections_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SectionsModel _$SectionsModelFromJson(Map<String, dynamic> json) =>
    SectionsModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      startTime: json['start_time'] as int?,
      endTime: json['end_time'] as int?,
      availableTimes: json['available_times'] == null
          ? null
          : AvailableTimesModel.fromJson(json['available_times'] as Map<String, dynamic>),
      days: json['days'] as String?,
      enabled: json['enabled'] as bool?,
      hidden: json['hidden'] as bool?,
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => StatusesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sequence: json['sequence'] as int?,
      subSections: (json['sub-sections'] as List<dynamic>?)
          ?.map((e) => SubSectionsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SectionsModelToJson(SectionsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'available_times': instance.availableTimes,
      'days': instance.days,
      'enabled': instance.enabled,
      'hidden': instance.hidden,
      'statuses': instance.statuses,
      'sequence': instance.sequence,
      'sub-sections': instance.subSections,
    };
