
import '../../../app/constants.dart';
import '../../../core/utils/price_calculator.dart';
import '../domain/entities/modifier/item_price.dart';

class OrderPriceProvider {
  static String modifierPrice(List<MenuItemModifierPrice> prices) {
    final price = prices.firstWhere((element) => element.providerId == ProviderID.KLIKIT);
    final priceStr = PriceCalculator.formatPrice(
      price: price.price,
      code: price.code,
      symbol: price.symbol,
    );
    return '+ $priceStr';
  }
}
