import 'package:klikit/modules/add_order/data/models/modifier/title_v2_model.dart';

import '../modifier/item_price_model.dart';
import '../modifier/item_status_model.dart';
import 'billing_item_modifier_group_request.dart';

class BillingItemModifierRequestModel {
  int? id;
  int? klkitID;
  int? klkitGroupID;
  int? modifierId;
  List<MenuItemStatusModel>? statuses;
  List<MenuItemPriceModel>? prices;
  List<BillingItemModifierGroupRequestModel>? groups;
  bool? isSelected;
  int? modifierQuantity;
  num? extraPrice;
  int? immgId;
  String? klkitSkuID;
  String? title;
  String? klikitName;
  String? klikitGroupName;
  String? klikitImage;
  num? klikitModifierPrice;
  int? sequence;
  MenuItemTitleV2Model? titleV2;
  String? selectedTitle;

  BillingItemModifierRequestModel({
    this.id,
    this.modifierId,
    this.statuses,
    this.prices,
    this.groups,
    this.isSelected,
    this.modifierQuantity,
    this.extraPrice,
    this.immgId,
    this.title,
    this.sequence,
    this.titleV2,
    this.selectedTitle,
    this.klkitID,
    this.klikitName,
    this.klikitModifierPrice,
    this.klkitSkuID,
    this.klikitImage,
    this.klkitGroupID,
    this.klikitGroupName,
  });

  Map<String, dynamic> toJsonV1() {
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
      data['groups'] = groups!.map((v) => v.toJsonV1()).toList();
    }
    data['is_selected'] = isSelected;
    data['modifier_quantity'] = modifierQuantity;
    data['extra_price'] = extraPrice;
    data['selectedTitle'] = selectedTitle;
    data['klikit_id'] = klkitID;
    data['klikit_name'] = klikitName;
    data['klikit_modifier_price'] = klikitModifierPrice;
    data['klikit_sku_id'] = klkitSkuID;
    data['klikit_image'] = klikitImage;
    data['klikit_group_id'] = klkitGroupID;
    data['klikit_group_name'] = klikitGroupName;
    return data;
  }

  Map<String, dynamic> toJsonV2() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['modifier_id'] = modifierId;
    if (groups != null) {
      data['groups'] = groups!.map((v) => v.toJsonV2()).toList();
    }
    data['is_selected'] = isSelected;
    data['modifier_quantity'] = modifierQuantity;
    data['extra_price'] = extraPrice;
    data['klikit_id'] = klkitID;
    data['klikit_name'] = klikitName;
    data['klikit_modifier_price'] = klikitModifierPrice;
    data['klikit_sku_id'] = klkitSkuID;
    data['klikit_image'] = klikitImage;
    data['klikit_group_id'] = klkitGroupID;
    data['klikit_group_name'] = klikitGroupName;
    return data;
  }
}
