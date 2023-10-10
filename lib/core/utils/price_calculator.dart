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
      code: order.currency,
      symbol: order.currencySymbol,
    );
  }

  static num calculateModifierPrice(
    Order order,
    Modifiers modifiers,
    int prevQuantity,
    int itemQuantity,
  ) {
    num modifierTotalPrice = num.parse(modifiers.price);
    if (!order.isInterceptorOrder &&
        order.providerId != ProviderID.FOOD_PANDA) {
      num unitPrice = num.parse(modifiers.unitPrice);
      modifierTotalPrice = unitPrice * modifiers.quantity * prevQuantity * itemQuantity;
    }
    return modifierTotalPrice;
  }

  static String calculateSubtotal(Order order) {
    // num subtotal;
    // if (order.providerId == ProviderID.FOOD_PANDA) {
    //   subtotal = (order.finalPrice + order.discount) - order.deliveryFee;
    // } else {
    //   subtotal = order.itemPrice;
    // }
    return convertPrice(order, order.itemPrice);
  }

  static String formatPrice({
    required num price,
    required String code,
    required String symbol,
  }) {
    if (code.toUpperCase() == 'IDR') {
      return NumberFormat.currency(
        locale:  'id',
        symbol: symbol,
        decimalDigits: 0,
      ).format(price);
    }else if(code.toUpperCase() == 'JPY'){
      return NumberFormat.currency(
        locale:  'ja',
        symbol: symbol,
        decimalDigits: 0,
      ).format(price);
    }
    return NumberFormat.currency(
      name: code,
      symbol: symbol,
      decimalDigits: 2,
    ).format(price);
  }

  static String convertPrice(Order order, num priceInCent) {
    final price = priceInCent / 100;
    return formatPrice(
      price: price,
      symbol: order.currencySymbol,
      code: order.currency,
    );
  }
}
