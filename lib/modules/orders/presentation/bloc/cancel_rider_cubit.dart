import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

class CancelRiderCubit extends Cubit<ResponseState> {
  final OrderRepository _repository;

  CancelRiderCubit(this._repository) : super(Empty());

  void cancelRider(int orderID) async {
    emit(Loading());
    final response = await _repository.cancelRider(orderID);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (success) {
        emit(Success<ActionSuccess>(success));
      },
    );
  }
}
