import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/modules/user/data/request_model/reset_link_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';

import '../../../domain/usecases/send_reset_link.dart';

class ForgetPasswordCubit extends Cubit<CubitState> {
  final SentResetLink _sentResetLink;

  ForgetPasswordCubit(this._sentResetLink) : super(Empty());

  void sendResetPasswordLink(ResetLinkRequestModel requestModel) async {
    emit(Loading());
    final response = await _sentResetLink(requestModel);
    response.fold(
      (error) {
        emit(Failed(error));
      },
      (success) {
        emit(Success<SuccessResponse>(success));
      },
    );
  }
}
