import 'package:klikit/modules/add_order/data/models/title_v2.dart';

import 'cart_item_modifier_group.dart';
import 'item_brand.dart';
import 'item_price.dart';
import 'item_status.dart';
import 'item_stock.dart';

class Items {
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
  List<CartItemModifierGroup>? groups;
  int? quantity;
  bool? hasModifierGroups;
  ItemBrandModel? brand;

  Items(
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
      this.groups,
      this.quantity,
      this.hasModifierGroups,
      this.brand});

  // Items.fromJson(Map<String, dynamic> json) {
  //   id = json['id'];
  //   title = json['title'];
  //   if (json['prices'] != null) {
  //     prices = <Prices>[];
  //     json['prices'].forEach((v) {
  //       prices!.add(new Prices.fromJson(v));
  //     });
  //   }
  //   vat = json['vat'];
  //   description = json['description'];
  //   skuId = json['sku_id'];
  //   image = json['image'];
  //   enabled = json['enabled'];
  //   hidden = json['hidden'];
  //   if (json['statuses'] != null) {
  //     statuses = <Statuses>[];
  //     json['statuses'].forEach((v) {
  //       statuses!.add(new Statuses.fromJson(v));
  //     });
  //   }
  //   sequence = json['sequence'];
  //   defaultItemId = json['default_item_id'];
  //   stock = json['stock'] != null ? new Stock.fromJson(json['stock']) : null;
  //   titleV2 = json['title_v2'] != null
  //       ? new TitleV2.fromJson(json['title_v2'])
  //       : null;
  //   descriptionV2 = json['description_v2'] != null
  //       ? new TitleV2.fromJson(json['description_v2'])
  //       : null;
  //   cartId = json['cart_id'];
  //   itemId = json['item_id'];
  //   unitPrice = json['unit_price'];
  //   if (json['groups'] != null) {
  //     groups = <Groups>[];
  //     json['groups'].forEach((v) {
  //       groups!.add(new Groups.fromJson(v));
  //     });
  //   }
  //   quantity = json['quantity'];
  //   hasModifierGroups = json['has_modifier_groups'];
  //   brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    if (prices != null) {
      data['prices'] = prices!.map((v) => v.toJson()).toList();
    }
    data['vat'] = vat;
    data['description'] = description;
    data['sku_id'] = skuId;
    data['image'] = image;
    data['enabled'] = enabled;
    data['hidden'] = hidden;
    if (statuses != null) {
      data['statuses'] = statuses!.map((v) => v.toJson()).toList();
    }
    data['sequence'] = sequence;
    data['default_item_id'] = defaultItemId;
    if (stock != null) {
      data['stock'] = stock!.toJson();
    }
    if (titleV2 != null) {
      data['title_v2'] = titleV2!.toJson();
    }
    if (descriptionV2 != null) {
      data['description_v2'] = descriptionV2!.toJson();
    }
    data['cart_id'] = cartId;
    data['item_id'] = itemId;
    data['unit_price'] = unitPrice;
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    data['quantity'] = quantity;
    data['has_modifier_groups'] = hasModifierGroups;
    if (brand != null) {
      data['brand'] = brand!.toJson();
    }
    return data;
  }
}
