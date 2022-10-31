// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'busy_mode_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusyModeGetResponseModel _$BusyModeGetResponseModelFromJson(
        Map<String, dynamic> json) =>
    BusyModeGetResponseModel(
      isBusy: json['is_busy'] as bool?,
      updatedAt: json['busy_mode_updated_at'] as String?,
      duration: json['duration'] as int?,
      timeLeft: json['time_left'] as int?,
    );

Map<String, dynamic> _$BusyModeGetResponseModelToJson(
        BusyModeGetResponseModel instance) =>
    <String, dynamic>{
      'is_busy': instance.isBusy,
      'busy_mode_updated_at': instance.updatedAt,
      'time_left': instance.timeLeft,
      'duration': instance.duration,
    };

BusyModePostResponseModel _$BusyModePostResponseModelFromJson(
        Map<String, dynamic> json) =>
    BusyModePostResponseModel(
      message: json['message'] as String?,
      warning:
          (json['warning'] as List<dynamic>?)?.map((e) => e as String).toList(),
      duration: json['duration'] as int?,
      timeLeft: json['time_left'] as int?,
    );

Map<String, dynamic> _$BusyModePostResponseModelToJson(
        BusyModePostResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'warning': instance.warning,
      'time_left': instance.timeLeft,
      'duration': instance.duration,
    };
