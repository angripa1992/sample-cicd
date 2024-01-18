import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/add_order/utils/available_time_provider.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/modules/menu/domain/usecase/fetch_menus.dart';

import 'package:klikit/modules/menu/domain/entities/menu/menu_categories.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_item.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_sections.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';

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
      ),
    );
    response.fold(
      (failure) => emit(Failed(failure)),
      (successResponse) {
        final categories = _filterMenuCategory(successResponse.sections);
        categories.sort((a, b) => a.sequence.compareTo(b.sequence));
        emit(Success<List<MenuCategory>>(categories));
      },
    );
  }

  void _filterSection(List<MenuSection> sections){
    final availableSections = <MenuSection>[];
    final unavailableSections = <MenuSection>[];
    final sortedSections = <MenuSection>[];
    for (var section in sections) {
      final currentDaya = MenuAvailableTimeProvider().findCurrentDay(section.availableTimes);
      final haveAvailableTime = MenuAvailableTimeProvider().haveAvailableTime(currentDaya) != null;
      if(haveAvailableTime){
        availableSections.add(section);
      }else{
        unavailableSections.add(section);
      }
    }
    sortedSections.addAll(availableSections);
    sortedSections.addAll(unavailableSections);
    sortedSections.sort((a,b) => a.sequence.compareTo(b.sequence));
    final filteredCategories = <MenuCategory>[];
    for (var section in sortedSections) {
      if(section.enabled && section.visible(ProviderID.KLIKIT)){
        final tempSubSections =  <MenuCategory>[];
        tempSubSections.addAll(section.categories);
        tempSubSections.sort((a,b) => a.sequence.compareTo(b.sequence));
        for (var element in tempSubSections) {

        }
      }
    }
  }

  List<MenuCategory> _filterMenuCategory(List<MenuSection> sections) {
    final List<MenuCategory> categories = [];
    for (var section in sections) {
      if (section.enabled && section.visible(ProviderID.KLIKIT)) {
        for (var category in section.categories) {
          if (category.enabled && category.visible(ProviderID.KLIKIT) && category.items.isNotEmpty) {
            final categoryItems = <MenuCategoryItem>[];
            for (var item in category.items) {
              if (item.visible(ProviderID.KLIKIT)) {
                categoryItems.add(item);
              }
            }
            category.items = categoryItems;
            categories.add(category);
          }
        }
      }
    }
    return categories;
  }
}
