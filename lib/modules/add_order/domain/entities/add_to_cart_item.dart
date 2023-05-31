import 'package:klikit/modules/add_order/domain/entities/billing_response.dart';
import 'package:klikit/modules/menu/domain/entities/items.dart';

import '../../../menu/domain/entities/brand.dart';
import '../../../menu/domain/entities/price.dart';
import 'customer_info.dart';
import 'item_modifier_group.dart';

class AddToCartItem {
  final List<ItemModifierGroup> modifiers;
  final MenuItems item;
  final num modifiersPrice;
  final Prices itemPrice;
  final String itemInstruction;
  MenuBrand brand;
  int quantity;
  int discountType;
  num discountValue;

  AddToCartItem({
    required this.modifiers,
    required this.item,
    required this.quantity,
    required this.itemInstruction,
    required this.modifiersPrice,
    required this.itemPrice,
    required this.brand,
    required this.discountType,
    required this.discountValue,
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

class CheckoutData {
  final List<AddToCartItem> items;
  final int type;
  final int source;
  final CartBill cartBill;
  final int discountType;
  final num discountValue;

  CheckoutData({
    required this.items,
    required this.type,
    required this.source,
    required this.cartBill,
    required this.discountType,
    required this.discountValue,
  });
}

class EditableOrderInfo {
  final int type;
  final int source;
  final int discountType;
  final num discountValue;
  final int paymentStatus;
  final int paymentMethod;
  final num additionalFee;
  final num deliveryFee;

  EditableOrderInfo({
    required this.type,
    required this.source,
    required this.discountType,
    required this.discountValue,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.additionalFee,
    required this.deliveryFee,
  });
}
