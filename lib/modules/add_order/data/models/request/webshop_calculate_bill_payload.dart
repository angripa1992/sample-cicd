import 'package:klikit/modules/add_order/data/models/applied_promo.dart';

import '../../../../common/entities/branch.dart';
import '../modifier/item_price_model.dart';
import '../modifier/modifier_rule.dart';
import '../modifier/title_v2_model.dart';
import 'billing_request.dart';
import 'item_brand_request.dart';

class WebShopCalculateBillPayload {
  int? branchId;
  String? orderHash;
  int? orderType;
  BillingCurrency? currency;
  List<WebShopCartItemPayload>? cart;
  Promo? appliedPromo;
  OrderDeliveryLocation? deliveryLocation;
  int? numberOfSeniorCitizen;
  int? numberOfCustomer;
  int? rewardPointId;
  int? userId;
  int? businessId;

  WebShopCalculateBillPayload({
    this.branchId,
    this.orderHash,
    this.currency,
    this.cart,
    this.appliedPromo,
    this.orderType,
    this.deliveryLocation,
    this.numberOfSeniorCitizen,
    this.numberOfCustomer,
    this.rewardPointId,
    this.userId,
    this.businessId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['order_type'] = orderType;
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    if (appliedPromo != null) {
      data['applied_promo'] = appliedPromo!.toJson();
    }
    if (orderHash != null) {
      data['order_hash'] = orderHash;
    }
    if (deliveryLocation != null) {
      data['delivery_location'] = deliveryLocation!.toJson();
    }
    if (numberOfSeniorCitizen != null) {
      data['number_of_senior_citizen'] = numberOfSeniorCitizen;
    }
    if (numberOfCustomer != null) {
      data['number_of_customer'] = numberOfCustomer;
    }
    if (rewardPointId != null) {
      data['reward_point_id'] = rewardPointId;
    }
    if (userId != null) {
      data['user_id'] = userId;
    }
    if (businessId != null) {
      data['business_id'] = businessId;
    }
    return data;
  }
}

class WebShopCartItemPayload {
  num? itemId;
  num? subSectionId;
  Branch? branch;
  ItemBrandRequestModel? brand;
  String? comment;
  num? discountValue;
  List<WebShopModifierGroupPayload>? groups;
  num? itemFinalPrice;
  String? itemName;
  num? menuVersion;
  num? price;
  List<MenuItemPriceModel>? prices;
  num? quantity;
  num? unitPrice;
  num? vat;

  WebShopCartItemPayload({
    this.branch,
    this.brand,
    this.comment,
    this.discountValue,
    this.groups,
    this.itemFinalPrice,
    this.itemId,
    this.subSectionId,
    this.itemName,
    this.menuVersion,
    this.price,
    this.prices,
    this.quantity,
    this.unitPrice,
    this.vat,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (branch != null) {
      data['branch'] = branch!.toJson();
    }
    if (brand != null) {
      data['brand'] = brand!.toJsonV1();
    }
    data['comment'] = comment;
    data['discount_value'] = discountValue;
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    data['item_final_price'] = itemFinalPrice;
    data['item_id'] = itemId;
    data['subsection_id'] = subSectionId;
    data['item_name'] = itemName;
    data['menu_version'] = menuVersion;
    data['price'] = price;
    if (prices != null) {
      data['prices'] = prices!.map((v) => v.toJson()).toList();
    }
    data['quantity'] = quantity;
    data['unit_price'] = unitPrice;
    data['vat'] = vat;
    return data;
  }
}

class WebShopModifierGroupPayload {
  int? groupId;
  List<WebShopModifierPayload>? modifiers;
  MenuItemModifierRuleModel? rule;
  String? title;
  MenuItemTitleV2Model? titleV2;

  WebShopModifierGroupPayload({
    this.groupId,
    this.modifiers,
    this.rule,
    this.title,
    this.titleV2,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    if (modifiers != null) {
      data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
    }
    if (rule != null) {
      data['rule'] = rule!.toWebShopJson();
    }
    if (title != null) {
      data['title'] = title;
    }
    if (titleV2 != null) {
      data['title_v2'] = titleV2!.toJson();
    }
    return data;
  }
}

class WebShopModifierPayload {
  num? extraPrice;
  List<WebShopModifierGroupPayload>? groups;
  int? id;
  int? modifierId;
  num? modifierQuantity;
  bool? isSelected;
  String? title;
  MenuItemTitleV2Model? titleV2;

  WebShopModifierPayload({
    this.extraPrice,
    this.groups,
    this.id,
    this.modifierId,
    this.modifierQuantity,
    this.isSelected,
    this.title,
    this.titleV2,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['extra_price'] = extraPrice;
    data['id'] = id;
    data['modifier_id'] = modifierId;
    data['modifier_quantity'] = modifierQuantity;
    data['is_selected'] = isSelected;
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    if (title != null) {
      data['title'] = title;
    }
    if (titleV2 != null) {
      data['title_v2'] = titleV2!.toJson();
    }
    return data;
  }
}

class OrderDeliveryLocation {
  num latitude;
  num longitude;
  String address;
  String? keywords;
  String? instruction;

  OrderDeliveryLocation({
    required this.latitude,
    required this.longitude,
    required this.address,
    this.keywords,
    this.instruction,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['address'] = address;
    data['keywords'] = keywords;
    data['instruction'] = instruction;
    return data;
  }
}
