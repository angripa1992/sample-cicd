// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'v1_common_data_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

V1PricesModel _$V1PricesModelFromJson(Map<String, dynamic> json) =>
    V1PricesModel(
      providerId: json['provider_id'] as int?,
      currencyId: json['currency_id'] as int?,
      code: json['code'] as String?,
      symbol: json['symbol'] as String?,
      price: (json['price'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$V1PricesModelToJson(V1PricesModel instance) =>
    <String, dynamic>{
      'provider_id': instance.providerId,
      'currency_id': instance.currencyId,
      'code': instance.code,
      'symbol': instance.symbol,
      'price': instance.price,
    };
