import 'menu_item.dart';
import 'menu_visibility.dart';

class MenuCategory{
  final int id;
  final String title;
  final String description;
  final List<MenuVisibility> visibilities;
  final bool alcBeverages;
  final int sequence;
  bool enabled;
  List<MenuItem> items;

  MenuCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.visibilities,
    required this.enabled,
    required this.alcBeverages,
    required this.sequence,
    required this.items,
  });
}