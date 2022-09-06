import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/cubit_state.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/domain/usecases/update_user_info.dart';

class UpdateUserInfoCubit extends Cubit<CubitState> {
  final UpdateUserInfo _updateUserInfo;

  UpdateUserInfoCubit(this._updateUserInfo) : super(Empty());

  void updateUserInfo(UpdateUserInfoParams params) async {
    emit(Loading());
    final response = await _updateUserInfo(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        emit(Success<SuccessResponse>(data));
      },
    );
  }
}
