import 'package:collection/collection.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/modules/menu/domain/entities/modifier/modifier_group.dart';

import '../item_price.dart';
import 'menu_available_times.dart';
import 'menu_branch_info.dart';
import 'menu_out_of_stock.dart';
import 'menu_resources.dart';
import 'menu_visibility.dart';

class MenuCategoryItem {
  final int menuVersion;
  final int id;
  final int sectionID;
  final String sectionName;
  final int categoryID;
  final String categoryName;
  final int defaultItemId;
  final String title;
  final String description;
  final List<ItemPrice> prices;
  final int vat;
  final String skuID;
  final String image;
  final int sequence;
  final List<MenuVisibility> visibilities;
  final MenuAvailableTimes availableTimes;
  final List<MenuResource>? resources;
  final List<ModifierGroup> groups;
  final MenuBranchInfo branchInfo;
  bool enabled;
  MenuOutOfStock outOfStock;

  MenuCategoryItem({
    required this.menuVersion,
    required this.id,
    required this.sectionID,
    required this.sectionName,
    required this.categoryID,
    required this.categoryName,
    required this.defaultItemId,
    required this.title,
    required this.prices,
    required this.vat,
    required this.skuID,
    required this.description,
    required this.image,
    required this.enabled,
    required this.visibilities,
    required this.sequence,
    required this.outOfStock,
    required this.availableTimes,
    required this.branchInfo,
    required this.groups,
    this.resources,
  });

  ItemPrice klikitPrice() => prices.firstWhere((element) => element.providerId == ProviderID.KLIKIT);

  bool visible(int providerID) {
    final visibility = visibilities.firstWhereOrNull((element) => element.providerID == providerID);
    if (visibility == null) {
      return true;
    }
    return visibility.visible;
  }

  bool haveModifier() => groups.isNotEmpty;
}
