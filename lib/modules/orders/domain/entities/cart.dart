import 'package:klikit/modules/orders/domain/entities/brand.dart';

import '../../data/models/orders_model.dart';

class CartV2 {
  final String id;
  final String externalId;
  final String name;
  final String image;
  final String price;
  final String comment;
  final String unitPrice;
  final CartBrand cartBrand;
  final String unitPriceDisplay;
  final String priceDisplay;
  final String modifierGroupPrice;
  final List<ModifierGroups> modifierGroups;
  int quantity;

  CartV2({
    required this.id,
    required this.externalId,
    required this.name,
    required this.image,
    required this.price,
    required this.comment,
    required this.quantity,
    required this.unitPrice,
    required this.cartBrand,
    required this.modifierGroups,
    required this.unitPriceDisplay,
    required this.priceDisplay,
    required this.modifierGroupPrice,
  });

  CartV2 copy() => CartV2(
        id: id,
        externalId: externalId,
        name: name,
        image: image,
        price: price,
        comment: comment,
        quantity: quantity,
        unitPrice: unitPrice,
        modifierGroupPrice: modifierGroupPrice,
        unitPriceDisplay: unitPriceDisplay,
        priceDisplay: priceDisplay,
        cartBrand: cartBrand.copy(),
        modifierGroups: modifierGroups.map((e) => e.copy()).toList(),
      );

  CartV2Model toModel() => CartV2Model(
        id: id,
        externalId: externalId,
        name: name,
        image: image,
        price: price,
        comment: comment,
        quantity: quantity,
        brand: cartBrand.toModel(),
        unitPrice: unitPrice,
        unitPriceDisplay: unitPriceDisplay,
        priceDisplay: priceDisplay,
        modifierGroupPrice: modifierGroupPrice,
        modifierGroups: modifierGroups.map((e) => e.toModel()).toList(),
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

  ModifierGroupsModel toModel() => ModifierGroupsModel(
        id: id,
        name: name,
        modifiers: modifiers.map((e) => e.toModel()).toList(),
      );
}

class Modifiers {
  final String id;
  final String name;
  final String price;
  final int quantity;
  final String unitPrice;
  final String priceDisplay;
  final String unitPriceDisplay;
  final List<ModifierGroups> modifierGroups;

  Modifiers({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.unitPrice,
    required this.modifierGroups,
    required this.priceDisplay,
    required this.unitPriceDisplay,
  });

  Modifiers copy() => Modifiers(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        unitPrice: unitPrice,
        unitPriceDisplay: unitPriceDisplay,
        priceDisplay: priceDisplay,
        modifierGroups: modifierGroups.map((e) => e.copy()).toList(),
      );

  ModifiersModel toModel() => ModifiersModel(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        unitPrice: unitPrice,
        unitPriceDisplay: unitPriceDisplay,
        priceDisplay: priceDisplay,
        modifierGroups: modifierGroups.map((e) => e.toModel()).toList(),
      );
}
