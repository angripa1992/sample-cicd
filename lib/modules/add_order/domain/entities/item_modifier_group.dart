import 'item_modifier.dart';
import 'item_status.dart';
import 'modifier_rule.dart';

class ItemModifierGroup {
  final int groupId;
  final String title;
  final String label;
  final int brandId;
  final int sequence;
  final List<ItemStatus> statuses;
  final ModifierRule rule;
  final List<ItemModifier> modifiers;

  ItemModifierGroup({
    required this.groupId,
    required this.title,
    required this.label,
    required this.brandId,
    required this.sequence,
    required this.statuses,
    required this.rule,
    required this.modifiers,
  });

  ItemModifierGroup copy() => ItemModifierGroup(
        groupId: groupId,
        title: title,
        label: label,
        brandId: brandId,
        sequence: sequence,
        statuses: statuses.map((e) => e.copy()).toList(),
        rule: rule.copy(),
        modifiers: modifiers.map((e) => e.copy()).toList(),
      );
}
