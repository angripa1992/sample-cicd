import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/user/domain/repositories/user_repository.dart';
import 'package:klikit/printer/printer_local_data_manager.dart';

import '../../../../../app/session_manager.dart';
import '../../../domain/entities/success_response.dart';

class DeviceSettingCubit extends Cubit<ResponseState> {
  final UserRepository _repository;

  DeviceSettingCubit(this._repository) : super(Empty());

  void changeActiveDevice(int device) async {
    emit(Loading());
    final params = {
      "user_id": SessionManager().user()!.id,
      "printing_device_id": device,
    };
    final response = await _repository.changeUserSettings(params);
    response.fold(
      (error) {
        emit(Failed(error));
      },
      (success) async {
        await LocalPrinterDataManager().setActiveDevice(device);
        emit(Success<SuccessResponse>(success));
      },
    );
  }
}
