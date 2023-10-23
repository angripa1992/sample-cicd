import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

class UpdatePrepTimeCubit extends Cubit<ResponseState> {
  final OrderRepository _repository;

  UpdatePrepTimeCubit(this._repository) : super(Empty());

  void updatePrepTime({
    required int orderID,
    required String externalID,
    required num min,
  }) async {
    emit(Loading());
    final response = await _repository.updatePrepTime(
      orderID,
      {
        "external_id": externalID,
        "preparation_time": min,
      },
    );
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
