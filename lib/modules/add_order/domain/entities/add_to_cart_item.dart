import 'package:klikit/modules/add_order/domain/entities/billing_response.dart';

import '../../../menu/domain/entities/brand.dart';
import '../../../menu/domain/entities/menu/menu_item.dart';
import '../../../menu/domain/entities/menu/menu_item_price.dart';
import '../../data/models/applied_promo.dart';
import 'modifier/item_modifier_group.dart';

class AddToCartItem {
  final List<AddOrderItemModifierGroup> modifiers;
  final MenuCategoryItem item;
  final num modifiersPrice;
  final MenuItemPrice itemPrice;
  String itemInstruction;
  MenuBrand brand;
  int quantity;
  int discountType;
  num discountValue;
  PromoInfo? promoInfo;

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
    this.promoInfo,
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
  final String instruction;

  CheckoutData({
    required this.items,
    required this.type,
    required this.source,
    required this.cartBill,
    required this.discountType,
    required this.discountValue,
    required this.instruction,
  });
}

class CartInfo {
  final int type;
  final int source;
  final int discountType;
  final num discountValue;
  final num additionalFee;
  final num deliveryFee;
  final String comment;

  CartInfo({
    required this.type,
    required this.source,
    required this.discountType,
    required this.discountValue,
    required this.additionalFee,
    required this.deliveryFee,
    required this.comment,
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

class PromoInfo {
  AppliedPromo promo;
  int? citizen;
  int? customer;

  PromoInfo({
    required this.promo,
    required this.citizen,
    this.customer,
  });
}
