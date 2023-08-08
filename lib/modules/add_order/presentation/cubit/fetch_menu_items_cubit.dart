import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/usecase/fetch_menus.dart';

import '../../../../core/provider/date_time_provider.dart';
import '../../../menu/domain/entities/brand.dart';
import '../../../menu/domain/entities/menu/menu_categories.dart';
import '../../../menu/domain/entities/menu/menu_item.dart';
import '../../../menu/domain/entities/menu/menu_sections.dart';
import '../../../menu/domain/repository/menu_repository.dart';

class FetchAddOrderMenuItemsCubit extends Cubit<ResponseState> {
  final MenuRepository _repository;

  FetchAddOrderMenuItemsCubit(this._repository) : super(Empty());

  void fetchSubsection(MenuBrand brand) async {
    emit(Loading());
    final response = await _repository.fetchMenuV1(
      FetchMenuParams(
        branchId: SessionManager().currentUserBranchId(),
        brandId: brand.id,
        businessId: SessionManager().currentUser().businessId,
        providerID: null,
      ),
    );
    response.fold(
      (failure) => emit(Failed(failure)),
      (successResponse) {
        final categories = _filterMenuCategory(successResponse.sections);
        emit(Success<List<MenuCategory>>(categories));
      },
    );
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
