import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/add_order/domain/entities/item_modifier_group.dart';

import 'item_modifier.dart';
import 'item_status.dart';
import 'modifier_rule.dart';

class ItemModifierGroupModel {
  int? groupId;
  String? title;
  String? label;
  int? brandId;
  int? sequence;
  List<ItemStatusModel>? statuses;
  ModifierRuleModel? rule;
  List<ItemModifierModel>? modifiers;

  ItemModifierGroupModel({
    this.groupId,
    this.title,
    this.label,
    this.brandId,
    this.sequence,
    this.statuses,
    this.rule,
    this.modifiers,
  });

  ItemModifierGroupModel.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    title = json['title'];
    label = json['label'];
    brandId = json['brand_id'];
    sequence = json['sequence'];
    rule = json['rule'] != null ? ModifierRuleModel.fromJson(json['rule']) : ModifierRuleModel();
    if (json['statuses'] != null) {
      statuses = <ItemStatusModel>[];
      json['statuses'].forEach((v) {
        statuses!.add(ItemStatusModel.fromJson(v));
      });
    }
    if (json['modifiers'] != null) {
      modifiers = <ItemModifierModel>[];
      json['modifiers'].forEach((v) {
        modifiers!.add(ItemModifierModel.fromJson(v));
      });
    }
  }

  ItemModifierGroup toEntity() {
    return ItemModifierGroup(
      groupId: groupId.orZero(),
      title: title.orEmpty(),
      label: label.orEmpty(),
      brandId: brandId.orZero(),
      sequence: sequence.orZero(),
      statuses: statuses?.map((e) => e.toEntity()).toList() ?? [],
      rule: rule?.toEntity() ?? ModifierRuleModel().toEntity(),
      modifiers: modifiers?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}
