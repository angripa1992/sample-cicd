import 'package:klikit/modules/add_order/domain/entities/item_price.dart';

import '../../../app/constants.dart';
import '../../../core/utils/price_calculator.dart';

class OrderPriceProvider {
  static String modifierPrice(List<ItemPrice> prices) {
    final price = prices.firstWhere((element) => element.providerId == ProviderID.KLIKIT);
    final priceStr = PriceCalculator.formatPrice(
      price: price.price,
      code: price.code,
      symbol: price.symbol,
    );
    return '+ $priceStr';
  }
}
