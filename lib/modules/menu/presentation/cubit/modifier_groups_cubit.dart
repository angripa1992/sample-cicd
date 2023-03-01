import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/entities/modifiers.dart';
import 'package:klikit/modules/menu/domain/entities/modifiers_group.dart';

import '../../../../app/extensions.dart';
import '../../../../app/session_manager.dart';
import '../../domain/usecase/ftech_modifier_groups.dart';

class ModifierGroupsCubit extends Cubit<ResponseState> {
  final FetchModifierGroups _fetchModifierGroups;

  ModifierGroupsCubit(this._fetchModifierGroups) : super(Empty());

  void fetchModifierGroups(int brandId, int? providerId) async {
    emit(Loading());
    final params = {
      'brand_id': brandId,
      'branch_id': SessionManager().currentUserBranchId(),
    };
    if (providerId != null && providerId != ZERO) {
      params['provider_id'] = providerId;
    }
    final response = await _fetchModifierGroups(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) async {
        final filteredData = await _filterData(providerId, data);
        emit(Success<List<ModifiersGroup>>(filteredData));
      },
    );
  }

  Future<List<ModifiersGroup>> _filterData(
      int? providerId, List<ModifiersGroup> data) async {
    List<ModifiersGroup> tempData = data;
    if (providerId == null) return tempData;
    _filterHiddenModifierGroups(providerId, tempData);
    await Future.forEach<ModifiersGroup>(tempData, (modifierGroup) {
      _filterHiddenModifiers(providerId, modifierGroup.modifiers);
    });
    return tempData;
  }

  void _filterHiddenModifierGroups(int? providerId, List<ModifiersGroup> data) {
    data.removeWhere((modifierGroup) {
      return modifierGroup.statuses.any((status) {
        if (providerId == ZERO) {
          return status.hidden;
        } else {
          return providerId == status.providerId && status.hidden;
        }
      });
    });
  }

  void _filterHiddenModifiers(int? providerId, List<Modifiers> data) {
    data.removeWhere((modifier) {
      return modifier.statuses.any((status) {
        if (providerId == ZERO) {
          return status.hidden;
        } else {
          return providerId == status.providerId && status.hidden;
        }
      });
    });
  }
}
