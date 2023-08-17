import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

class UpdatePaymentInfoCubit extends Cubit<ResponseState> {
  final OrderRepository _repository;

  UpdatePaymentInfoCubit(this._repository) : super(Empty());

  void updateOrderStatus(Map<String, dynamic> updateStatusParam) async {
    emit(Loading());
    final updatePaymentInfoParams = {
      "id": updateStatusParam["id"],
      "payment_method": updateStatusParam["payment_method"],
      "payment_channel_id": updateStatusParam["payment_channel_id"],
      "payment_status": updateStatusParam["payment_status"],
    };
    final response =
        await _repository.updatePaymentInfo(updatePaymentInfoParams);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (paymentInfoSuccess) async {
        final updateStatusResponse =
            await _repository.updateStatus(updateStatusParam);
        updateStatusResponse.fold(
          (failure) {
            emit(Failed(failure));
          },
          (statusSuccess) {
            emit(Success<ActionSuccess>(statusSuccess));
          },
        );
      },
    );
  }

  void updatePaymentInfo(Map<String, dynamic> params) async {
    emit(Loading());
    final response = await _repository.updatePaymentInfo(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (paymentInfoSuccess) async {
        emit(Success<ActionSuccess>(paymentInfoSuccess));
      },
    );
  }
}
