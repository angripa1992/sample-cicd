import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/orders_model.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../domain/repository/orders_repository.dart';

class CalculateGrabBillCubit extends Cubit<ResponseState> {
  final OrderRepository _repository;

  CalculateGrabBillCubit(this._repository) : super(Empty());

  void calculateBill(OrderModel model) async {
    emit(Loading());
    final response = await _repository.calculateGrabBill(model);
    response.fold(
      (l) => emit(
        Failed(l),
      ),
      (r) => emit(
        Success<Order>(r),
      ),
    );
  }
}
