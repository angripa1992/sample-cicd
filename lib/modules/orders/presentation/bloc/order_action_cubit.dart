import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../domain/usecases/update_order_status.dart';

class OrderActionCubit extends Cubit<ResponseState> {
  final UpdateOrderStatus _updateOrderStatus;

  OrderActionCubit(this._updateOrderStatus) : super(Empty());

  void updateOrderStatus(Map<String, dynamic> params) async {
    emit(Loading());
    final response = await _updateOrderStatus(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (orders) {
        emit(Success<ActionSuccess>(orders));
      },
    );
  }
}
