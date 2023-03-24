import '../../../app/constants.dart';
import '../../../core/utils/price_calculator.dart';
import '../../menu/domain/entities/price.dart';

class OrderPriceProvider {
  static String klikitItemPrice(List<Prices> prices) {
    final price =
        prices.firstWhere((element) => element.providerId == ProviderID.KLIKIT);
    return PriceCalculator.formatPrice(
      price: price.price,
      currencySymbol: price.symbol,
      name: price.code,
    );
  }
}
