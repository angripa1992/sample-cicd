import 'package:klikit/modules/menu/domain/entities/items.dart';

import '../../../menu/domain/entities/brand.dart';
import '../../../menu/domain/entities/price.dart';
import 'item_modifier_group.dart';

class AddToCartItem {
  final List<ItemModifierGroup> modifiers;
  final MenuItems item;
  final num modifiersPrice;
  final Prices itemPrice;
  final String itemInstruction;
  MenuBrand brand;
  int quantity;
  int? discountType;
  num? discountValue;

  AddToCartItem({
    required this.modifiers,
    required this.item,
    required this.quantity,
    required this.itemInstruction,
    required this.modifiersPrice,
    required this.itemPrice,
    required this.brand,
    this.discountType,
    this.discountValue,
  });

  AddToCartItem copy() => AddToCartItem(
        modifiers: modifiers.map((e) => e.copy()).toList(),
        item: item,
        quantity: quantity,
        itemInstruction: itemInstruction,
        modifiersPrice: modifiersPrice,
        itemPrice: itemPrice,
        brand: brand,
        discountType: discountType,
        discountValue: discountValue,
      );
}
