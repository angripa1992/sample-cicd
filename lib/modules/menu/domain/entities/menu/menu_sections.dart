import 'menu_available_times.dart';
import 'menu_categories.dart';
import 'menu_visibility.dart';

import 'package:collection/collection.dart';

class MenuSection{
  final int menuVersion;
  final int id;
  final String title;
  final String description;
  final List<MenuVisibility> visibilities;
  final int sequence;
  final MenuAvailableTimes availableTimes;
  bool enabled;
  List<MenuCategory> categories;

  MenuSection({
    required this.menuVersion,
    required this.id,
    required this.title,
    required this.description,
    required this.enabled,
    required this.sequence,
    required this.visibilities,
    required this.categories,
    required this.availableTimes,
  });

  bool visible(int providerID) {
    final visibility = visibilities.firstWhereOrNull((element) => element.providerID == providerID);
    if(visibility == null){
      return true;
    }
    return visibility.visible;
  }
}