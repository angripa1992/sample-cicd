class MenuItemPrice {
  final int providerId;
  final int currencyId;
  final String currencyCode;
  final double price;
  final double takeAwayPrice;

  MenuItemPrice({
    required this.providerId,
    required this.currencyId,
    required this.currencyCode,
    required this.price,
    required this.takeAwayPrice,
  });
}
