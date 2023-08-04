import 'package:klikit/app/constants.dart';

import 'menu_available_times.dart';
import 'menu_item_price.dart';
import 'menu_out_of_stock.dart';
import 'menu_visibility.dart';

class MenuCategoryItem {
  final int id;
  final int defaultItemId;
  final String title;
  final String description;
  final List<MenuItemPrice> prices;
  final int vat;
  final String image;
  final bool enabled;
  final int sequence;
  final List<MenuVisibility> visibilities;
  final MenuAvailableTimes availableTimes;
  MenuOutOfStock outOfStock;

  MenuCategoryItem({
    required this.id,
    required this.defaultItemId,
    required this.title,
    required this.prices,
    required this.vat,
    required this.description,
    required this.image,
    required this.enabled,
    required this.visibilities,
    required this.sequence,
    required this.outOfStock,
    required this.availableTimes,
  });

  MenuItemPrice klikitPrice() => prices.firstWhere((element) => element.providerId == ProviderID.KLIKIT);

  bool visible(int providerID) {
    final visibility = visibilities.firstWhere((element) => element.providerID == providerID);
    return visibility.visible;
  }
}
