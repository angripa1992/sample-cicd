import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_available_times.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_branch_info.dart';

import '../../domain/entities/menu/menu_categories.dart';
import '../../domain/entities/menu/menu_item.dart';
import '../../domain/entities/menu/menu_out_of_stock.dart';
import '../../domain/entities/menu/menu_sections.dart';
import '../../domain/entities/menu/menu_visibility.dart';
import '../models/menu_v1_data.dart';

void mapMMV1toMenu(
  List<MenuV1SectionsModel>? sections,
  MenuV1BranchInfo? v1branchInfo,
) {
  final branchInfo = _menuV1dataToMenuBranchInfo(v1branchInfo!);
}

MenuBranchInfo _menuV1dataToMenuBranchInfo(MenuV1BranchInfo data) {
  return MenuBranchInfo(
    businessID: SessionManager().currentUser().businessId,
    brandID: data.branchId,
    branchID: data.branchId.orZero(),
    countryID: data.countryId.orZero(),
    currencyID: data.currencyId.orZero(),
    startTime: data.startTime.orZero(),
    endTime: data.endTime.orZero(),
    availabilityMask: data.availabilityMask.orZero(),
    providerIDs: data.providerIds.orEmpty(),
    languageCode: data.languageCode.orEmpty(),
    currencyCode: null,
  );
}

MenuSections _menuV1SectionsToMenuSections(MenuV1SectionsModel data) {
  final menuAvailableTimes = _menuV1AvailableTimesModelToMenuAvailableTimes(data.availableTimes!);
  return MenuSections(
    id: data.id.orZero(),
    title: data.title.orEmpty(),
    description: EMPTY,
    enabled: data.enabled.orFalse(),
    sequence: data.sequence.orZero(),
    visibilities:
        data.statuses?.map((e) => _menuV1StatusToMenuVisibility(e)).toList() ??
            [],
    categories: data.subSections
            ?.map(
                (e) => _menuV1SubSectionToMenuCategory(e,menuAvailableTimes))
            .toList() ??
        [],
    availableTimes: menuAvailableTimes,
  );
}

MenuCategory _menuV1SubSectionToMenuCategory(
  MenuV1SubSectionsModel data,
  MenuAvailableTimes availableTimes,
) {
  return MenuCategory(
    id: data.id.orZero(),
    title: data.title.orEmpty(),
    description: data.description.orEmpty(),
    visibilities:
        data.statuses?.map((e) => _menuV1StatusToMenuVisibility(e)).toList() ??
            [],
    enabled: data.enabled.orFalse(),
    alcBeverages: data.alcBeverages.orFalse(),
    sequence: data.sequence.orZero(),
    items: data.items
            ?.map((e) => _menuV1ItemToMenuItem(e, availableTimes))
            .toList() ??
        [],
    availableTimes: availableTimes,
  );
}

MenuItem _menuV1ItemToMenuItem(
  MenuV1ItemsModel data,
  MenuAvailableTimes availableTimes,
) {
  return MenuItem(
    id: data.id.orZero(),
    title: data.title.orEmpty(),
    prices: [],
    vat: data.vat.orZero(),
    description: data.description.orEmpty(),
    image: data.image.orEmpty(),
    enabled: data.enabled.orFalse(),
    visibilities:
        data.statuses?.map((e) => _menuV1StatusToMenuVisibility(e)).toList() ??
            [],
    sequence: data.sequence.orZero(),
    outOfStock: _menuV1StockModelToMenuOutOfStock(data.stock!),
    availableTimes: availableTimes,
  );
}

MenuVisibility _menuV1StatusToMenuVisibility(MenuV1StatusesModel status) {
  return MenuVisibility(
    status.providerId.orZero(),
    status.enabled.orFalse(),
  );
}

MenuOutOfStock _menuV1StockModelToMenuOutOfStock(MenuV1StockModel data) {
  final snooze = MenuSnooze(
    endTime: data.snooze?.endTime ?? EMPTY,
    duration: data.snooze?.duration ?? ZERO,
  );
  return MenuOutOfStock(
    available: data.available.orFalse(),
    menuSnooze: snooze,
  );
}

MenuAvailableTimes _menuV1AvailableTimesModelToMenuAvailableTimes(
  MenuV1AvailableTimesModel data,
) {
  return MenuAvailableTimes(
    monday: _v1MenuDayToMenuDay(data.monday!),
    tuesday: _v1MenuDayToMenuDay(data.tuesday!),
    wednesday: _v1MenuDayToMenuDay(data.wednesday!),
    thursday: _v1MenuDayToMenuDay(data.thursday!),
    friday: _v1MenuDayToMenuDay(data.friday!),
    saturday: _v1MenuDayToMenuDay(data.saturday!),
    sunday: _v1MenuDayToMenuDay(data.sunday!),
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
