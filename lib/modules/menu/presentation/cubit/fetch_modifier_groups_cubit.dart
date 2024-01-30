import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../app/constants.dart';
import '../../../../app/di.dart';
import '../../../../app/session_manager.dart';
import '../../../../app/user_permission_manager.dart';
import '../../../common/business_information_provider.dart';
import '../../domain/entities/modifier/grouped_modifier_item.dart';
import '../../domain/entities/modifier/modifier_group.dart';
import '../../domain/usecase/ftech_modifier_groups.dart';

class FetchModifierGroupsCubit extends Cubit<ResponseState> {
  final FetchModifierGroups _fetchModifierGroups;

  FetchModifierGroupsCubit(this._fetchModifierGroups) : super(Empty());

  void fetchModifierGroups({
    required int brandId,
    required int branchID,
    required List<int> providers,
  }) async {
    emit(Loading());
    final branch = await getIt.get<BusinessInformationProvider>().branchByID(branchID);
    final menuV2Enabled = UserPermissionManager().isBizOwner() ? (branch?.menuVersion ?? MenuVersion.v2) == MenuVersion.v2 : SessionManager().menuV2Enabled();
    final params = FetchModifierGroupParams(
      brandID: brandId,
      providers: providers,
      branchID: branchID,
      menuV2Enabled: menuV2Enabled,
      businessID: SessionManager().businessID(),
    );
    final response = await _fetchModifierGroups(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) async {
        //final filteredData = await _filterData(data);
        emit(Success<List<ModifierGroup>>(data));
      },
    );
  }

  Future<List<ModifierGroup>> _filterData(List<ModifierGroup> data) async {
    List<ModifierGroup> tempData = data;
    _filterHiddenModifierGroups(tempData);
    await Future.forEach<ModifierGroup>(tempData, (modifierGroup) {
      _filterHiddenModifiers(modifierGroup.modifiers);
    });
    return tempData;
  }

  void _filterHiddenModifierGroups(List<ModifierGroup> data) {
    data.removeWhere((modifierGroup) {
      return modifierGroup.visibilities.any((visibility) {
        return !visibility.isVisible;
      });
    });
  }

  void _filterHiddenModifiers(List<GroupedModifierItem> data) {
    data.removeWhere((modifier) {
      return modifier.visibilities.any((visibility) {
        return !visibility.isVisible;
      });
    });
  }
}
