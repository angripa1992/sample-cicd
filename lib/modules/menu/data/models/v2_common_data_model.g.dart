// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v2_common_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V2TitleModel _$V2TitleModelFromJson(Map<String, dynamic> json) => V2TitleModel(
      en: json['en'] as String?,
      tl: json['tl'] as String?,
    );

Map<String, dynamic> _$V2TitleModelToJson(V2TitleModel instance) =>
    <String, dynamic>{
      'en': instance.en,
      'tl': instance.tl,
    };

V2VisibilityModel _$V2VisibilityModelFromJson(Map<String, dynamic> json) =>
    V2VisibilityModel(
      providerID: json['providerID'] as int?,
      status: json['status'] as bool?,
    );

Map<String, dynamic> _$V2VisibilityModelToJson(V2VisibilityModel instance) =>
    <String, dynamic>{
      'providerID': instance.providerID,
      'status': instance.status,
    };

V2PriceModel _$V2PriceModelFromJson(Map<String, dynamic> json) => V2PriceModel(
      providerID: json['providerID'] as int?,
      details: (json['details'] as List<dynamic>?)
          ?.map((e) => V2PriceDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$V2PriceModelToJson(V2PriceModel instance) =>
    <String, dynamic>{
      'providerID': instance.providerID,
      'details': instance.details,
    };

V2PriceDetailsModel _$V2PriceDetailsModelFromJson(Map<String, dynamic> json) =>
    V2PriceDetailsModel(
      currencyCode: json['currencyCode'] as String?,
      price: json['price'] as num?,
      takeAwayPrice: json['takeAwayPrice'] as num?,
      advancedPricing: json['advancedPricing'] == null
          ? null
          : V2AdvancedPricingModel.fromJson(
              json['advancedPricing'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V2PriceDetailsModelToJson(
        V2PriceDetailsModel instance) =>
    <String, dynamic>{
      'currencyCode': instance.currencyCode,
      'price': instance.price,
      'takeAwayPrice': instance.takeAwayPrice,
      'advancedPricing': instance.advancedPricing,
    };

V2AdvancedPricingModel _$V2AdvancedPricingModelFromJson(
        Map<String, dynamic> json) =>
    V2AdvancedPricingModel(
      delivery: json['delivery'] as num?,
      dineIn: json['dineIn'] as num?,
      pickup: json['pickup'] as num?,
    );

Map<String, dynamic> _$V2AdvancedPricingModelToJson(
        V2AdvancedPricingModel instance) =>
    <String, dynamic>{
      'delivery': instance.delivery,
      'dineIn': instance.dineIn,
      'pickup': instance.pickup,
    };

V2ResourcesModel _$V2ResourcesModelFromJson(Map<String, dynamic> json) =>
    V2ResourcesModel(
      providerID: json['providerID'] as int?,
      type: json['type'] as String?,
      paths: (json['paths'] as List<dynamic>?)
          ?.map((e) => V2ResourcePathsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$V2ResourcesModelToJson(V2ResourcesModel instance) =>
    <String, dynamic>{
      'providerID': instance.providerID,
      'type': instance.type,
      'paths': instance.paths,
    };

V2ResourcePathsModel _$V2ResourcePathsModelFromJson(
        Map<String, dynamic> json) =>
    V2ResourcePathsModel(
      path: json['path'] as String?,
      sequence: json['sequence'] as int?,
      byDefault: json['default'] as bool?,
    );

Map<String, dynamic> _$V2ResourcePathsModelToJson(
        V2ResourcePathsModel instance) =>
    <String, dynamic>{
      'path': instance.path,
      'sequence': instance.sequence,
      'default': instance.byDefault,
    };

V2OosModel _$V2OosModelFromJson(Map<String, dynamic> json) => V2OosModel(
      available: json['available'] as bool?,
      snooze: json['snooze'] == null
          ? null
          : V2SnoozeModel.fromJson(json['snooze'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$V2OosModelToJson(V2OosModel instance) =>
    <String, dynamic>{
      'available': instance.available,
      'snooze': instance.snooze,
    };

V2SnoozeModel _$V2SnoozeModelFromJson(Map<String, dynamic> json) =>
    V2SnoozeModel(
      startTime: json['start_time'] as String?,
      endTime: json['end_time'] as String?,
      duration: json['duration'] as int?,
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$V2SnoozeModelToJson(V2SnoozeModel instance) =>
    <String, dynamic>{
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'duration': instance.duration,
      'unit': instance.unit,
    };
