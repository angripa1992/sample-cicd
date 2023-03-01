import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../app/session_manager.dart';
import '../data/printer_setting_repo.dart';

class UpdatePrinterSettingCubit extends Cubit<ResponseState> {
  final PrinterSettingRepository _repository;

  UpdatePrinterSettingCubit(this._repository) : super(Empty());

  void updatePrintSetting({
    required int connectionType,
    required int paperSize,
  }) async {
    emit(Loading());
    final branchId = SessionManager().currentUserBranchId();
    final params = {
      'branch_id': branchId,
      'type_id': connectionType,
      'roll_id': paperSize,
    };
    final response = await _repository.updatePrinterSettings(params);
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
