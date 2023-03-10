import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/entities/menues.dart';

import '../../../../app/session_manager.dart';
import '../../domain/entities/items.dart';
import '../../domain/entities/sections.dart';
import '../../domain/entities/sub_section.dart';
import '../../domain/usecase/fetch_menus.dart';

class MenusCubit extends Cubit<ResponseState> {
  final FetchMenus _fetchMenus;

  MenusCubit(this._fetchMenus) : super(Empty());

  void fetchMenu(int brandId, int? providerId) async {
    emit(Loading());
    final response = await _fetchMenus(
      FetchMenuParams(
        branchId: SessionManager().currentUserBranchId(),
        brandId: brandId,
        providerID: providerId != null
            ? (providerId == ZERO ? 'undefine' : providerId.toString())
            : 'undefine',
      ),
    );
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) async {
        final filteredData = await _filterHiddenMenu(providerId, data);
        emit(Success<MenusData>(filteredData));
      },
    );
  }

  Future<MenusData> _filterHiddenMenu(int? providerId, MenusData data) async {
    MenusData tempData = data;
    if (providerId == null) return tempData;
    _filterHiddenSections(providerId, tempData.sections);
    await Future.forEach<Sections>(tempData.sections, (sections) async {
      _filterHiddenSubSections(providerId, sections.subSections);
      await Future.forEach<SubSections>(sections.subSections,
          (subSections) async {
        _filterHiddenSubSectionsItems(providerId, subSections.items);
      });
    });
    return tempData;
  }

  void _filterHiddenSections(int? providerId, List<Sections> data) {
    data.removeWhere((section) {
      return section.statuses.any((status) {
        if (providerId == ZERO) {
          return status.hidden;
        } else {
          return providerId == status.providerId && status.hidden;
        }
      });
    });
  }

  void _filterHiddenSubSections(int? providerId, List<SubSections> data) {
    data.removeWhere((section) {
      return section.statuses.any((status) {
        if (providerId == ZERO) {
          return status.hidden;
        } else {
          return providerId == status.providerId && status.hidden;
        }
      });
    });
  }

  void _filterHiddenSubSectionsItems(int? providerId, List<MenuItems> data) {
    data.removeWhere((section) {
      return section.statuses.any((status) {
        if (providerId == ZERO) {
          return status.hidden;
        } else {
          return providerId == status.providerId && status.hidden;
        }
      });
    });
  }
}
