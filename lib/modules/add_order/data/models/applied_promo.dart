class Promo {
  int? id;
  String? code;
  String? startTime;
  String? endTime;
  List<String>? productType;
  String? valueType;
  int? value;
  int? maxDiscount;
  int? minOrderAmount;
  int? maxLimit;
  int? maxLimitPerUser;
  bool? autoApplicable;
  bool? vatExempted;
  bool? isActivated;
  int? country;
  String? cohortType;
  String? status;
  String? createdAt;
  String? updatedAt;
  bool? isSeniorCitizenPromo;

  Promo(
      {this.id,
      this.code,
      this.startTime,
      this.endTime,
      this.productType,
      this.valueType,
      this.value,
      this.maxDiscount,
      this.minOrderAmount,
      this.maxLimit,
      this.maxLimitPerUser,
      this.autoApplicable,
      this.vatExempted,
      this.isActivated,
      this.country,
      this.cohortType,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.isSeniorCitizenPromo});

  Promo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    productType = json['product_type'].cast<String>();
    valueType = json['value_type'];
    value = json['value'];
    maxDiscount = json['max_discount'];
    minOrderAmount = json['min_order_amount'];
    maxLimit = json['max_limit'];
    maxLimitPerUser = json['max_limit_per_user'];
    autoApplicable = json['auto_applicable'];
    vatExempted = json['vat_exempted'];
    isActivated = json['is_activated'];
    country = json['country'];
    cohortType = json['cohort_type'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    isSeniorCitizenPromo = json['is_senior_citizen_promo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['product_type'] = productType;
    data['value_type'] = valueType;
    data['value'] = value;
    data['max_discount'] = maxDiscount;
    data['min_order_amount'] = minOrderAmount;
    data['max_limit'] = maxLimit;
    data['max_limit_per_user'] = maxLimitPerUser;
    data['auto_applicable'] = autoApplicable;
    data['vat_exempted'] = vatExempted;
    data['is_activated'] = isActivated;
    data['country'] = country;
    data['cohort_type'] = cohortType;
    data['status'] = status;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['is_senior_citizen_promo'] = isSeniorCitizenPromo;
    return data;
  }
}

class AppliedPromoItem {
  int? id;
  String? code;
  int? discount;

  AppliedPromoItem({this.id, this.code, this.discount});

  AppliedPromoItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    code = json['code'];
    discount = json['discount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['code'] = code;
    data['discount'] = discount;
    return data;
  }
}

class AppliedPromoInfo {
  int? itemId;
  int? promoId;
  String? promoCode;
  bool? isSeniorCitizenPromo;
  int? numberOfSeniorCitizen;
  int? numberOfCustomer;
  int? quantityOfScPromoItem;
  Promo? promo;

  AppliedPromoInfo({
    this.itemId,
    this.promoId,
    this.promoCode,
    this.isSeniorCitizenPromo,
    this.numberOfSeniorCitizen,
    this.numberOfCustomer,
    this.quantityOfScPromoItem,
    this.promo,
  });

  AppliedPromoInfo.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    promoId = json['promo_id'];
    promoCode = json['promo_code'];
    isSeniorCitizenPromo = json['is_senior_citizen_promo'];
    numberOfSeniorCitizen = json['number_of_senior_citizen'];
    numberOfCustomer = json['number_of_customer'];
    quantityOfScPromoItem = json['quantity_of_sc_promo_item'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['promo_id'] = promoId;
    data['promo_code'] = promoCode;
    data['is_senior_citizen_promo'] = isSeniorCitizenPromo;
    data['number_of_senior_citizen'] = numberOfSeniorCitizen;
    data['number_of_customer'] = numberOfCustomer;
    data['quantity_of_sc_promo_item'] = quantityOfScPromoItem;
    return data;
  }
}
