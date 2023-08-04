import '../../../../../app/extensions.dart';

class MenuItemPrice {
  final int providerId;
  final int currencyId;
  final String currencyCode;
  final String currencySymbol;
  final num price;
  final num takeAwayPrice;

  MenuItemPrice({
    required this.providerId,
    required this.currencyId,
    required this.currencyCode,
    required this.currencySymbol,
    required this.price,
    required this.takeAwayPrice,
  });
}
