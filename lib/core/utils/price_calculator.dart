import '../../app/constants.dart';
import '../../modules/orders/domain/entities/cart.dart';
import '../../modules/orders/domain/entities/order.dart';

class PriceCalculator {
  static String calculateItemPrice(Order order, CartV2 cartV2) {
    if (!order.isInterceptorOrder && order.providerId != ProviderID.FOOD_PANDA) {
      double unitPrice = double.parse(cartV2.unitPrice);
      double itemTotalPrice = unitPrice * cartV2.quantity;
      return itemTotalPrice.toStringAsFixed(2);
    }
    return cartV2.price;
  }

  static String calculateModifierPrice(
      Order order, Modifiers modifiers, int prevQuantity, int itemQuantity) {
    if (!order.isInterceptorOrder &&
        order.providerId != ProviderID.FOOD_PANDA) {
      double unitPrice = double.parse(modifiers.unitPrice);
      double modifierTotalPrice =
          unitPrice * modifiers.quantity * prevQuantity * itemQuantity;
      return modifierTotalPrice.toStringAsFixed(2);
    }
    return modifiers.price;
  }

  static String calculateSubtotal(Order order) {
    num subtotal;
    if (order.providerId == ProviderID.FOOD_PANDA) {
      subtotal = (order.finalPrice + order.discount) - order.deliveryFee;
    } else {
      subtotal = order.itemPrice;
    }
    return convertPrice(subtotal);
  }

  static String convertPrice(num price) {
    return (price / 100).toStringAsFixed(2);
  }
}
