import 'package:klikit/modules/add_order/data/models/modifier/title_v2_model.dart';

import '../applied_promo.dart';
import '../modifier/item_price_model.dart';
import '../modifier/item_status_model.dart';
import '../modifier/item_stock_model.dart';
import 'billing_item_modifier_group_request.dart';
import 'item_brand_request.dart';

class BillingItemRequestModel {
  int? id;
  List<MenuItemPriceModel>? prices;
  int? vat;
  bool? enabled;
  List<MenuItemStatusModel>? statuses;
  MenuItemOutOfStockModel? stock;
  int? itemId;
  num? unitPrice;
  int? discountType;
  num? discountValue;
  List<BillingItemModifierGroupRequestModel>? groups;
  int? quantity;
  ItemBrandRequestModel? brand;
  int? quantityOfScPromoItem;
  AppliedPromo? appliedPromoModel;
  num? promoDiscount;
  String? title;
  String? description;
  String? skuId;
  String? image;
  bool? hidden;
  int? sequence;
  int? defaultItemId;
  MenuItemTitleV2Model? titleV2;
  MenuItemTitleV2Model? descriptionV2;
  String? cartId;
  bool? hasModifierGroups;
  String? comment;

  BillingItemRequestModel({
    this.id,
    this.prices,
    this.vat,
    this.enabled,
    this.statuses,
    this.stock,
    this.itemId,
    this.unitPrice,
    this.discountType,
    this.discountValue,
    this.groups,
    this.quantity,
    this.brand,
    this.quantityOfScPromoItem,
    this.appliedPromoModel,
    this.promoDiscount,
    this.title,
    this.description,
    this.skuId,
    this.image,
    this.hidden,
    this.sequence,
    this.defaultItemId,
    this.titleV2,
    this.descriptionV2,
    this.cartId,
    this.hasModifierGroups,
    this.comment,
  });

  Map<String, dynamic> toJsonV1() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['vat'] = vat;
    data['description'] = description;
    data['sku_id'] = skuId;
    data['image'] = image;
    data['enabled'] = enabled;
    data['hidden'] = hidden;
    data['sequence'] = sequence;
    data['default_item_id'] = defaultItemId;
    data['cart_id'] = cartId;
    data['item_id'] = itemId;
    data['unit_price'] = unitPrice;
    data['quantity'] = quantity;
    data['has_modifier_groups'] = hasModifierGroups;
    if (discountType != null) {
      data['discount_type'] = discountType;
    }
    if (discountValue != null) {
      data['discount_value'] = discountValue;
    }
    if (prices != null) {
      data['prices'] = prices!.map((v) => v.toJson()).toList();
    }
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJsonV1()).toList();
    }
    if (stock != null) {
      data['stock'] = stock!.toJson();
    }
    if (titleV2 != null) {
      data['title_v2'] = titleV2!.toJson();
    }
    if (descriptionV2 != null) {
      data['description_v2'] = descriptionV2!.toJson();
    }
    if (brand != null) {
      data['brand'] = brand!.toJsonV1();
    }
    if (statuses != null) {
      data['statuses'] = statuses!.map((v) => v.toJson()).toList();
    }
    if (comment != null) {
      data['comment'] = comment;
    }
    if (quantityOfScPromoItem != null) {
      data['quantity_of_sc_promo_item'] = quantityOfScPromoItem;
    }
    if (promoDiscount != null) {
      data['promo_discount'] = promoDiscount;
    }
    if (appliedPromoModel != null) {
      data['applied_promo'] = appliedPromoModel!.toJson();
    }
    return data;
  }

  Map<String, dynamic> toJsonV2() {
    final Map<String, dynamic> data = {};
    data['item_id'] = id;
    data['vat'] = vat;
    data['unit_price'] = unitPrice;
    data['quantity'] = quantity;
    if (discountType != null) {
      data['discount_type'] = discountType;
    }
    if (discountValue != null) {
      data['discount_value'] = discountValue;
    }
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJsonV2()).toList();
    }
    if (brand != null) {
      data['brand'] = brand!.toJsonV2();
    }
    if (quantityOfScPromoItem != null) {
      data['quantity_of_sc_promo_item'] = quantityOfScPromoItem;
    }
    if (promoDiscount != null) {
      data['promo_discount'] = promoDiscount;
    }
    if (appliedPromoModel != null) {
      data['applied_promo'] = appliedPromoModel!.toJson();
    }
    return data;
  }
}
