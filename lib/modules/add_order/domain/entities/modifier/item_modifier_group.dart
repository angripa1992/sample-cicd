import 'item_modifier.dart';
import 'item_visibility.dart';
import 'modifier_rule.dart';

class MenuItemModifierGroup {
  final int groupId;
  final String title;
  final String label;
  final int brandId;
  final int sequence;
  final bool enabled;
  final List<MenuItemModifierVisibility> visibilities;
  final MenuItemModifierRule rule;
  final List<MenuItemModifier> modifiers;

  MenuItemModifierGroup({
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

  MenuItemModifierGroup copy() => MenuItemModifierGroup(
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
