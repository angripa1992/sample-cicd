import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/add_order/data/models/request/billing_request.dart';
import 'package:klikit/modules/add_order/domain/entities/cart_bill.dart';

import '../../domain/repository/add_order_repository.dart';

class CalculateBillCubit extends Cubit<ResponseState> {
  final AddOrderRepository _repository;

  CalculateBillCubit(this._repository) : super(Empty());

  void calculateBill(BillingRequestModel requestModel) async {
    emit(Loading());
    final response = await _repository.calculateBill(model: requestModel);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (bill) {
        emit(Success<CartBill>(bill));
      },
    );
  }
}
