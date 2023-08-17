import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';

import '../../data/models/placed_order_response.dart';
import '../../domain/entities/add_to_cart_item.dart';
import '../../domain/repository/add_order_repository.dart';
import '../../utils/order_entity_provider.dart';

class PlaceOrderCubit extends Cubit<ResponseState> {
  final AddOrderRepository _repository;

  PlaceOrderCubit(this._repository) : super(Empty());

  void placeOrder({
    required CheckoutData checkoutData,
    required int paymentStatus,
    required int? paymentMethod,
    required int? paymentChannel,
    required CustomerInfo? info,
  }) async {
    emit(Loading());
    final body = await OrderEntityProvider().placeOrderRequestData(
      checkoutData: checkoutData,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      paymentChannel: paymentChannel,
      info: info,
    );
    final response = await _repository.placeOrder(body: body);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (successResponse) {
        emit(Success<PlacedOrderResponse>(successResponse));
      },
    );
  }
}
