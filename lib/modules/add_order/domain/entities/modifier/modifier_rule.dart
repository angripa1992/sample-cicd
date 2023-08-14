import '../../../data/models/modifier/modifier_rule.dart';

class AddOrderItemModifierRule {
  final int min;
  final int max;

  AddOrderItemModifierRule({
    required this.min,
    required this.max,
  });

  AddOrderItemModifierRule copy() => AddOrderItemModifierRule(
        min: min,
        max: max,
      );

  ModifierRuleModel toModel() => ModifierRuleModel(
        min: min,
        max: max,
      );
}
