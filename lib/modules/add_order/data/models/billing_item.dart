import 'package:klikit/modules/add_order/data/models/title_v2.dart';

import 'billing_item_modifier_group.dart';
import 'item_brand.dart';
import 'item_price.dart';
import 'item_status.dart';
import 'item_stock.dart';

class BillingItem {
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
  int? unitPrice;
  int? discountType;
  num? discountValue;
  List<BillingItemModifierGroup>? groups;
  int? quantity;
  bool? hasModifierGroups;
  ItemBrandModel? brand;

  BillingItem(
      {this.id,
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
      this.brand});

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
    if(discountType != null){
      data['discount_type'] = discountType;
    }
    if(discountValue != null){
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
    return data;
  }
}
