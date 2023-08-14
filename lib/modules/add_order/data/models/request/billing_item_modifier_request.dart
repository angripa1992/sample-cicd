import 'package:klikit/modules/add_order/data/models/modifier/title_v2_model.dart';

import 'billing_item_modifier_group_request.dart';
import '../modifier/item_price_model.dart';
import '../modifier/item_status_model.dart';

class BillingItemModifierRequestModel {
  int? id;
  int? modifierId;
  List<AddOrderItemStatusModel>? statuses;
  List<AddOrderItemPriceModel>? prices;
  List<BillingItemModifierGroupRequestModel>? groups;
  bool? isSelected;
  int? modifierQuantity;
  num? extraPrice;

  BillingItemModifierRequestModel({
    this.id,
    this.modifierId,
    this.statuses,
    this.prices,
    this.groups,
    this.isSelected,
    this.modifierQuantity,
    this.extraPrice,
  });

  BillingItemModifierRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modifierId = json['modifier_id'];
    // immgId = json['immg_id'];
    // title = json['title'];
    //sequence = json['sequence'];
    // titleV2 = json['title_v2'] != null
    //     ? AddOrderTitleV2Model.fromJson(json['title_v2'])
    //     : null;
    if (json['statuses'] != null) {
      statuses = <AddOrderItemStatusModel>[];
      json['statuses'].forEach((v) {
        statuses!.add(AddOrderItemStatusModel.fromJson(v));
      });
    }
    if (json['prices'] != null) {
      prices = <AddOrderItemPriceModel>[];
      json['prices'].forEach((v) {
        prices!.add(AddOrderItemPriceModel.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = <BillingItemModifierGroupRequestModel>[];
      json['groups'].forEach((v) {
        groups!.add(BillingItemModifierGroupRequestModel.fromJson(v));
      });
    }
    isSelected = json['is_selected'];
    modifierQuantity = json['modifier_quantity'];
    extraPrice = json['extra_price'];
    // if (selectedTitle != null) {
    //   selectedTitle = json['selectedTitle'];
    // }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['modifier_id'] = modifierId;
    // data['immg_id'] = immgId;
    // data['title'] = title;
    // data['sequence'] = sequence;
    // if (titleV2 != null) {
    //   data['title_v2'] = titleV2!.toJson();
    // }
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
   // data['selectedTitle'] = selectedTitle;
    return data;
  }
}
