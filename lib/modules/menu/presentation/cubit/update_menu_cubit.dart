import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../app/session_manager.dart';

class UpdateMenuCubit extends Cubit<ResponseState> {
  final UpdateMenu _updateMenu;

  UpdateMenuCubit(this._updateMenu) : super(Empty());

  void updateMenu({
    required int brandId,
    required int id,
    required int type,
    required bool enabled,
  }) async {
    emit(Loading());
    final response = await _updateMenu(
      UpdateMenuParams(
        branchId: SessionManager().currentUserBranchId(),
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
