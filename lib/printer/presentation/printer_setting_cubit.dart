import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/printer/data/printer_setting.dart';

import '../../app/session_manager.dart';
import '../data/printer_setting_repo.dart';

class PrinterSettingCubit extends Cubit<ResponseState> {
  final PrinterSettingRepository _repository;

  PrinterSettingCubit(this._repository) : super(Empty());

  void getPrinterSetting() async {
    emit(Loading());
    final branchId = SessionManager().currentUserBranchId();
    final response = await _repository.getPrinterSettings(branchId);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<PrinterSetting>(data.first));
      },
    );
  }
}
