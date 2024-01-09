import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../../../app/session_manager.dart';
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
    final params = FetchModifierGroupParams(
      brandID: brandId,
      providers: providers,
      branchID: branchID,
      businessID: SessionManager().businessID(),
    );
    final response = await _fetchModifierGroups(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) async {
        final filteredData = await _filterData(data);
        emit(Success<List<ModifierGroup>>(filteredData));
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
