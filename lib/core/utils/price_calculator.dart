import 'package:intl/intl.dart';

import '../../app/constants.dart';
import '../../modules/orders/domain/entities/cart.dart';
import '../../modules/orders/domain/entities/order.dart';

class PriceCalculator {
  static String calculateItemPrice(Order order, CartV2 cartV2) {
    double price = double.parse(cartV2.price);
    if (!order.isInterceptorOrder &&
        order.providerId != ProviderID.FOOD_PANDA) {
      double unitPrice = double.parse(cartV2.unitPrice);
      price = unitPrice * cartV2.quantity;
    }
    return formatPrice(
        price: price,
        currencySymbol: order.currencySymbol,
        name: order.currency);
  }

  static String calculateModifierPrice(
    Order order,
    Modifiers modifiers,
    int prevQuantity,
    int itemQuantity,
  ) {
    double price = double.parse(modifiers.price);
    if (!order.isInterceptorOrder &&
        order.providerId != ProviderID.FOOD_PANDA) {
      double unitPrice = double.parse(modifiers.unitPrice);
      price = unitPrice * modifiers.quantity * prevQuantity * itemQuantity;
    }
    return formatPrice(
        price: price,
        currencySymbol: order.currencySymbol,
        name: order.currency);
  }

  static String calculateSubtotal(Order order) {
    num subtotal;
    if (order.providerId == ProviderID.FOOD_PANDA) {
      subtotal = (order.finalPrice + order.discount) - order.deliveryFee;
    } else {
      subtotal = order.itemPrice;
    }
    final price = subtotal / 100;
    return formatPrice(
        price: price,
        currencySymbol: order.currencySymbol,
        name: order.currency);
  }

  static String formatPrice({
    required num price,
    required String currencySymbol,
    required String name,
  }) {
    if (name.toUpperCase() == 'IDR') {
      return NumberFormat.currency(locale: 'id',symbol: currencySymbol, decimalDigits: 0).format(price);
    }
    return NumberFormat.currency(name: name, symbol: currencySymbol)
        .format(price);
  }

  static String convertPrice(num price) {
    return (price / 100).toStringAsFixed(2);
  }
}
