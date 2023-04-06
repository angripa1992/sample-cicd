class ModifierRule {
  final int id;
  final String title;
  final String typeTitle;
  final int value;
  final int brandId;
  final int min;
  final int max;

  ModifierRule({
    required this.id,
    required this.title,
    required this.typeTitle,
    required this.value,
    required this.brandId,
    required this.min,
    required this.max,
  });

  ModifierRule copy() => ModifierRule(
        id: id,
        title: title,
        typeTitle: typeTitle,
        value: value,
        brandId: brandId,
        min: min,
        max: max,
      );
}
