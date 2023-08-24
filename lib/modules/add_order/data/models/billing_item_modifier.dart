import 'package:klikit/modules/add_order/data/models/title_v2.dart';

import 'billing_item_modifier_group.dart';
import 'item_price.dart';
import 'item_status.dart';

class BillingItemModifier {
  int? id;
  int? modifierId;
  int? immgId;
  String? title;
  int? sequence;
  TitleV2Model? titleV2;
  List<ItemStatusModel>? statuses;
  List<ItemPriceModel>? prices;
  List<BillingItemModifierGroup>? groups;
  bool? isSelected;
  int? modifierQuantity;
  num? extraPrice;
  String? selectedTitle;

  BillingItemModifier(
      {this.id,
      this.modifierId,
      this.immgId,
      this.title,
      this.sequence,
      this.titleV2,
      this.statuses,
      this.prices,
      this.groups,
      this.isSelected,
      this.modifierQuantity,
      this.extraPrice,
      this.selectedTitle});

  BillingItemModifier.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modifierId = json['modifier_id'];
    immgId = json['immg_id'];
    title = json['title'];
    sequence = json['sequence'];
    titleV2 = json['title_v2'] != null
        ? TitleV2Model.fromJson(json['title_v2'])
        : null;
    if (json['statuses'] != null) {
      statuses = <ItemStatusModel>[];
      json['statuses'].forEach((v) {
        statuses!.add(ItemStatusModel.fromJson(v));
      });
    }
    if (json['prices'] != null) {
      prices = <ItemPriceModel>[];
      json['prices'].forEach((v) {
        prices!.add(ItemPriceModel.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = <BillingItemModifierGroup>[];
      json['groups'].forEach((v) {
        groups!.add(BillingItemModifierGroup.fromJson(v));
      });
    }
    isSelected = json['is_selected'];
    modifierQuantity = json['modifier_quantity'];
    extraPrice = json['extra_price'];
    if (selectedTitle != null) {
      selectedTitle = json['selectedTitle'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['modifier_id'] = modifierId;
    data['immg_id'] = immgId;
    data['title'] = title;
    data['sequence'] = sequence;
    if (titleV2 != null) {
      data['title_v2'] = titleV2!.toJson();
    }
    if (statuses != null) {
      data['statuses'] = statuses!.map((v) => v.toJson()).toList();
    }
    if (prices != null) {
      data['prices'] = prices!.map((v) => v.toJson()).toList();
    }
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJson()).toList();
    }
    data['is_selected'] = isSelected;
    data['modifier_quantity'] = modifierQuantity;
    data['extra_price'] = extraPrice;
    data['selectedTitle'] = selectedTitle;
    return data;
  }
}
