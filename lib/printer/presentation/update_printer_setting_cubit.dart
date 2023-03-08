import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/printer/data/printer_setting.dart';

import '../data/printer_setting_repo.dart';

class UpdatePrinterSettingCubit extends Cubit<ResponseState> {
  final PrinterSettingRepository _repository;

  UpdatePrinterSettingCubit(this._repository) : super(Empty());

  void updatePrintSetting({required PrinterSetting printerSetting}) async {
    emit(Loading());
    final response =
        await _repository.updatePrinterSettings(printerSetting.toJson());
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
