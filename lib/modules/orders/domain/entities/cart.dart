import 'package:klikit/modules/orders/domain/entities/brand.dart';

class CartV2 {
  final String id;
  final String name;
  final String image;
  final String price;
  final String comment;
  final int quantity;
  final String unitPrice;
  final CartBrand cartBrand;
  final List<ModifierGroups> modifierGroups;

  CartV2({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.comment,
    required this.quantity,
    required this.unitPrice,
    required this.cartBrand,
    required this.modifierGroups,
  });

  CartV2 copy() => CartV2(
        id: id,
        name: name,
        image: image,
        price: price,
        comment: comment,
        quantity: quantity,
        unitPrice: unitPrice,
        cartBrand: cartBrand.copy(),
        modifierGroups: modifierGroups.map((e) => e.copy()).toList(),
      );
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

  ModifierGroups copy() => ModifierGroups(
        id: id,
        name: name,
        modifiers: modifiers.map((e) => e.copy()).toList(),
      );
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

  Modifiers copy() => Modifiers(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        unitPrice: unitPrice,
        modifierGroups: modifierGroups.map((e) => e.copy()).toList(),
      );
}
