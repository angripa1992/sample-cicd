// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_applied_promo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderAppliedPromo _$OrderAppliedPromoFromJson(Map<String, dynamic> json) =>
    OrderAppliedPromo(
      itemId: json['item_id'] as int?,
      promoId: json['promo_id'] as int?,
      promoCode: json['promo_code'] as String?,
      isSeniorCitizenPromo: json['is_senior_citizen_promo'] as bool?,
      numberOfSeniorCitizen: json['number_of_senior_citizen'] as int?,
      numberOfCustomer: json['number_of_customer'] as int?,
      quantityOfScPromoItem: json['quantity_of_sc_promo_item'] as int?,
    );

Map<String, dynamic> _$OrderAppliedPromoToJson(OrderAppliedPromo instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'promo_id': instance.promoId,
      'promo_code': instance.promoCode,
      'is_senior_citizen_promo': instance.isSeniorCitizenPromo,
      'number_of_senior_citizen': instance.numberOfSeniorCitizen,
      'number_of_customer': instance.numberOfCustomer,
      'quantity_of_sc_promo_item': instance.quantityOfScPromoItem,
    };
