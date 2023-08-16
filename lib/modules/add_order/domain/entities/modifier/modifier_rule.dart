import '../../../data/models/modifier/modifier_rule.dart';

class MenuItemModifierRule {
  final int id;
  final String title;
  final String typeTitle;
  final int value;
  final int brandId;
  final int min;
  final int max;

  MenuItemModifierRule({
    required this.id,
    required this.title,
    required this.typeTitle,
    required this.value,
    required this.brandId,
    required this.min,
    required this.max,
  });

  MenuItemModifierRule copy() => MenuItemModifierRule(
        id: id,
        title: title,
        typeTitle: typeTitle,
        value: value,
        brandId: brandId,
        min: min,
        max: max,
      );

  MenuItemModifierRuleModel toModel() => MenuItemModifierRuleModel(
        min: min,
        max: max,
      );
}
