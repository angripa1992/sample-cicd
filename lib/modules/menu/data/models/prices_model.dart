import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../domain/entities/price.dart';

part 'prices_model.g.dart';

@JsonSerializable()
class PricesModel {
  @JsonKey(name: 'provider_id')
  int? providerId;
  @JsonKey(name: 'currency_id')
  int? currencyId;
  String? code;
  String? symbol;
  double? price;

  PricesModel({
    this.providerId,
    this.currencyId,
    this.code,
    this.symbol,
    this.price,
  });

  factory PricesModel.fromJson(Map<String, dynamic> json) =>
      _$PricesModelFromJson(json);

  Prices toEntity() {
    return Prices(
      providerId: providerId.orZero(),
      currencyId: currencyId.orZero(),
      code: code.orEmpty(),
      symbol: symbol.orEmpty(),
      price: price.orZero(),
    );
  }
}
