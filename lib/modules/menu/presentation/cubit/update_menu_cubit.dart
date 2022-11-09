import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../app/app_preferences.dart';

class UpdateMenuCubit extends Cubit<ResponseState> {
  final AppPreferences _preferences;
  final UpdateMenu _updateMenu;

  UpdateMenuCubit(this._preferences, this._updateMenu) : super(Empty());

  void updateMenu({
    required int brandId,
    required int id,
    required int type,
    required bool enabled,
  }) async {
    emit(Loading());
    final response = await _updateMenu(
      UpdateMenuParams(
        branchId: _preferences.getUser().userInfo.branchId,
        brandId: brandId,
        enabled: enabled,
        id: id,
        type: type,
      ),
    );
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<ActionSuccess>(data));
      },
    );
  }
}
