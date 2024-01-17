import 'package:klikit/modules/add_order/domain/entities/cart_bill.dart';
import 'package:klikit/modules/common/entities/brand.dart';

import '../../../menu/domain/entities/menu/menu_item.dart';
import '../../../menu/domain/entities/item_price.dart';
import '../../data/models/applied_promo.dart';
import '../../data/models/request/webshop_calculate_bill_payload.dart';
import 'modifier/item_modifier_group.dart';

class AddToCartItem {
  final List<MenuItemModifierGroup> modifiers;
  final MenuCategoryItem item;
  final num modifiersPrice;
  final ItemPrice itemPrice;
  String itemInstruction;
  Brand brand;
  int quantity;
  int discountType;
  num discountValue;
  AppliedPromoInfo? promoInfo;
  int? cartIndex;

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
    this.cartIndex,
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

class CartFee {
  final int discountType;
  final num discountValue;
  final num additionalFee;
  final num deliveryFee;

  CartFee({
    required this.discountType,
    required this.discountValue,
    required this.additionalFee,
    required this.deliveryFee,
  });
}

class PaymentInfo {
  final int? paymentStatus;
  final int? paymentMethod;
  final int? paymentChannel;

  PaymentInfo({
    required this.paymentStatus,
    required this.paymentMethod,
    required this.paymentChannel,
  });
}

class CustomerInfo {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String tableNo;

  CustomerInfo({required this.firstName, required this.lastName, required this.email, required this.phone, required this.tableNo});
}

class UpdateCartInfo {
  final int orderID;
  final String externalId;
  final String identity;
  final bool isPrePayment;
  final bool isWebShopOrder;
  final bool willUpdateOrder;
  final num totalPrice;
  final String orderHash;
  final OrderDeliveryLocation? deliveryLocation;

  UpdateCartInfo({
    required this.orderID,
    required this.externalId,
    required this.identity,
    required this.isPrePayment,
    required this.isWebShopOrder,
    required this.willUpdateOrder,
    required this.totalPrice,
    required this.orderHash,
    this.deliveryLocation,
  });
}
