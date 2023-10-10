import 'package:klikit/modules/add_order/data/models/applied_promo.dart';

import '../../../../common/entities/branch_info.dart';
import '../modifier/item_price_model.dart';
import '../modifier/modifier_rule.dart';
import 'billing_request.dart';
import 'item_brand_request.dart';

class WebShopCalculateBillPayload {
  int? branchId;
  BillingCurrency? currency;
  List<WebShopCartItemPayload>? cart;
  Promo? appliedPromo;

  WebShopCalculateBillPayload({this.branchId, this.currency, this.cart, this.appliedPromo});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    if (appliedPromo != null) {
      data['applied_promo'] = appliedPromo!.toJson();
    }
    return data;
  }
}

class WebShopCartItemPayload {
  num? itemId;
  num? subSectionId;
  BusinessBranchInfo? branch;
  ItemBrandRequestModel? brand;
  String? comment;
  num? discountValue;
  List<WebShopGroupPayload>? groups;
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

class WebShopGroupPayload {
  int? groupId;
  List<WebShopModifierPayload>? modifiers;
  MenuItemModifierRuleModel? rule;

  WebShopGroupPayload({this.groupId, this.modifiers, this.rule});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    if (modifiers != null) {
      data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
    }
    if (rule != null) {
      data['rule'] = rule!.toJsonV2();
    }
    return data;
  }
}

class WebShopModifierPayload {
  num? extraPrice;
  List<WebShopGroupPayload>? groups;
  int? id;
  int? modifierId;
  num? modifierQuantity;

  WebShopModifierPayload({this.extraPrice, this.groups, this.id, this.modifierId, this.modifierQuantity});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['extra_price'] = extraPrice;
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    data['id'] = id;
    data['modifier_id'] = modifierId;
    data['modifier_quantity'] = modifierQuantity;
    return data;
  }
}
