import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../provider/order_parameter_provider.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/fetch_new_order.dart';

class NewOrderCubit extends Cubit<ResponseState> {
  final FetchNewOrder _fetchNewOrder;
  final OrderParameterProvider _orderParameterProvider;

  NewOrderCubit(
    this._fetchNewOrder,
    this._orderParameterProvider,
  ) : super(Empty());

  void fetchNewOrder({
    required bool willShowLoading,
    List<int>? providersID,
    List<int>? brandsID,
  }) async {
    if (willShowLoading) {
      emit(Loading());
    }
    final params =
        await _orderParameterProvider.getNewOrderParams(brandsID, providersID);
    final response = await _fetchNewOrder(params);
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
