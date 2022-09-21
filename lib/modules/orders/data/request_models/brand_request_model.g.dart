// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandRequestModel _$BrandRequestModelFromJson(Map<String, dynamic> json) =>
    BrandRequestModel(
      filterByBranch: json['filterByBranch'] as int,
      page: json['page'] as int? ?? 1,
      size: json['size'] as int? ?? 1000,
    );

Map<String, dynamic> _$BrandRequestModelToJson(BrandRequestModel instance) =>
    <String, dynamic>{
      'filterByBranch': instance.filterByBranch,
      'page': instance.page,
      'size': instance.size,
    };
