import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../provider/order_parameter_provider.dart';
import '../../domain/entities/order.dart';
import '../../domain/usecases/fetch_ongoing_order.dart';

class OngoingOrderCubit extends Cubit<ResponseState> {
  final FetchOngoingOrder _fetchOngoingOrder;
  final OrderParameterProvider _orderParameterProvider;

  OngoingOrderCubit(this._fetchOngoingOrder, this._orderParameterProvider)
      : super(Empty());

  void fetchOngoingOrder(
      {required bool willShowLoading,
      List<int>? providersID,
      List<int>? brandsID}) async {
    if (willShowLoading) {
      emit(Loading());
    }
    final params = await _orderParameterProvider.getOngoingOrderParams(
        brandsID, providersID);
    final response = await _fetchOngoingOrder(params);
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
