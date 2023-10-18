import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/add_order/data/models/request/webshop_pace_order_payload.dart';
import 'package:klikit/modules/add_order/data/models/update_webshop_order_response.dart';
import 'package:klikit/modules/add_order/domain/entities/cart_bill.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';

import '../../utils/webshop_entity_provider.dart';

class UpdateWebShopOrderCubit extends Cubit<ResponseState> {
  final AddOrderRepository _repository;

  UpdateWebShopOrderCubit(this._repository) : super(Empty());

  void updateWebShopOrder(int orderID, CartBill cartBill) async {
    emit(Loading());
    final payload = await WebShopEntityProvider().placeOrderPayload(cartBill);
    final response = await _repository.updateWebShopOrder(orderID, payload);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (response) {
        emit(Success<UpdateWebShopOrderResponse>(response));
      },
    );
  }
}
