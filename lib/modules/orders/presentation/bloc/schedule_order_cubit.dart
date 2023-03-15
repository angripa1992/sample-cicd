import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../domain/entities/order.dart';
import '../../domain/repository/orders_repository.dart';
import '../../provider/order_parameter_provider.dart';

class ScheduleOrderCubit extends Cubit<ResponseState> {
  final OrderRepository _orderRepository;
  final OrderParameterProvider _orderParameterProvider;

  ScheduleOrderCubit(
    this._orderParameterProvider,
    this._orderRepository,
  ) : super(Empty());

  void fetchScheduleOrder({
    required bool willShowLoading,
    List<int>? providersID,
    List<int>? brandsID,
  }) async {
    if (willShowLoading) {
      emit(Loading());
    }
    final params = await _orderParameterProvider.getScheduleOrderParams(brandsID, providersID);
    final response = await _orderRepository.fetchOrder(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (orders) {
        emit(Success<Orders>(orders));
      },
    );
  }
}
