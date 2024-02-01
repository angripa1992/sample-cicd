import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/modules/menu/data/mapper/price_mapper.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_available_times.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_branch_info.dart';

import '../../domain/entities/menu/menu_categories.dart';
import '../../domain/entities/menu/menu_data.dart';
import '../../domain/entities/menu/menu_item.dart';
import '../../domain/entities/menu/menu_out_of_stock.dart';
import '../../domain/entities/menu/menu_sections.dart';
import '../../domain/entities/menu/menu_visibility.dart';
import '../models/menu/menu_v1_data.dart';

MenuData mapMMV1toMenu(MenuV1MenusDataModel menusData) {
  final branchInfo = _menuV1dataToMenuBranchInfo(menusData.branchInfo!);
  final menuData = MenuData(
    branchInfo: branchInfo,
    sections: menusData.sections?.map((e) => _menuV1SectionsToMenuSections(e, branchInfo)).toList() ?? [],
  );
  return menuData;
}

MenuBranchInfo _menuV1dataToMenuBranchInfo(MenuV1BranchInfo data) {
  return MenuBranchInfo(
    businessID: SessionManager().businessID(),
    brandID: data.branchId,
    branchID: data.branchId.orZero(),
    countryID: data.countryId.orZero(),
    currencyID: data.currencyId.orZero(),
    startTime: data.startTime.orZero(),
    endTime: data.endTime.orZero(),
    availabilityMask: data.availabilityMask.orZero(),
    providerIDs: data.providerIds.orEmpty(),
    languageCode: data.languageCode.orEmpty(),
    currencyCode: EMPTY,
    currencySymbol: EMPTY,
  );
}

MenuSection _menuV1SectionsToMenuSections(MenuV1SectionsModel data, MenuBranchInfo branchInfo) {
  final menuAvailableTimes = _menuV1AvailableTimesModelToMenuAvailableTimes(data.availableTimes!);
  return MenuSection(
    branchInfo: branchInfo,
    menuVersion: MenuVersion.v1,
    id: data.id.orZero(),
    title: data.title.orEmpty(),
    description: EMPTY,
    enabled: data.enabled.orFalse(),
    sequence: data.sequence.orZero(),
    visibilities: data.statuses?.map((e) => _menuV1StatusToMenuVisibility(e)).toList() ?? [],
    categories: data.subSections
            ?.map((category) => _menuV1SubSectionToMenuCategory(
                  data.id.orZero(),
                  data.title.orEmpty(),
                  category,
                  menuAvailableTimes,
                  branchInfo,
                ))
            .toList() ??
        [],
    availableTimes: menuAvailableTimes,
  );
}

MenuCategory _menuV1SubSectionToMenuCategory(
  int sectionID,
  String sectionName,
  MenuV1SubSectionsModel data,
  MenuAvailableTimes availableTimes,
  MenuBranchInfo branchInfo,
) {
  return MenuCategory(
    branchInfo: branchInfo,
    menuVersion: MenuVersion.v1,
    id: data.id.orZero(),
    title: data.title.orEmpty(),
    description: data.description.orEmpty(),
    visibilities: data.statuses?.map((e) => _menuV1StatusToMenuVisibility(e)).toList() ?? [],
    enabled: data.enabled.orFalse(),
    alcBeverages: data.alcBeverages.orFalse(),
    sequence: data.sequence.orZero(),
    items: data.items
            ?.map((item) => _menuV1ItemToMenuItem(
                  sectionID,
                  sectionName,
                  data.id.orZero(),
                  data.title.orEmpty(),
                  item,
                  availableTimes,
                  branchInfo,
                ))
            .toList() ??
        [],
    availableTimes: availableTimes,
  );
}

MenuCategoryItem _menuV1ItemToMenuItem(
  int sectionID,
  String sectionName,
  int categoryID,
  String categoryName,
  MenuV1ItemsModel data,
  MenuAvailableTimes availableTimes,
  MenuBranchInfo branchInfo,
) {
  return MenuCategoryItem(
    branchInfo: branchInfo,
    menuVersion: MenuVersion.v1,
    id: data.id.orZero(),
    sectionID: sectionID,
    sectionName: sectionName,
    categoryID: categoryID,
    categoryName: categoryName,
    defaultItemId: data.defaultItemId.orZero(),
    title: data.title.orEmpty(),
    prices: data.prices?.map((e) => v1PriceToItemPrice(e)).toList() ?? [],
    vat: data.vat.orZero(),
    skuID: data.skuID.orEmpty(),
    description: data.description.orEmpty(),
    image: data.image.orEmpty(),
    enabled: data.enabled.orFalse(),
    visibilities: data.statuses?.map((e) => _menuV1StatusToMenuVisibility(e)).toList() ?? [],
    sequence: data.sequence.orZero(),
    outOfStock: _menuV1StockModelToMenuOutOfStock(data.stock!),
    availableTimes: availableTimes,
    haveModifier: data.haveModifier ?? false,
  );
}

MenuVisibility _menuV1StatusToMenuVisibility(MenuV1StatusesModel status) {
  return MenuVisibility(
    providerID: status.providerId.orZero(),
    visible: !status.enabled.orFalse(),
  );
}

MenuOutOfStock _menuV1StockModelToMenuOutOfStock(MenuV1StockModel data) {
  final snooze = MenuSnooze(
    startTime: EMPTY,
    endTime: data.snooze?.endTime ?? EMPTY,
    duration: data.snooze?.duration ?? ZERO,
    unit: EMPTY,
  );
  return MenuOutOfStock(
    available: data.available.orFalse(),
    menuSnooze: snooze,
  );
}

MenuAvailableTimes _menuV1AvailableTimesModelToMenuAvailableTimes(MenuV1AvailableTimesModel data) {
  return MenuAvailableTimes(
    monday: _v1MenuDayToMenuDay(data.monday ?? MenuV1DayInfoModel()),
    tuesday: _v1MenuDayToMenuDay(data.tuesday ?? MenuV1DayInfoModel()),
    wednesday: _v1MenuDayToMenuDay(data.wednesday ?? MenuV1DayInfoModel()),
    thursday: _v1MenuDayToMenuDay(data.thursday ?? MenuV1DayInfoModel()),
    friday: _v1MenuDayToMenuDay(data.friday ?? MenuV1DayInfoModel()),
    saturday: _v1MenuDayToMenuDay(data.saturday ?? MenuV1DayInfoModel()),
    sunday: _v1MenuDayToMenuDay(data.sunday ?? MenuV1DayInfoModel()),
  );
}

MenuDay _v1MenuDayToMenuDay(MenuV1DayInfoModel data) {
  return MenuDay(
    disabled: data.disabled.orFalse(),
    slots: data.slots?.map((e) => _v1SlotsToMenuSlots(e)).toList() ?? [],
  );
}

MenuSlots _v1SlotsToMenuSlots(MenuV1SlotsModel data) {
  return MenuSlots(
    startTime: data.startTime.orZero(),
    endTime: data.endTime.orZero(),
  );
}
