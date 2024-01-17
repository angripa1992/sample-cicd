import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/common/business_information_provider.dart';

import '../../../../app/session_manager.dart';
import '../../domain/entities/menu/menu_categories.dart';
import '../../domain/entities/menu/menu_data.dart';
import '../../domain/entities/menu/menu_item.dart';
import '../../domain/entities/menu/menu_sections.dart';
import '../../domain/usecase/fetch_menus.dart';

class MenusCubit extends Cubit<ResponseState> {
  final FetchMenus _fetchMenus;

  MenusCubit(this._fetchMenus) : super(Empty());

  void fetchMenu({
    required int branchID,
    required int brandId,
    required List<int> providers,
  }) async {
    emit(Loading());
    final branch = await getIt.get<BusinessInformationProvider>().branchByID(branchID);
    final menuV2Enabled = UserPermissionManager().isBizOwner() ? (branch?.menuVersion ?? MenuVersion.v2) == MenuVersion.v2 : SessionManager().menuV2Enabled();
    final response = await _fetchMenus(
      FetchMenuParams(
        menuV2Enabled: menuV2Enabled,
        branchId: branchID,
        brandId: brandId,
        providers: providers,
        businessId: SessionManager().businessID(),
      ),
    );
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) async {
        final filteredData = await _filterHiddenMenu(data);
        emit(Success<MenuData>(filteredData));
      },
    );
  }

  Future<MenuData> _filterHiddenMenu(MenuData data) async {
    MenuData tempData = data;
    _filterHiddenSections(tempData.sections);
    await Future.forEach<MenuSection>(tempData.sections, (sections) async {
      _filterHiddenSubSections(sections.categories);
      await Future.forEach<MenuCategory>(sections.categories, (category) async {
        _filterHiddenSubSectionsItems(category.items);
      });
    });
    return tempData;
  }

  void _filterHiddenSections(List<MenuSection> data) {
    data.removeWhere((section) {
      return section.visibilities.any((visibility) => !visibility.visible);
    });
  }

  void _filterHiddenSubSections(List<MenuCategory> data) {
    data.removeWhere((category) {
      return category.visibilities.any((visibility) => !visibility.visible);
    });
  }

  void _filterHiddenSubSectionsItems(List<MenuCategoryItem> data) {
    data.removeWhere((categoryItem) {
      return categoryItem.visibilities.any((visibility) => !visibility.visible);
    });
  }
}
