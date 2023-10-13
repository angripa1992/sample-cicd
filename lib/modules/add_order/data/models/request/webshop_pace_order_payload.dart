import 'package:klikit/modules/add_order/data/models/applied_promo.dart';

import '../modifier/item_price_model.dart';
import '../modifier/modifier_rule.dart';
import '../modifier/title_v2_model.dart';
import 'billing_request.dart';

class WebShopPlaceOrderPayload {
  num? itemPrice;
  num? finalPrice;
  num? deliveryFee;
  num? vatPrice;
  num? discountAmount;
  num? uniqueItems;
  num? totalItems;
  num? serviceFee;
  String? tz;
  String? updateCartNote;
  List<WebShopPlaceOrderCartItem>? cart;
  num? orderType;
  num? branchId;
  String? tableNo;
  BillingCurrency? currency;
  Promo? appliedPromo;

  WebShopPlaceOrderPayload({
    this.itemPrice,
    this.finalPrice,
    this.deliveryFee,
    this.vatPrice,
    this.discountAmount,
    this.uniqueItems,
    this.totalItems,
    this.serviceFee,
    this.tz,
    this.updateCartNote,
    this.cart,
    this.orderType,
    this.branchId,
    this.tableNo,
    this.currency,
    this.appliedPromo,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_price'] = itemPrice;
    data['final_price'] = finalPrice;
    data['delivery_fee'] = deliveryFee;
    data['vat_price'] = vatPrice;
    data['discount_amount'] = discountAmount;
    data['unique_items'] = uniqueItems;
    data['total_items'] = totalItems;
    data['service_fee'] = serviceFee;
    data['tz'] = tz;
    data['update_cart_note'] = updateCartNote;
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    data['order_type'] = orderType;
    data['branch_id'] = branchId;
    data['table_no'] = tableNo;
    if (currency != null) {
      data['currency'] = currency!.toJson();
    }
    if (appliedPromo != null) {
      data['applied_promo'] = appliedPromo!.toJson();
    }
    return data;
  }
}

class WebShopPlaceOrderCartItem {
  int? itemId;
  num? vat;
  String? description;
  String? image;
  num? price;
  String? title;
  MenuItemTitleV2Model? titleV2;
  List<WebShopPlaceOrderModifierGroup>? groups;
  String? itemName;
  num? unitPrice;
  int? discountType;
  num? discountValue;
  num? itemFinalPrice;
  num? quantity;
  List<MenuItemPriceModel>? prices;

  WebShopPlaceOrderCartItem({
    this.itemId,
    this.vat,
    this.description,
    this.image,
    this.price,
    this.title,
    this.titleV2,
    this.groups,
    this.itemName,
    this.unitPrice,
    this.discountType,
    this.discountValue,
    this.itemFinalPrice,
    this.quantity,
    this.prices,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['item_id'] = itemId;
    data['vat'] = vat;
    data['description'] = description;
    data['image'] = image;
    data['price'] = price;
    data['title'] = title;
    if (titleV2 != null) {
      data['title_v2'] = titleV2!.toJson();
    }
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    data['item_name'] = itemName;
    data['unit_price'] = unitPrice;
    data['discount_type'] = discountType;
    data['discount_value'] = discountValue;
    data['item_final_price'] = itemFinalPrice;
    data['quantity'] = quantity;
    if (prices != null) {
      data['prices'] = prices!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WebShopPlaceOrderModifierGroup {
  int? groupId;
  String? title;
  MenuItemTitleV2Model? titleV2;
  MenuItemModifierRuleModel? rule;
  List<WebShopPlaceOrderModifier>? modifiers;

  WebShopPlaceOrderModifierGroup({this.groupId, this.title, this.titleV2, this.rule, this.modifiers});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['group_id'] = groupId;
    data['title'] = title;
    if (titleV2 != null) {
      data['title_v2'] = titleV2!.toJson();
    }
    if (rule != null) {
      data['rule'] = rule!.toWebShopJson();
    }
    if (modifiers != null) {
      data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WebShopPlaceOrderModifier {
  int? id;
  int? modifierId;
  String? title;
  MenuItemTitleV2Model? titleV2;
  bool? isSelected;
  num? modifierQuantity;
  num? extraPrice;
  List<WebShopPlaceOrderModifierGroup>? groups;

  WebShopPlaceOrderModifier({
    this.id,
    this.modifierId,
    this.title,
    this.titleV2,
    this.isSelected,
    this.modifierQuantity,
    this.extraPrice,
    this.groups,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['modifier_id'] = modifierId;
    data['title'] = title;
    if (titleV2 != null) {
      data['title_v2'] = titleV2!.toJson();
    }
    data['is_selected'] = isSelected;
    data['modifier_quantity'] = modifierQuantity;
    data['extra_price'] = extraPrice;
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
