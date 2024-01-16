import 'package:json_annotation/json_annotation.dart';

part 'v1_common_data_model.g.dart';

@JsonSerializable()
class V1PricesModel {
  @JsonKey(name: 'provider_id')
  int? providerId;
  @JsonKey(name: 'currency_id')
  int? currencyId;
  String? code;
  String? symbol;
  double? price;

  V1PricesModel({
    this.providerId,
    this.currencyId,
    this.code,
    this.symbol,
    this.price,
  });

  factory V1PricesModel.fromJson(Map<String, dynamic> json) => _$V1PricesModelFromJson(json);
}
