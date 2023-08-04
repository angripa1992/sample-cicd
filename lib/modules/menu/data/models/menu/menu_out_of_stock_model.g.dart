// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menu_out_of_stock_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuOutOfStockModel _$MenuOutOfStockModelFromJson(Map<String, dynamic> json) =>
    MenuOutOfStockModel(
      available: json['available'] as bool?,
      snooze: json['snooze'] == null
          ? null
          : MenuSnoozeModel.fromJson(json['snooze'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MenuOutOfStockModelToJson(
        MenuOutOfStockModel instance) =>
    <String, dynamic>{
      'available': instance.available,
      'snooze': instance.snooze,
    };

MenuSnoozeModel _$MenuSnoozeModelFromJson(Map<String, dynamic> json) =>
    MenuSnoozeModel(
      endTime: json['end_time'] as String?,
      duration: json['duration'] as int?,
    );

Map<String, dynamic> _$MenuSnoozeModelToJson(MenuSnoozeModel instance) =>
    <String, dynamic>{
      'end_time': instance.endTime,
      'duration': instance.duration,
    };
