import 'package:klikit/modules/add_order/data/models/title_v2.dart';

import '../applied_promo.dart';
import 'billing_item_modifier_group_request.dart';
import 'item_brand_request.dart';
import '../item_price.dart';
import '../item_status.dart';
import '../item_stock.dart';

class BillingItemRequestModel {
  int? id;
  String? title;
  List<ItemPriceModel>? prices;
  int? vat;
  String? description;
  String? skuId;
  String? image;
  bool? enabled;
  bool? hidden;
  List<ItemStatusModel>? statuses;
  int? sequence;
  int? defaultItemId;
  ItemStockModel? stock;
  TitleV2Model? titleV2;
  TitleV2Model? descriptionV2;
  String? cartId;
  int? itemId;
  num? unitPrice;
  int? discountType;
  num? discountValue;
  List<BillingItemModifierGroupRequestModel>? groups;
  int? quantity;
  bool? hasModifierGroups;
  ItemBrandRequestModel? brand;
  String? comment;
  int? quantityOfScPromoItem;
  AppliedPromo? appliedPromoModel;
  num? promoDiscount;

  BillingItemRequestModel({
    this.id,
    this.title,
    this.prices,
    this.vat,
    this.description,
    this.skuId,
    this.image,
    this.enabled,
    this.hidden,
    this.statuses,
    this.sequence,
    this.defaultItemId,
    this.stock,
    this.titleV2,
    this.descriptionV2,
    this.cartId,
    this.itemId,
    this.unitPrice,
    this.discountType,
    this.discountValue,
    this.groups,
    this.quantity,
    this.hasModifierGroups,
    this.brand,
    this.comment,
    this.quantityOfScPromoItem,
    this.appliedPromoModel,
    this.promoDiscount,
  });

  Map<String, dynamic> toJson() {
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
      data['groups'] = groups!.map((v) => v.toJson()).toList();
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
      data['brand'] = brand!.toJson();
    }
    if (statuses != null) {
      data['statuses'] = statuses!.map((v) => v.toJson()).toList();
    }
    if(comment != null){
      data['comment'] = comment;
    }
    if(quantityOfScPromoItem != null){
      data['quantity_of_sc_promo_item'] = quantityOfScPromoItem;
    }
    if(promoDiscount != null){
      data['promo_discount'] = promoDiscount;
    }
    if(appliedPromoModel != null){
      data['applied_promo'] = appliedPromoModel!.toJson();
    }
    return data;
  }
}
