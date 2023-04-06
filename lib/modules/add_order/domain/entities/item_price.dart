class ItemPrice {
  final int providerId;
  final int currencyId;
  final String code;
  final String symbol;
  final int price;

  ItemPrice({
    required this.providerId,
    required this.currencyId,
    required this.code,
    required this.symbol,
    required this.price,
  });

  ItemPrice copy() => ItemPrice(
        providerId: providerId,
        currencyId: currencyId,
        code: code,
        symbol: symbol,
        price: price,
      );
}
