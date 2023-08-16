import '../../../data/models/modifier/item_price_model.dart';

class MenuItemModifierPrice {
  final int providerId;
  final int currencyId;
  final String code;
  final String symbol;
  final num price;

  MenuItemModifierPrice({
    required this.providerId,
    required this.currencyId,
    required this.code,
    required this.symbol,
    required this.price,
  });

  MenuItemModifierPrice copy() => MenuItemModifierPrice(
        providerId: providerId,
        currencyId: currencyId,
        code: code,
        symbol: symbol,
        price: price,
      );

  MenuItemPriceModel toModel() => MenuItemPriceModel(
        providerId: providerId,
        currencyId: currencyId,
        code: code,
        symbol: symbol,
        price: price,
      );
}
