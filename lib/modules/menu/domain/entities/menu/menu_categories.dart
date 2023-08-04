import 'menu_item.dart';
import 'menu_available_times.dart';
import 'menu_visibility.dart';

class MenuCategory{
  final int id;
  final String title;
  final String description;
  final List<MenuVisibility> visibilities;
  final bool alcBeverages;
  final int sequence;
  final MenuAvailableTimes availableTimes;
  bool enabled;
  List<MenuCategoryItem> items;

  MenuCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.visibilities,
    required this.enabled,
    required this.alcBeverages,
    required this.sequence,
    required this.items,
    required this.availableTimes,
  });

  bool visible(int providerID) {
    final visibility = visibilities.firstWhere((element) => element.providerID == providerID);
    return visibility.visible;
  }
}