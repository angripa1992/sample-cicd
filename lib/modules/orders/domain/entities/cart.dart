import 'package:docket_design_template/model/cart.dart';
import 'package:docket_design_template/model/modifiers.dart';
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

  TemplateCart toTemplateCart() {
    return TemplateCart(
      id: id,
      name: name,
      image: image,
      price: price,
      comment: comment,
      quantity: quantity,
      unitPrice: unitPrice,
      modifierGroups: _templateModifiersGroups(),
    );
  }

  List<TemplateModifierGroups> _templateModifiersGroups() {
    List<TemplateModifierGroups> templateModifiersGroups = [];
    for (var element in modifierGroups) {
      templateModifiersGroups.add(element.toTemplateModifierGroups());
    }
    return templateModifiersGroups;
  }
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

  TemplateModifierGroups toTemplateModifierGroups() {
    return TemplateModifierGroups(
      id: id,
      name: name,
      modifiers: _templateModifiers(),
    );
  }

  List<TemplateModifiers> _templateModifiers() {
    List<TemplateModifiers> templateModifiers = [];
    for (var element in modifiers) {
      templateModifiers.add(element.toTemplateModifiers());
    }
    return templateModifiers;
  }
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

  TemplateModifiers toTemplateModifiers() {
    return TemplateModifiers(
      id: id,
      name: name,
      price: price,
      quantity: quantity,
      unitPrice: unitPrice,
      modifierGroups: _templateModifiersGroups(),
    );
  }

  List<TemplateModifierGroups> _templateModifiersGroups() {
    List<TemplateModifierGroups> templateModifiersGroups = [];
    for (var element in modifierGroups) {
      templateModifiersGroups.add(element.toTemplateModifierGroups());
    }
    return templateModifiersGroups;
  }
}
