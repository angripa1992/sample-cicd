// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProviderRequestModel _$ProviderRequestModelFromJson(
        Map<String, dynamic> json) =>
    ProviderRequestModel(
      filterByCountry: (json['filterByCountry'] as List<dynamic>)
          .map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$ProviderRequestModelToJson(
        ProviderRequestModel instance) =>
    <String, dynamic>{
      'filterByCountry': instance.filterByCountry,
    };
