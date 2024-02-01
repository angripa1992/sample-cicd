import 'package:collection/collection.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/utils/price_calculator.dart';
import 'package:klikit/modules/menu/domain/entities/item_price.dart';

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
    final itemPrice = prices.firstWhereOrNull((element) => element.providerId == ProviderID.KLIKIT);
    return PriceCalculator.formatPrice(
      price: itemPrice?.price() ?? 0,
      code: itemPrice?.currencyCode ?? '',
      symbol: itemPrice?.currencySymbol ?? '',
    );
  }

  bool visible() {
    if (visibilities.isEmpty) return true;
    final itemVisibility = visibilities.firstWhereOrNull((element) => element.providerID == ProviderID.KLIKIT);
    return itemVisibility?.isVisible ?? true;
  }
}
