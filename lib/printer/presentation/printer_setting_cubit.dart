import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/printer/data/printer_setting.dart';

import '../../app/app_preferences.dart';
import '../data/printer_setting_repo.dart';

class PrinterSettingCubit extends Cubit<ResponseState> {
  final AppPreferences _appPreferences;
  final PrinterSettingRepository _repository;

  PrinterSettingCubit(this._appPreferences, this._repository) : super(Empty());

  void getPrinterSetting() async {
    emit(Loading());
    final branchId = _appPreferences.getUser().userInfo.branchId;
    final response = await _repository.getPrinterSettings(branchId);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        if (data.isEmpty) {
          emit(
            Success<PrinterSetting>(
              PrinterSetting(
                branchId: ZERO,
                connectionType: ConnectionType.BLUETOOTH,
                paperSize: RollId.mm80,
                docketType: DocketType.customer,
              ),
            ),
          );
        } else {
          emit(Success<PrinterSetting>(data.first));
        }
      },
    );
  }
}
