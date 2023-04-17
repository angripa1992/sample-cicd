import 'billing_item.dart';

class BillingRequestModel {
  int? brandId;
  int? branchId;
  num? deliveryFee;
  int? discountType;
  num? discountValue;
  num? additionalFee;
  BillingCurrency? currency;
  List<BillingItem>? items;

  BillingRequestModel({
    this.brandId,
    this.branchId,
    this.deliveryFee,
    this.discountType,
    this.discountValue,
    this.additionalFee,
    this.currency,
    this.items,
  });

  Map<String, dynamic> toJson() {
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
      data['items'] = items!.map((v) => v.toJson()).toList();
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
