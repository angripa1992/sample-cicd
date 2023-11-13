class MenuItemPrice {
  final int providerId;
  final int currencyId;
  final String currencyCode;
  final String currencySymbol;
  final num price;
  final num takeAwayPrice;
  final MenuItemAdvancedPrice advancedPrice;

  MenuItemPrice({
    required this.providerId,
    required this.currencyId,
    required this.currencyCode,
    required this.currencySymbol,
    required this.price,
    required this.takeAwayPrice,
    required this.advancedPrice,
  });
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
