import '../../data/models/item_price.dart';

class ItemPrice {
  final int providerId;
  final int currencyId;
  final String code;
  final String symbol;
  final double price;

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

  ItemPriceModel toModel() => ItemPriceModel(
        providerId: providerId,
        currencyId: currencyId,
        code: code,
        symbol: symbol,
        price: price,
      );
}
