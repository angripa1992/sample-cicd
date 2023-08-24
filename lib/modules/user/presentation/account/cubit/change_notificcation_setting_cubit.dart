import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/user/domain/repositories/user_repository.dart';

import '../../../../../app/session_manager.dart';
import '../../../domain/entities/success_response.dart';

class ChangeNotificationSettingCubit extends Cubit<ResponseState> {
  final UserRepository _repository;

  ChangeNotificationSettingCubit(this._repository) : super(Empty());

  void changeNotificationSetting(bool enable) async {
    emit(Loading());
    final params = {
      "user_id": SessionManager().currentUser().id,
      "order_notification_enabled": enable,
    };
    final response = await _repository.changeSettings(params);
    response.fold(
      (error) {
        emit(Failed(error));
      },
      (success) async {
        await SessionManager().setNotificationEnabled(enable);
        emit(Success<SuccessResponse>(success));
      },
    );
  }
}
