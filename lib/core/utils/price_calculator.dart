import 'package:intl/intl.dart';

import '../../app/constants.dart';
import '../../modules/orders/domain/entities/cart.dart';
import '../../modules/orders/domain/entities/order.dart';

class PriceCalculator {
  static String calculateItemPrice(Order order, CartV2 cartV2) {
    num itemTotalPrice = num.parse(cartV2.price);
    if (!order.isInterceptorOrder &&
        order.providerId != ProviderID.FOOD_PANDA) {
      num unitPrice = num.parse(cartV2.unitPrice);
      itemTotalPrice = unitPrice * cartV2.quantity;
    }
    return formatPrice(
      price: itemTotalPrice,
      currencySymbol: order.currencySymbol,
      code: order.currency,
    );
  }

  static String calculateModifierPrice(
    Order order,
    Modifiers modifiers,
    int prevQuantity,
    int itemQuantity,
  ) {
    num modifierTotalPrice = num.parse(modifiers.price);
    if (!order.isInterceptorOrder &&
        order.providerId != ProviderID.FOOD_PANDA) {
      num unitPrice = num.parse(modifiers.unitPrice);
      modifierTotalPrice =
          unitPrice * modifiers.quantity * prevQuantity * itemQuantity;
    }
    return formatPrice(
        price: modifierTotalPrice,
        currencySymbol: order.currencySymbol,
        code: order.currency);
  }

  static String calculateSubtotal(Order order) {
    num subtotal;
    if (order.providerId == ProviderID.FOOD_PANDA) {
      subtotal = (order.finalPrice + order.discount) - order.deliveryFee;
    } else {
      subtotal = order.itemPrice;
    }
    return convertPrice(order, subtotal);
  }

  static String formatPrice({
    required num price,
    required String currencySymbol,
    required String code,
  }) {
    if (code.toUpperCase() == 'IDR') {
      return NumberFormat.currency(
        locale: 'id',
        symbol: currencySymbol,
        decimalDigits: 0,
      ).format(price);
    }
    return NumberFormat.currency(name: code, symbol: currencySymbol).format(price);
  }

  static String convertPrice(Order order, num priceInCent) {
    final price = priceInCent / 100;
    return formatPrice(
      price: price,
      currencySymbol: order.currencySymbol,
      code: order.currency,
    );
  }
}
