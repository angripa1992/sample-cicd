import 'package:klikit/modules/menu/domain/entities/items.dart';

import '../../../menu/domain/entities/price.dart';
import 'item_modifier_group.dart';

class AddToCartItem {
  final List<ItemModifierGroup> modifiers;
  final MenuItems item;
  final int quantity;
  final num modifiersPrice;
  final Prices itemPrice;
  final String itemInstruction;

  AddToCartItem({
    required this.modifiers,
    required this.item,
    required this.quantity,
    required this.itemInstruction,
    required this.modifiersPrice,
    required this.itemPrice,
  });
}
