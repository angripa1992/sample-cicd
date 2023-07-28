import 'menu_available_times.dart';
import 'menu_item_price.dart';
import 'menu_out_of_stock.dart';
import 'menu_visibility.dart';

class MenuItem {
  final int id;
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

  MenuItem({
    required this.id,
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
}
