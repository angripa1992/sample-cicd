import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';

import '../../../domain/usecases/logout_usecase.dart';

class LogoutCubit extends Cubit<CubitState> {
  final LogoutUser _logoutUser;

  LogoutCubit(this._logoutUser) : super(Empty());

  void logout() async {
    emit(Loading());
    final response = await _logoutUser(NoParams());
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
