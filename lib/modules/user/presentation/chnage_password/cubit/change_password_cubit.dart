import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/user/data/request_model/change_password_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';

import '../../../domain/usecases/chnage_password.dart';
import '../../../domain/usecases/logout_usecase.dart';

class ChangePasswordCubit extends Cubit<CubitState> {
  final ChangePassword _changePassword;
  final LogoutUser _logoutUser;

  ChangePasswordCubit(this._changePassword, this._logoutUser) : super(Empty());

  void changePasswordAndLogout(ChangePasswordRequestModel requestModel) async {
    emit(Loading());
    final changePasswordResponse = await _changePassword(requestModel);
    changePasswordResponse.fold(
      (changePasswordError) {
        emit(Failed(changePasswordError));
      },
      (changePasswordSuccessResponse) async {
        final logoutResponse = await _logoutUser(NoParams());
        logoutResponse.fold(
          (logoutError) {
            emit(Success<SuccessResponse>(changePasswordSuccessResponse));
          },
          (logoutSuccess) {
            emit(Success<SuccessResponse>(changePasswordSuccessResponse));
          },
        );
      },
    );
  }
}
