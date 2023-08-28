import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/user/domain/repositories/user_repository.dart';

import '../../../../../app/session_manager.dart';
import '../../../domain/entities/success_response.dart';

class DeviceSettingCubit extends Cubit<ResponseState> {
  final UserRepository _repository;

  DeviceSettingCubit(this._repository) : super(Empty());

  void changeSunmiDeviceSetting(bool isSunmiDevice) async {
    emit(Loading());
    final params = {
      "user_id": SessionManager().user().id,
      "sunmi_device": isSunmiDevice,
    };
    final response = await _repository.changeSettings(params);
    response.fold(
      (error) {
        emit(Failed(error));
      },
      (success) async {
        await SessionManager().setSunmiDevice(isSunmiDevice);
        emit(Success<SuccessResponse>(success));
      },
    );
  }
}
