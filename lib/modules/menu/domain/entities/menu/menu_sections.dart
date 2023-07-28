import 'menu_categories.dart';
import 'menu_visibility.dart';

class MenuSections{
  final int id;
  final String title;
  final String description;
  final List<MenuVisibility> visibilities;
  final int sequence;
  bool enabled;
  List<MenuCategory> categories;

  MenuSections({
    required this.id,
    required this.title,
    required this.description,
    required this.enabled,
    required this.sequence,
    required this.visibilities,
    required this.categories,
  });
}