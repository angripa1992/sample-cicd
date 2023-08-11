import '../../../data/models/modifier/item_price_model.dart';

class AddOrderModifierItemPrice {
  final int providerId;
  final int currencyId;
  final String code;
  final String symbol;
  final num price;

  AddOrderModifierItemPrice({
    required this.providerId,
    required this.currencyId,
    required this.code,
    required this.symbol,
    required this.price,
  });

  AddOrderModifierItemPrice copy() => AddOrderModifierItemPrice(
        providerId: providerId,
        currencyId: currencyId,
        code: code,
        symbol: symbol,
        price: price,
      );

  AddOrderItemPriceModel toModel() => AddOrderItemPriceModel(
        providerId: providerId,
        currencyId: currencyId,
        code: code,
        symbol: symbol,
        price: price,
      );
}
