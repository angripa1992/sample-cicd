import '../applied_promo.dart';
import 'billing_item_request.dart';

class PlaceOrderDataRequestModel {
  int? id;
  String? externalId;
  String? identity;
  int? branchId;
  int? brandId;
  String? brandName;
  String? currency;
  String? currencySymbol;
  int? source;
  int? type;
  int? paymentMethod;
  int? paymentStatus;
  CustomerInfoModel? user;
  String? tableNo;
  int? itemPrice;
  int? finalPrice;
  int? deliveryFee;
  int? vatAmount;
  int? discountAmount;
  int? additionalFee;
  int? serviceFee;
  List<BillingItemRequestModel>? cart;
  int? uniqueItems;
  int? totalItems;
  int? currencyId;
  int? discountValue;
  int? discountType;
  String? orderComment;
  int? numberOfSeniorCitizen;
  int? numberOfCustomer;
  num? orderPromoDiscount;
  AppliedPromo? appliedPromoModel;

  PlaceOrderDataRequestModel({
    this.id,
    this.externalId,
    this.identity,
    this.branchId,
    this.brandId,
    this.brandName,
    this.currency,
    this.currencySymbol,
    this.source,
    this.type,
    this.paymentMethod,
    this.paymentStatus,
    this.user,
    this.tableNo,
    this.itemPrice,
    this.finalPrice,
    this.deliveryFee,
    this.vatAmount,
    this.discountAmount,
    this.additionalFee,
    this.serviceFee,
    this.cart,
    this.uniqueItems,
    this.totalItems,
    this.currencyId,
    this.discountValue,
    this.discountType,
    this.orderComment,
    this.numberOfSeniorCitizen,
    this.numberOfCustomer,
    this.appliedPromoModel,
    this.orderPromoDiscount,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['currency'] = currency;
    data['currency_symbol'] = currencySymbol;
    data['source'] = source;
    data['type'] = type;
    data['payment_status'] = paymentStatus;
    data['item_price'] = itemPrice;
    data['final_price'] = finalPrice;
    data['delivery_fee'] = deliveryFee;
    data['vat_amount'] = vatAmount;
    data['discount_amount'] = discountAmount;
    data['additional_fee'] = additionalFee;
    data['service_fee'] = serviceFee;
    data['unique_items'] = uniqueItems;
    data['total_items'] = totalItems;
    data['currency_id'] = currencyId;
    data['discount_value'] = discountValue;
    data['discount_type'] = discountType;
    if (id != null) {
      data['id'] = id;
    }
    if (externalId != null) {
      data['external_id'] = externalId;
    }
    if (identity != null) {
      data['identity'] = identity;
    }
    if (brandId != null) {
      data['brand_id'] = brandId;
    }
    if (brandName != null) {
      data['brand_name'] = brandName;
    }
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (tableNo != null) {
      data['table_no'] = tableNo;
    }
    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod;
    }
    if (orderComment != null) {
      data['order_comment'] = orderComment;
    }
    if (numberOfCustomer != null) {
      data['number_of_customer'] = numberOfCustomer;
    }
    if (numberOfSeniorCitizen != null) {
      data['number_of_senior_citizen'] = numberOfSeniorCitizen;
    }
    if (orderPromoDiscount != null) {
      data['order_promo_discount'] = orderPromoDiscount;
    }
    if (appliedPromoModel != null) {
      data['applied_promo'] = appliedPromoModel!.toJson();
    }
    return data;
  }
}

class CustomerInfoModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;

  CustomerInfoModel({this.firstName, this.lastName, this.email, this.phone});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    return data;
  }
}
