import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/add_order/utils/available_time_provider.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_categories.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_item.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_sections.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';
import 'package:klikit/modules/menu/domain/usecase/fetch_menus.dart';

class FetchAddOrderMenuItemsCubit extends Cubit<ResponseState> {
  final MenuRepository _repository;

  FetchAddOrderMenuItemsCubit(this._repository) : super(Empty());

  void fetchSubsection(Brand brand) async {
    emit(Loading());
    final response = await _repository.fetchMenu(
      FetchMenuParams(
        menuV2Enabled: SessionManager().menuV2EnabledForKlikitOrder(),
        branchId: SessionManager().branchId(),
        brandId: brand.id,
        businessId: SessionManager().businessID(),
        providers: [],
        isMgt: false,
      ),
    );
    response.fold(
      (failure) => emit(Failed(failure)),
      (successResponse) {
        final categories = _sortMenu(successResponse.sections);
        emit(Success<List<MenuCategory>>(categories));
      },
    );
  }

  List<MenuCategory> _sortMenu(List<MenuSection> sections) {
    ///sort sections

    final availableSections = <MenuSection>[];
    final unavailableSections = <MenuSection>[];
    final sortedSections = <MenuSection>[];
    for (var section in sections) {
      final currentDaya = MenuAvailableTimeProvider().findCurrentDay(section.availableTimes);
      final haveAvailableTime = MenuAvailableTimeProvider().haveAvailableTime(currentDaya) != null;
      if (haveAvailableTime) {
        availableSections.add(section);
      } else {
        unavailableSections.add(section);
      }
    }
    availableSections.sort((a, b) => a.sequence.compareTo(b.sequence));
    unavailableSections.sort((a, b) => a.sequence.compareTo(b.sequence));
    sortedSections.addAll(availableSections);
    sortedSections.addAll(unavailableSections);

    /// sort categories

    final filteredCategories = <MenuCategory>[];
    for (var section in sortedSections) {
      if (section.enabled && section.visible(ProviderID.KLIKIT)) {
        final tempCategories = <MenuCategory>[];
        tempCategories.addAll(section.categories);
        tempCategories.sort((a, b) => a.sequence.compareTo(b.sequence));
        for (var category in tempCategories) {
          if (category.enabled && category.visible(ProviderID.KLIKIT)) {
            filteredCategories.add(category);
          }
        }
      }
    }

    ///sort items

    for (var category in filteredCategories) {
      final tempAvailableItems = <MenuCategoryItem>[];
      final tempOosItems = <MenuCategoryItem>[];
      for (var item in category.items) {
        if (item.visible(ProviderID.KLIKIT)) {
          if (item.outOfStock.available) {
            tempAvailableItems.add(item);
          } else {
            tempOosItems.add(item);
          }
        }
      }
      tempAvailableItems.sort((a, b) => a.sequence.compareTo(b.sequence));
      tempOosItems.sort((a, b) => a.sequence.compareTo(b.sequence));
      category.items.clear();
      category.items.addAll(tempAvailableItems);
      category.items.addAll(tempOosItems);
    }

    return filteredCategories;
  }
}
