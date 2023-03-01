import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/domain/entities/busy_mode.dart';

import '../../../../../app/app_preferences.dart';
import '../../domain/usecases/update_busy_mode_status.dart';

class UpdateBusyModeCubit extends Cubit<ResponseState> {
  final UpdateBusyModeStatus _updateBusyModeStatus;
  final AppPreferences _appPreferences;

  UpdateBusyModeCubit(this._updateBusyModeStatus, this._appPreferences)
      : super(Empty());

  void updateStatus(bool isBusy) async {
    emit(Loading());
    final params = {
      "branch_id": _appPreferences.getUser().userInfo.branchId,
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
