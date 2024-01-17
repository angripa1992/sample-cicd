import '../../../../../app/constants.dart';
import '../../../../../core/utils/price_calculator.dart';
import '../item_price.dart';
import 'modifier_visibility.dart';

class GroupedModifierItem {
  final int menuVersion;
  final int id;
  final int businessID;
  final String title;
  final String description;
  final int sequence;
  final List<ModifierVisibility> visibilities;
  final List<ItemPrice> prices;
  bool isEnabled;

  GroupedModifierItem({
    required this.menuVersion,
    required this.id,
    required this.businessID,
    required this.title,
    required this.description,
    required this.sequence,
    required this.isEnabled,
    required this.visibilities,
    required this.prices,
  });

  String klikitPrice() {
    final itemPrice = prices.firstWhere((element) => element.providerId == ProviderID.KLIKIT);
    return PriceCalculator.formatPrice(
      price: itemPrice.price(),
      code: itemPrice.currencyCode,
      symbol: itemPrice.currencySymbol,
    );
  }
}
