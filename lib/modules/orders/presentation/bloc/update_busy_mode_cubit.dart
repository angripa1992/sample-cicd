import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/domain/entities/busy_mode.dart';

import '../../../../app/session_manager.dart';
import '../../domain/usecases/update_busy_mode_status.dart';

class UpdateBusyModeCubit extends Cubit<ResponseState> {
  final UpdateBusyModeStatus _updateBusyModeStatus;

  UpdateBusyModeCubit(this._updateBusyModeStatus) : super(Empty());

  void updateStatus(bool isBusy) async {
    emit(Loading());
    final params = {
      "branch_id": SessionManager().branchId(),
      "is_busy": isBusy,
    };
    final response = await _updateBusyModeStatus(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<BusyModePostResponse>(data.copyWithBusyMode(isBusy)));
      },
    );
  }
}
