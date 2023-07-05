import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../domain/entities/order.dart';
import '../../domain/usecases/fetch_new_order.dart';
import '../../provider/order_parameter_provider.dart';

class AllOrderCubit extends Cubit<ResponseState> {
  final FetchNewOrder _fetchNewOrder;
  final OrderParameterProvider _orderParameterProvider;

  AllOrderCubit(
    this._fetchNewOrder,
    this._orderParameterProvider,
  ) : super(Empty());

  void fetchAllOrder({
    List<int>? providersID,
    List<int>? brandsID,
  }) async {
    final params =
        await _orderParameterProvider.getAllOrderParams(brandsID, providersID);
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
