import 'package:klikit/app/constants.dart';
import 'package:klikit/app/session_manager.dart';

class MenuItemPrice {
  final int providerId;
  final int currencyId;
  final String currencyCode;
  final String currencySymbol;
  final num takeAwayPrice;
  final MenuItemAdvancedPrice advancedPrice;
  final num _price;

  MenuItemPrice({
    required this.providerId,
    required this.currencyId,
    required this.currencyCode,
    required this.currencySymbol,
    required this.takeAwayPrice,
    required this.advancedPrice,
    required num price,
  }) : _price = price;

  num advancePrice(int type) {
    if (SessionManager().menuV2EnabledForKlikitOrder()) {
      if (type == OrderType.PICKUP) {
        return advancedPrice.pickup;
      } else if (type == OrderType.DELIVERY) {
        return advancedPrice.delivery;
      } else {
        return advancedPrice.dineIn;
      }
    } else {
      return _price;
    }
  }

  num price() {
    return _price;
  }
}

class MenuItemAdvancedPrice {
  final num delivery;
  final num dineIn;
  final num pickup;

  MenuItemAdvancedPrice({
    required this.delivery,
    required this.dineIn,
    required this.pickup,
  });
}
