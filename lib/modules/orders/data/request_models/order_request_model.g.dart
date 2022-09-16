// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderRequestModel _$OrderRequestModelFromJson(Map<String, dynamic> json) =>
    OrderRequestModel(
      page: json['page'] as int,
      size: json['size'] as int? ?? 10,
      filterByBranch: json['filterByBranch'] as int,
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
      'filterByBranch': instance.filterByBranch,
      'filterByProvider': instance.filterByProvider,
      'filterByBrand': instance.filterByBrand,
    };
