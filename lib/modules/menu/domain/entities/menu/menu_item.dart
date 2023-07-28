import 'menu_available_times.dart';
import 'menu_item_price.dart';
import 'menu_out_of_stock.dart';

class MenuItem {
  final int id;
  final String title;
  final String description;
  final List<MenuItemPrice> prices;
  final int vat;
  final String image;
  final bool enabled;
  final bool visibility;
  final int sequence;
  final MenuAvailableTimes availableTimes;
  OutOfStock outOfStock;

  MenuItem({
    required this.id,
    required this.title,
    required this.prices,
    required this.vat,
    required this.description,
    required this.image,
    required this.enabled,
    required this.visibility,
    required this.sequence,
    required this.outOfStock,
    required this.availableTimes,
  });
}
