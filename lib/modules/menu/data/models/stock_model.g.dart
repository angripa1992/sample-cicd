// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StockModel _$StockModelFromJson(Map<String, dynamic> json) => StockModel(
      available: json['available'] as bool?,
      snooze: json['snooze'] == null
          ? null
          : SnoozeModel.fromJson(json['snooze'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$StockModelToJson(StockModel instance) =>
    <String, dynamic>{
      'available': instance.available,
      'snooze': instance.snooze,
    };

SnoozeModel _$SnoozeModelFromJson(Map<String, dynamic> json) => SnoozeModel(
      endTime: json['end_time'] as String?,
      duration: json['duration'] as int?,
    );

Map<String, dynamic> _$SnoozeModelToJson(SnoozeModel instance) =>
    <String, dynamic>{
      'end_time': instance.endTime,
      'duration': instance.duration,
    };
