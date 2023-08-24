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
    final params = {
      'branch_id': printerSetting.branchId,
      'type_id': printerSetting.connectionType,
      'roll_id': printerSetting.paperSize,
      'font_id': printerSetting.fontId,
      'docket_customer_copy_enabled': printerSetting.customerCopyEnabled,
      'docket_kitchen_copy_enabled': printerSetting.kitchenCopyEnabled,
      'docket_customer_copy_count': printerSetting.customerCopyCount,
      'docket_kitchen_copy_count': printerSetting.kitchenCopyCount,
      'sticker_printer_enabled': printerSetting.stickerPrinterEnabled,
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
