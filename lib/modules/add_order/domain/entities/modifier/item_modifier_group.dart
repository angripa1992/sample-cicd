import 'item_modifier.dart';
import 'item_visibility.dart';
import 'modifier_rule.dart';

class AddOrderItemModifierGroup {
  final int groupId;
  final String title;
  final String label;
  final int brandId;
  final int sequence;
  final bool enabled;
  final List<AddOrderModifierItemVisibility> visibilities;
  final AddOrderItemModifierRule rule;
  final List<AddOrderItemModifier> modifiers;

  AddOrderItemModifierGroup({
    required this.groupId,
    required this.title,
    required this.label,
    required this.brandId,
    required this.sequence,
    required this.enabled,
    required this.visibilities,
    required this.rule,
    required this.modifiers,
  });

  AddOrderItemModifierGroup copy() => AddOrderItemModifierGroup(
        groupId: groupId,
        title: title,
        label: label,
        brandId: brandId,
        sequence: sequence,
        enabled: enabled,
        visibilities: visibilities.map((e) => e.copy()).toList(),
        rule: rule.copy(),
        modifiers: modifiers.map((e) => e.copy()).toList(),
      );
}
