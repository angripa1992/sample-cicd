import '../modifier/item_status_model.dart';
import '../modifier/modifier_rule.dart';
import '../modifier/title_v2_model.dart';
import 'billing_item_modifier_request.dart';

class BillingItemModifierGroupRequestModel {
  int? groupId;
  int? klikitGroupId;
  String? title;
  String? klikitGroupName;
  String? label;
  MenuItemTitleV2Model? titleV2;
  int? brandId;
  int? sequence;
  List<MenuItemStatusModel>? statuses;
  MenuItemModifierRuleModel? rule;
  List<BillingItemModifierRequestModel>? modifiers;

  BillingItemModifierGroupRequestModel({
    this.groupId,
    this.klikitGroupId,
    this.title,
    this.klikitGroupName,
    this.label,
    this.titleV2,
    this.brandId,
    this.sequence,
    this.statuses,
    this.rule,
    this.modifiers,
  });

  Map<String, dynamic> toJsonV1() {
    final Map<String, dynamic> data = {};
    data['group_id'] = groupId;
    // data['klikit_group_id'] = groupId;
    // data['klikit_group_name'] = title;
    data['title'] = title;
    data['label'] = label;
    data['brand_id'] = brandId;
    data['sequence'] = sequence;
    if (titleV2 != null) {
      data['title_v2'] = titleV2!.toJson();
    }
    if (statuses != null) {
      data['statuses'] = statuses!.map((v) => v.toJson()).toList();
    }
    if (rule != null) {
      data['rule'] = rule!.toJsonV1();
    }
    if (modifiers != null) {
      data['modifiers'] = modifiers!.map((v) => v.toJsonV1()).toList();
    }
    return data;
  }

  Map<String, dynamic> toJsonV2() {
    final Map<String, dynamic> data = {};
    data['group_id'] = groupId;
    // data['klikit_group_id'] = groupId;
    // data['klikit_group_name'] = title;
    if (rule != null) {
      data['rule'] = rule!.toJsonV2();
    }
    if (modifiers != null) {
      data['modifiers'] = modifiers!.map((v) => v.toJsonV2()).toList();
    }
    return data;
  }
}
