import 'menu_branch_info.dart';
import 'menu_item.dart';
import 'menu_available_times.dart';
import 'menu_visibility.dart';

import 'package:collection/collection.dart';

class MenuCategory{
  final int menuVersion;
  final int id;
  final String title;
  final String description;
  final List<MenuVisibility> visibilities;
  final bool alcBeverages;
  final int sequence;
  final MenuAvailableTimes availableTimes;
  final MenuBranchInfo branchInfo;
  bool enabled;
  List<MenuCategoryItem> items;

  MenuCategory({
    required this.menuVersion,
    required this.id,
    required this.title,
    required this.description,
    required this.visibilities,
    required this.enabled,
    required this.alcBeverages,
    required this.sequence,
    required this.items,
    required this.availableTimes,
    required this.branchInfo,
  });

  bool visible(int providerID) {
    final visibility = visibilities.firstWhereOrNull((element) => element.providerID == providerID);
    if(visibility == null){
      return true;
    }
    return visibility.visible;
  }
}