import 'item_modifier_model.dart';
import 'item_status_model.dart';
import 'modifier_rule.dart';

class MenuItemModifierGroupModel {
  int? groupId;
  String? title;
  String? label;
  int? brandId;
  int? sequence;
  List<MenuItemStatusModel>? statuses;
  MenuItemModifierRuleModel? rule;
  List<MenuItemModifierModel>? modifiers;

  MenuItemModifierGroupModel({
    this.groupId,
    this.title,
    this.label,
    this.brandId,
    this.sequence,
    this.statuses,
    this.rule,
    this.modifiers,
  });

  MenuItemModifierGroupModel.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    title = json['title'];
    label = json['label'];
    brandId = json['brand_id'];
    sequence = json['sequence'];
    rule = json['rule'] != null
        ? MenuItemModifierRuleModel.fromJson(json['rule'])
        : MenuItemModifierRuleModel();
    if (json['statuses'] != null) {
      statuses = <MenuItemStatusModel>[];
      json['statuses'].forEach((v) {
        statuses!.add(MenuItemStatusModel.fromJson(v));
      });
    }
    if (json['modifiers'] != null) {
      modifiers = <MenuItemModifierModel>[];
      json['modifiers'].forEach((v) {
        modifiers!.add(MenuItemModifierModel.fromJson(v));
      });
    }
  }
}
