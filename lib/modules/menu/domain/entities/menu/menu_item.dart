import 'package:klikit/app/constants.dart';
import 'package:collection/collection.dart';

import 'menu_available_times.dart';
import 'menu_item_price.dart';
import 'menu_out_of_stock.dart';
import 'menu_resources.dart';
import 'menu_visibility.dart';

class MenuCategoryItem {
  final int menuVersion;
  final int id;
  final int defaultItemId;
  final String title;
  final String description;
  final List<MenuItemPrice> prices;
  final int vat;
  final String image;
  final int sequence;
  final List<MenuVisibility> visibilities;
  final MenuAvailableTimes availableTimes;
  final List<MenuResource>? resources;
  bool enabled;
  MenuOutOfStock outOfStock;

  MenuCategoryItem({
    required this.menuVersion,
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
    this.resources,
  });

  MenuItemPrice klikitPrice() => prices.firstWhere((element) => element.providerId == ProviderID.KLIKIT);

  bool visible(int providerID) {
    final visibility = visibilities.firstWhereOrNull((element) => element.providerID == providerID);
    if(visibility == null){
      return true;
    }
    return visibility.visible;
  }
}
