// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRequestModel _$OrderRequestModelFromJson(Map<String, dynamic> json) =>
    OrderRequestModel(
      page: json['page'] as int?,
      size: json['size'] as int?,
      start: json['start'] as String?,
      end: json['end'] as String?,
      timeZone: json['timeZone'] as String?,
      filterByBranch: json['filterByBranch'] as int,
      filterByStatus: (json['filterByStatus'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      filterByProvider: (json['filterByProvider'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
      filterByBrand: (json['filterByBrand'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$OrderRequestModelToJson(OrderRequestModel instance) =>
    <String, dynamic>{
      'page': instance.page,
      'size': instance.size,
      'start': instance.start,
      'end': instance.end,
      'timeZone': instance.timeZone,
      'filterByBranch': instance.filterByBranch,
      'filterByStatus': instance.filterByStatus,
      'filterByProvider': instance.filterByProvider,
      'filterByBrand': instance.filterByBrand,
    };
