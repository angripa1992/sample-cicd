import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../app/session_manager.dart';
import '../../domain/entities/menu/menu_categories.dart';
import '../../domain/entities/menu/menu_data.dart';
import '../../domain/entities/menu/menu_item.dart';
import '../../domain/entities/menu/menu_sections.dart';
import '../../domain/entities/menu/menu_visibility.dart';
import '../../domain/usecase/fetch_menus.dart';

class MenusCubit extends Cubit<ResponseState> {
  final FetchMenus _fetchMenus;

  MenusCubit(this._fetchMenus) : super(Empty());

  void fetchMenu(int brandId, int? providerId) async {
    emit(Loading());
    final response = await _fetchMenus(
      FetchMenuParams(
        menuV2Enabled: SessionManager().isMenuV2(),
        branchId: SessionManager().branchId(),
        brandId: brandId,
        providerID: providerId == ZERO ? null : providerId,
        businessId: SessionManager().user().businessId,
      ),
    );
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) async {
        final filteredData = await _filterHiddenMenu(providerId, data);
        emit(Success<MenuData>(filteredData));
      },
    );
  }

  Future<MenuData> _filterHiddenMenu(int? providerId, MenuData data) async {
    MenuData tempData = data;
    if (providerId == null) return tempData;
    _filterHiddenSections(providerId, tempData.sections);
    await Future.forEach<MenuSection>(tempData.sections, (sections) async {
      _filterHiddenSubSections(providerId, sections.categories);
      await Future.forEach<MenuCategory>(sections.categories, (category) async {
        _filterHiddenSubSectionsItems(providerId, category.items);
      });
    });
    return tempData;
  }

  void _filterHiddenSections(int? providerId, List<MenuSection> data) {
    data.removeWhere((section) {
      return section.visibilities
          .any((visibility) => _willRemove(visibility, providerId));
    });
  }

  void _filterHiddenSubSections(int? providerId, List<MenuCategory> data) {
    data.removeWhere((category) {
      return category.visibilities
          .any((visibility) => _willRemove(visibility, providerId));
    });
  }

  void _filterHiddenSubSectionsItems(
      int? providerId, List<MenuCategoryItem> data) {
    data.removeWhere((categoryItem) {
      return categoryItem.visibilities
          .any((visibility) => _willRemove(visibility, providerId));
    });
  }

  bool _willRemove(MenuVisibility menuVisibility, int? providerId) {
    if (providerId == ZERO) {
      return !menuVisibility.visible;
    } else {
      return providerId == menuVisibility.providerID && !menuVisibility.visible;
    }
  }
}
