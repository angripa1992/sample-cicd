import '../applied_promo.dart';
import 'billing_item_request.dart';

class BillingRequestModel {
  int? businessId;
  int? brandId;
  int? branchId;
  num? deliveryFee;
  int? discountType;
  num? discountValue;
  num? additionalFee;
  BillingCurrency? currency;
  List<BillingItemRequestModel>? items;
  int? numberOfSeniorCitizen;
  int? numberOfCustomer;
  Promo? appliedPromoModel;
  int? orderType;

  BillingRequestModel({
    this.businessId,
    this.brandId,
    this.branchId,
    this.deliveryFee,
    this.discountType,
    this.discountValue,
    this.additionalFee,
    this.currency,
    this.items,
    this.numberOfSeniorCitizen,
    this.numberOfCustomer,
    this.appliedPromoModel,
    this.orderType,
  });

  Map<String, dynamic> toJsonV1() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['brand_id'] = brandId;
    data['branch_id'] = branchId;
    data['delivery_fee'] = deliveryFee;
    data['discount_type'] = discountType;
    data['discount_value'] = discountValue;
    data['additional_fee'] = additionalFee;
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJsonV1()).toList();
    }
    if (numberOfCustomer != null) {
      data['number_of_customer'] = numberOfCustomer;
    }
    if (numberOfSeniorCitizen != null) {
      data['number_of_senior_citizen'] = numberOfSeniorCitizen;
    }
    if (appliedPromoModel != null) {
      data['applied_promo'] = appliedPromoModel;
    }
    if (orderType != null) {
      data['order_type'] = orderType;
    }
    return data;
  }

  Map<String, dynamic> toJsonV2() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['business_id'] = businessId;
    data['branch_id'] = branchId;
    data['delivery_fee'] = deliveryFee;
    data['discount_type'] = discountType;
    data['discount_value'] = discountValue;
    data['additional_fee'] = additionalFee;
    if (currency != null) {
      data['currency'] = currency!.toString();
    }
    if (items != null) {
      data['items'] = items!.map((v) => v.toJsonV2()).toList();
    }
    if (numberOfCustomer != null) {
      data['number_of_customer'] = numberOfCustomer;
    }
    if (numberOfSeniorCitizen != null) {
      data['number_of_senior_citizen'] = numberOfSeniorCitizen;
    }
    if (appliedPromoModel != null) {
      data['applied_promo'] = appliedPromoModel;
    }
    if (orderType != null) {
      data['order_type'] = orderType;
    }
    return data;
  }
}

class BillingCurrency {
  int? id;
  String? symbol;
  String? code;

  BillingCurrency({this.id, this.symbol, this.code});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['symbol'] = symbol;
    data['code'] = code;
    return data;
  }
}
