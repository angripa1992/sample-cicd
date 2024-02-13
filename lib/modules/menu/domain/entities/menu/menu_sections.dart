import 'package:collection/collection.dart';

import 'menu_available_times.dart';
import 'menu_branch_info.dart';
import 'menu_categories.dart';
import 'menu_visibility.dart';

class MenuSection {
  final int menuVersion;
  final int id;
  final String title;
  final String description;
  final List<MenuVisibility> visibilities;
  final int sequence;
  final MenuAvailableTimes availableTimes;
  final MenuBranchInfo branchInfo;
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
    required this.branchInfo,
  });

  MenuSection copyWith(
      {int? menuVersion,
      int? id,
      String? title,
      String? description,
      List<MenuVisibility>? visibilities,
      int? sequence,
      MenuAvailableTimes? availableTimes,
      MenuBranchInfo? branchInfo,
      bool? enabled,
      List<MenuCategory>? categories}) {
    return MenuSection(
      branchInfo: branchInfo ?? this.branchInfo,
      menuVersion: menuVersion ?? this.menuVersion,
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      enabled: enabled ?? this.enabled,
      sequence: sequence ?? this.sequence,
      visibilities: visibilities ?? this.visibilities,
      categories: categories ?? this.categories,
      availableTimes: availableTimes ?? this.availableTimes,
    );
  }

  bool visible(int providerID) {
    final visibility = visibilities.firstWhereOrNull((element) => element.providerID == providerID);
    if (visibility == null) {
      return true;
    }
    return visibility.visible;
  }
}
