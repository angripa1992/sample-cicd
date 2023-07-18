import 'package:json_annotation/json_annotation.dart';

part 'order_applied_promo.g.dart';

@JsonSerializable(explicitToJson: true)
class OrderAppliedPromo {
  @JsonKey(name: 'item_id')
  int? itemId;
  @JsonKey(name: 'promo_id')
  int? promoId;
  @JsonKey(name: 'promo_code')
  String? promoCode;
  @JsonKey(name: 'is_senior_citizen_promo')
  bool? isSeniorCitizenPromo;
  @JsonKey(name: 'number_of_senior_citizen')
  int? numberOfSeniorCitizen;
  @JsonKey(name: 'number_of_customer')
  int? numberOfCustomer;
  @JsonKey(name: 'quantity_of_sc_promo_item')
  int? quantityOfScPromoItem;

  OrderAppliedPromo({
    this.itemId,
    this.promoId,
    this.promoCode,
    this.isSeniorCitizenPromo,
    this.numberOfSeniorCitizen,
    this.numberOfCustomer,
    this.quantityOfScPromoItem,
  });

  factory OrderAppliedPromo.fromJson(Map<String, dynamic> json) =>
      _$OrderAppliedPromoFromJson(json);

  Map<String, dynamic> toJson() => _$OrderAppliedPromoToJson(this);
}
