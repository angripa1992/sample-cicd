import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../app/extensions.dart';
import '../../../../app/session_manager.dart';
import '../../domain/entities/modifier/grouped_modifier_item.dart';
import '../../domain/entities/modifier/modifier_group.dart';
import '../../domain/usecase/ftech_modifier_groups.dart';

class FetchModifierGroupsCubit extends Cubit<ResponseState> {
  final FetchModifierGroups _fetchModifierGroups;

  FetchModifierGroupsCubit(this._fetchModifierGroups) : super(Empty());

  void fetchModifierGroups(
    int brandId,
    int? providerId,
  ) async {
    emit(Loading());
    final params = FetchModifierGroupParams(
      brandID: brandId,
      providerID: providerId,
      branchID: SessionManager().branchId(),
      businessID: SessionManager().businessID(),
    );
    final response = await _fetchModifierGroups(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) async {
        final filteredData = await _filterData(providerId, data);
        emit(Success<List<ModifierGroup>>(filteredData));
      },
    );
  }

  Future<List<ModifierGroup>> _filterData(
      int? providerId, List<ModifierGroup> data) async {
    List<ModifierGroup> tempData = data;
    if (providerId == null) return tempData;
    _filterHiddenModifierGroups(providerId, tempData);
    await Future.forEach<ModifierGroup>(tempData, (modifierGroup) {
      _filterHiddenModifiers(providerId, modifierGroup.modifiers);
    });
    return tempData;
  }

  void _filterHiddenModifierGroups(int? providerId, List<ModifierGroup> data) {
    data.removeWhere((modifierGroup) {
      return modifierGroup.visibilities.any((visibility) {
        if (providerId == ZERO) {
          return !visibility.isVisible;
        } else {
          return providerId == visibility.providerID && !visibility.isVisible;
        }
      });
    });
  }

  void _filterHiddenModifiers(int? providerId, List<GroupedModifierItem> data) {
    data.removeWhere((modifier) {
      return modifier.visibilities.any((visibility) {
        if (providerId == ZERO) {
          return !visibility.isVisible;
        } else {
          return providerId == visibility.providerID && !visibility.isVisible;
        }
      });
    });
  }
}
