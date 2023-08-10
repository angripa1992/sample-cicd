import 'package:klikit/modules/add_order/data/models/title_v2.dart';

import 'billing_item_modifier_request.dart';
import '../item_status.dart';
import '../modifier_rule.dart';

class BillingItemModifierGroupRequestModel{
  int? groupId;
  String? title;
  String? label;
  int? brandId;
  int? sequence;
  TitleV2Model? titleV2;
  List<ItemStatusModel>? statuses;
  ModifierRuleModel? rule;
  List<BillingItemModifierRequestModel>? modifiers;

  BillingItemModifierGroupRequestModel(
      {this.groupId,
        this.title,
        this.label,
        this.brandId,
        this.sequence,
        this.titleV2,
        this.statuses,
        this.rule,
        this.modifiers});

  BillingItemModifierGroupRequestModel.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    title = json['title'];
    label = json['label'];
    brandId = json['brand_id'];
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
    rule = json['rule'] != null ?  ModifierRuleModel.fromJson(json['rule']) : null;
    if (json['modifiers'] != null) {
      modifiers = <BillingItemModifierRequestModel>[];
      json['modifiers'].forEach((v) {
        modifiers!.add(BillingItemModifierRequestModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['group_id'] = groupId;
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
      data['rule'] = rule!.toJson();
    }
    if (modifiers != null) {
      data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}