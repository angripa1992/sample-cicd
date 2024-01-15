import '../applied_promo.dart';
import 'billing_item_request.dart';

class PlaceOrderDataRequestModel {
  int? id;
  int? businessId;
  int? menuVersion;
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
  int? paymentChannel;
  int? paymentStatus;
  CustomerInfoModel? user;
  String? tableNo;
  int? itemPrice;
  int? finalPrice;
  int? deliveryFee;
  int? vatAmount;
  int? discountAmount;
  int? additionalFee;
  num? restaurantServiceFee;
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
  bool? manualOrderAutoAcceptEnabled;
  bool? roundOffApplicable;
  num? roundOffAmount;
  Promo? appliedPromoModel;

  PlaceOrderDataRequestModel({
    this.id,
    this.businessId,
    this.menuVersion,
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
    this.paymentChannel,
    this.paymentStatus,
    this.user,
    this.tableNo,
    this.itemPrice,
    this.finalPrice,
    this.deliveryFee,
    this.vatAmount,
    this.discountAmount,
    this.additionalFee,
    this.restaurantServiceFee,
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
    this.manualOrderAutoAcceptEnabled,
    this.orderPromoDiscount,
    this.roundOffApplicable,
    this.roundOffAmount,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['business_id'] = businessId;
    data['menu_version'] = menuVersion;
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
    data['restaurant_service_fee'] = restaurantServiceFee;
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
      data['cart'] = cart!.map((v) => v.toJsonV1()).toList();
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
    if (paymentChannel != null) {
      data['payment_channel_id'] = paymentChannel;
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
    if (roundOffApplicable != null) {
      data['is_rounding_off_applicable'] = roundOffApplicable;
    }
    if (roundOffAmount != null) {
      data['round_off_amount'] = roundOffAmount;
    }
    data['manual_order_auto_accept_enabled'] = manualOrderAutoAcceptEnabled;
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
