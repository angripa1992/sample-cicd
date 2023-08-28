// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_oos_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuOosV2ResponseModel _$MenuOosV2ResponseModelFromJson(
        Map<String, dynamic> json) =>
    MenuOosV2ResponseModel(
      oos: json['oos'] == null
          ? null
          : MenuOosResponseModel.fromJson(json['oos'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuOosV2ResponseModelToJson(
        MenuOosV2ResponseModel instance) =>
    <String, dynamic>{
      'oos': instance.oos,
    };

MenuOosResponseModel _$MenuOosResponseModelFromJson(
        Map<String, dynamic> json) =>
    MenuOosResponseModel(
      available: json['available'] as bool?,
      snooze: json['snooze'] == null
          ? null
          : MenuSnoozeResponseModel.fromJson(
              json['snooze'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuOosResponseModelToJson(
        MenuOosResponseModel instance) =>
    <String, dynamic>{
      'available': instance.available,
      'snooze': instance.snooze,
    };

MenuSnoozeResponseModel _$MenuSnoozeResponseModelFromJson(
        Map<String, dynamic> json) =>
    MenuSnoozeResponseModel(
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      duration: json['duration'] as int?,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$MenuSnoozeResponseModelToJson(
        MenuSnoozeResponseModel instance) =>
    <String, dynamic>{
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'duration': instance.duration,
      'unit': instance.unit,
    };
