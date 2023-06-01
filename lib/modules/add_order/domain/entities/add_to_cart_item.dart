import 'package:klikit/modules/add_order/domain/entities/billing_response.dart';
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

class CartInfo {
  final int type;
  final int source;
  final int discountType;
  final num discountValue;
  final num additionalFee;
  final num deliveryFee;

  CartInfo({
    required this.type,
    required this.source,
    required this.discountType,
    required this.discountValue,
    required this.additionalFee,
    required this.deliveryFee,
  });
}

class PaymentInfo {
  final int? paymentStatus;
  final int? paymentMethod;

  PaymentInfo({required this.paymentStatus, required this.paymentMethod});
}

class CustomerInfo {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String tableNo;

  CustomerInfo(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phone,
      required this.tableNo});
}

class UpdateCartInfo {
  final int id;
  final String externalId;
  final String identity;

  UpdateCartInfo({
    required this.id,
    required this.externalId,
    required this.identity,
  });
}
