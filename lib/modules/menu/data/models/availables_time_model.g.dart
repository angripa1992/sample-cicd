// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'availables_time_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AvailableTimesModel _$AvailableTimesModelFromJson(Map<String, dynamic> json) =>
    AvailableTimesModel(
      dayOne: json['0'] == null
          ? null
          : DayInfoModel.fromJson(json['0'] as Map<String, dynamic>),
      dayTwo: json['1'] == null
          ? null
          : DayInfoModel.fromJson(json['1'] as Map<String, dynamic>),
      dayThree: json['2'] == null
          ? null
          : DayInfoModel.fromJson(json['2'] as Map<String, dynamic>),
      dayFour: json['3'] == null
          ? null
          : DayInfoModel.fromJson(json['3'] as Map<String, dynamic>),
      dayFive: json['4'] == null
          ? null
          : DayInfoModel.fromJson(json['4'] as Map<String, dynamic>),
      daySix: json['5'] == null
          ? null
          : DayInfoModel.fromJson(json['5'] as Map<String, dynamic>),
      daySeven: json['6'] == null
          ? null
          : DayInfoModel.fromJson(json['6'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AvailableTimesModelToJson(
        AvailableTimesModel instance) =>
    <String, dynamic>{
      '0': instance.dayOne,
      '1': instance.dayTwo,
      '2': instance.dayThree,
      '3': instance.dayFour,
      '4': instance.dayFive,
      '5': instance.daySix,
      '6': instance.daySeven,
    };

DayInfoModel _$DayInfoModelFromJson(Map<String, dynamic> json) => DayInfoModel(
      disabled: json['disabled'] as bool?,
      slots: (json['slots'] as List<dynamic>?)
          ?.map((e) => SlotsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DayInfoModelToJson(DayInfoModel instance) =>
    <String, dynamic>{
      'disabled': instance.disabled,
      'slots': instance.slots,
    };

SlotsModel _$SlotsModelFromJson(Map<String, dynamic> json) => SlotsModel(
      startTime: json['start_time'] as int?,
      endTime: json['end_time'] as int?,
    );

Map<String, dynamic> _$SlotsModelToJson(SlotsModel instance) =>
    <String, dynamic>{
      'start_time': instance.startTime,
      'end_time': instance.endTime,
    };
