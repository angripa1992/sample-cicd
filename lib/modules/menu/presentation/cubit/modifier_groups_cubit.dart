import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/entities/modifiers_group.dart';

import '../../../../app/app_preferences.dart';
import '../../domain/usecase/ftech_modifier_groups.dart';

class ModifierGroupsCubit extends Cubit<ResponseState> {
  final FetchModifierGroups _fetchModifierGroups;
  final AppPreferences _preferences;

  ModifierGroupsCubit(this._fetchModifierGroups, this._preferences)
      : super(Empty());

  void fetchModifierGroups(int brandId) async {
    emit(Loading());
    final response = await _fetchModifierGroups(
      {
        'brand_id': brandId,
        'branch_id': _preferences.getUser().userInfo.branchId,
      },
    );
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<List<ModifiersGroup>>(data));
      },
    );
  }
}
