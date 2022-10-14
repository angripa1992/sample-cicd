
class CartV2 {
  final String id;
  final String name;
  final String image;
  final String price;
  final String comment;
  final int quantity;
  final String unitPrice;
  final List<ModifierGroups> modifierGroups;

  CartV2({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.comment,
    required this.quantity,
    required this.unitPrice,
    required this.modifierGroups,
  });
}

class ModifierGroups {
  final String id;
  final String name;
  final List<Modifiers> modifiers;

  ModifierGroups({
    required this.id,
    required this.name,
    required this.modifiers,
  });
}

class Modifiers {
  final String id;
  final String name;
  final String price;
  final int quantity;
  final String unitPrice;
  final List<ModifierGroups> modifierGroups;

  Modifiers({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.unitPrice,
    required this.modifierGroups,
  });
}
