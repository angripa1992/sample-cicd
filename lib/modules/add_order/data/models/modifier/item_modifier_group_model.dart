import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/add_order/domain/entities/modifier/item_modifier_group.dart';

import 'item_modifier_model.dart';
import 'item_status_model.dart';
import 'modifier_rule.dart';

class AddOrderItemModifierGroupModel {
  int? groupId;
  String? title;
  String? label;
  int? brandId;
  int? sequence;
  List<AddOrderItemStatusModel>? statuses;
  ModifierRuleModel? rule;
  List<AddOrderItemModifierModel>? modifiers;

  AddOrderItemModifierGroupModel({
    this.groupId,
    this.title,
    this.label,
    this.brandId,
    this.sequence,
    this.statuses,
    this.rule,
    this.modifiers,
  });

  AddOrderItemModifierGroupModel.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    title = json['title'];
    label = json['label'];
    brandId = json['brand_id'];
    sequence = json['sequence'];
    rule = json['rule'] != null ? ModifierRuleModel.fromJson(json['rule']) : ModifierRuleModel();
    if (json['statuses'] != null) {
      statuses = <AddOrderItemStatusModel>[];
      json['statuses'].forEach((v) {
        statuses!.add(AddOrderItemStatusModel.fromJson(v));
      });
    }
    if (json['modifiers'] != null) {
      modifiers = <AddOrderItemModifierModel>[];
      json['modifiers'].forEach((v) {
        modifiers!.add(AddOrderItemModifierModel.fromJson(v));
      });
    }
  }

  // AddOrderItemModifierGroup toEntity() {
  //   return AddOrderItemModifierGroup(
  //     groupId: groupId.orZero(),
  //     title: title.orEmpty(),
  //     label: label.orEmpty(),
  //     brandId: brandId.orZero(),
  //     sequence: sequence.orZero(),
  //     statuses: statuses?.map((e) => e.toEntity()).toList() ?? [],
  //     rule: rule?.toEntity() ?? ModifierRuleModel().toEntity(),
  //     modifiers: modifiers?.map((e) => e.toEntity()).toList() ?? [],
  //   );
  // }
}
