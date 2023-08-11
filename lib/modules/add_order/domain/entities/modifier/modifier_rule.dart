import '../../../data/models/modifier/modifier_rule.dart';

class AddOrderItemModifierRule {
  final int id;
  final String title;
  final String typeTitle;
  final int value;
  final int brandId;
  final int min;
  final int max;

  AddOrderItemModifierRule({
    required this.id,
    required this.title,
    required this.typeTitle,
    required this.value,
    required this.brandId,
    required this.min,
    required this.max,
  });

  AddOrderItemModifierRule copy() => AddOrderItemModifierRule(
        id: id,
        title: title,
        typeTitle: typeTitle,
        value: value,
        brandId: brandId,
        min: min,
        max: max,
      );

  ModifierRuleModel toModel() => ModifierRuleModel(
        id: id,
        title: title,
        typeTitle: typeTitle,
        value: value,
        brandId: brandId,
        min: min,
        max: max,
      );
}
