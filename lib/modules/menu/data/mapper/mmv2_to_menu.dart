import 'package:collection/collection.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/menu/data/mapper/modifierv2_to_modifier.dart';
import 'package:klikit/modules/menu/data/mapper/price_mapper.dart';
import 'package:klikit/modules/menu/data/models/menu/menu_v2_data.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_item.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_visibility.dart';

import '../../domain/entities/menu/menu_available_times.dart';
import '../../domain/entities/menu/menu_branch_info.dart';
import '../../domain/entities/menu/menu_categories.dart';
import '../../domain/entities/menu/menu_data.dart';
import '../../domain/entities/menu/menu_out_of_stock.dart';
import '../../domain/entities/menu/menu_resources.dart';
import '../../domain/entities/menu/menu_sections.dart';
import '../models/v2_common_data_model.dart';

MenuData mapMMV2toMenu(MenuV2DataModel menusData) {
  final branchInfo = _v2ToMenuBranch(menusData.branchInfo);
  final menuData = MenuData(
    branchInfo: branchInfo,
    sections: menusData.sections?.map((e) => _v2ToMenuSection(e, branchInfo)).toList() ?? [],
  );
  return menuData;
}

MenuBranchInfo _v2ToMenuBranch(MenuV2BranchInfo? data) {
  return MenuBranchInfo(
    businessID: data?.businessID,
    brandID: data?.brandID,
    branchID: data?.branchID ?? ZERO,
    countryID: data?.countryID ?? ZERO,
    currencyID: data?.currencyID ?? ZERO,
    startTime: data?.startTime ?? ZERO,
    endTime: data?.endTime ?? ZERO,
    availabilityMask: data?.availabilityMask ?? ZERO,
    providerIDs: data?.providerIDs ?? EMPTY,
    languageCode: data?.languageCode ?? EMPTY,
    currencyCode: data?.currencyCode ?? EMPTY,
    currencySymbol: data?.currencySymbol ?? EMPTY,
  );
}

MenuSection _v2ToMenuSection(
  MenuV2Sections data,
  MenuBranchInfo branchInfo,
) {
  final menuAvailableTimes = _v2ToMenuAvailableTimes(data.availableTimes!);
  return MenuSection(
    branchInfo: branchInfo,
    menuVersion: MenuVersion.v2,
    id: data.id.orZero(),
    title: data.title?.en ?? EMPTY,
    description: data.description?.en ?? EMPTY,
    enabled: data.enabled.orFalse(),
    sequence: data.sequence.orZero(),
    visibilities: data.visibilities?.map((data) => _v2ToMenuVisibility(data)).toList() ?? [],
    categories: data.categories
            ?.map((category) => _v2ToMenuCategory(
                  data.id.orZero(),
                  data.title?.en ?? EMPTY,
                  category,
                  menuAvailableTimes,
                  branchInfo,
                ))
            .toList() ??
        [],
    availableTimes: menuAvailableTimes,
  );
}

MenuCategory _v2ToMenuCategory(
  int sectionID,
  String sectionName,
  MenuV2Category data,
  MenuAvailableTimes availableTimes,
  MenuBranchInfo branchInfo,
) {
  return MenuCategory(
    branchInfo: branchInfo,
    menuVersion: MenuVersion.v2,
    id: data.id.orZero(),
    title: data.title?.en ?? EMPTY,
    description: data.description?.en ?? EMPTY,
    visibilities: data.visibilities?.map((data) => _v2ToMenuVisibility(data)).toList() ?? [],
    enabled: data.enabled.orFalse(),
    sequence: data.sequence.orZero(),
    alcBeverages: data.alcBeverages.orFalse(),
    items: data.items
            ?.map((item) => _v2ToMenuCategoryItem(
                  sectionID,
                  sectionName,
                  data.id.orZero(),
                  data.title?.en ?? EMPTY,
                  item,
                  availableTimes,
                  branchInfo,
                ))
            .toList() ??
        [],
    availableTimes: availableTimes,
  );
}

MenuCategoryItem _v2ToMenuCategoryItem(
  int sectionID,
  String sectionName,
  int categoryID,
  String categoryName,
  MenuV2CategoryItem data,
  MenuAvailableTimes availableTimes,
  MenuBranchInfo branchInfo,
) {
  return MenuCategoryItem(
    branchInfo: branchInfo,
    menuVersion: MenuVersion.v2,
    id: data.id.orZero(),
    sectionID: sectionID,
    sectionName: sectionName,
    categoryID: categoryID,
    categoryName: categoryName,
    defaultItemId: data.id.orZero(),
    title: data.title?.en ?? EMPTY,
    description: data.description?.en ?? EMPTY,
    visibilities: data.visibilities?.map((data) => _v2ToMenuVisibility(data)).toList() ?? [],
    enabled: data.enabled.orFalse(),
    sequence: data.sequence.orZero(),
    prices: data.prices?.map((e) => v2PriceToItemPrice(e, branchInfo, data.id.orZero())).toList() ?? [],
    vat: data.vat.orZero(),
    skuID: data.skuID.orEmpty(),
    image: _defaultImage(data.resources),
    outOfStock: _v2ToMenuOutOfStock(data.oos!),
    resources: data.resources?.map((e) => _v2ToMenuResource(e)).toList() ?? [],
    availableTimes: availableTimes,
    groups: mapModifierV2ToModifier(data.groups, branchInfo),
  );
}

MenuVisibility _v2ToMenuVisibility(V2VisibilityModel data) {
  return MenuVisibility(
    providerID: data.providerID.orZero(),
    visible: data.status.orFalse(),
  );
}

MenuAvailableTimes _v2ToMenuAvailableTimes(
  MenuV2AvailableTimesModel data,
) {
  return MenuAvailableTimes(
    monday: _v1MenuDayToMenuDay(data.monday ?? MenuV2DayInfoModel()),
    tuesday: _v1MenuDayToMenuDay(data.tuesday ?? MenuV2DayInfoModel()),
    wednesday: _v1MenuDayToMenuDay(data.wednesday ?? MenuV2DayInfoModel()),
    thursday: _v1MenuDayToMenuDay(data.thursday ?? MenuV2DayInfoModel()),
    friday: _v1MenuDayToMenuDay(data.friday ?? MenuV2DayInfoModel()),
    saturday: _v1MenuDayToMenuDay(data.saturday ?? MenuV2DayInfoModel()),
    sunday: _v1MenuDayToMenuDay(data.sunday ?? MenuV2DayInfoModel()),
  );
}

MenuDay _v1MenuDayToMenuDay(MenuV2DayInfoModel data) {
  return MenuDay(
    disabled: data.disabled.orFalse(),
    slots: data.slots?.map((e) => _v1SlotsToMenuSlots(e)).toList() ?? [],
  );
}

MenuSlots _v1SlotsToMenuSlots(MenuV2SlotsModel data) {
  return MenuSlots(
    startTime: data.startTime.orZero(),
    endTime: data.endTime.orZero(),
  );
}

MenuResource _v2ToMenuResource(V2ResourcesModel data) {
  return MenuResource(
    providerID: data.providerID.orZero(),
    type: data.type.orEmpty(),
    paths: data.paths?.map((e) => _v2ToMenuResourcePath(e)).toList() ?? [],
  );
}

MenuResourcePaths _v2ToMenuResourcePath(V2ResourcePathsModel data) {
  return MenuResourcePaths(
    path: data.path.orEmpty(),
    sequence: data.sequence.orZero(),
    byDefault: data.byDefault.orFalse(),
  );
}

MenuOutOfStock _v2ToMenuOutOfStock(V2OosModel data) {
  final snooze = MenuSnooze(
    startTime: data.snooze?.startTime ?? EMPTY,
    endTime: data.snooze?.endTime ?? EMPTY,
    duration: data.snooze?.duration ?? ZERO,
    unit: data.snooze?.unit ?? EMPTY,
  );
  return MenuOutOfStock(
    available: data.available.orFalse(),
    menuSnooze: snooze,
  );
}

String _defaultImage(List<V2ResourcesModel>? data) {
  final resource = data?.firstWhereOrNull((element) => element.providerID == ProviderID.KLIKIT);
  final path = resource?.paths?.firstWhereOrNull((element) => element.byDefault!)?.path;
  return path ?? EMPTY;
}
