import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

import '../../../../app/constants.dart';
import '../../data/models/qris_payment_success_response.dart';

class UpdatePaymentInfoCubit extends Cubit<ResponseState> {
  final OrderRepository _repository;

  UpdatePaymentInfoCubit(this._repository) : super(Empty());

  void updatePaymentStatus({
    required bool isWebShopPostPayment,
    required int orderID,
    required int paymentMethod,
    required int paymentStatus,
    required int paymentChanel,
  }) async {
    emit(Loading());
    final updatePaymentStatusParam = {
      "id": orderID,
      "payment_method": paymentMethod,
      "payment_channel_id": paymentChanel,
      "payment_status": isWebShopPostPayment ? paymentStatus : PaymentStatusId.paid,
    };
    final updateOrderPaymentStatusParam = {
      "UPDATE_PAYMENT_STATUS": true,
      "id": orderID,
      "payment_method": paymentMethod,
      "payment_channel_id": paymentChanel,
      "payment_status": isWebShopPostPayment ? paymentStatus : PaymentStatusId.paid,
      "status": OrderStatus.DELIVERED,
    };
    if (isWebShopPostPayment) {
      _updatePaymentStatusForWebShop(updatePaymentStatusParam);
    } else if (paymentMethod == PaymentMethodID.QR && paymentChanel == PaymentChannelID.CREATE_QRIS) {
      _updatePaymentStatusForQris(updatePaymentStatusParam);
    } else {
      _updatePaymentStatus(updatePaymentStatusParam, updateOrderPaymentStatusParam);
    }
  }

  void _updatePaymentStatus(
    Map<String, dynamic> updatePaymentStatusParams,
    Map<String, dynamic> updateOrderStatusParams,
  ) async {
    final response = await _repository.updatePaymentInfo(updatePaymentStatusParams);
    response.fold((failure) {
      emit(Failed(failure));
    }, (paymentInfoSuccess) async {
      final updateStatusResponse = await _repository.updateStatus(updateOrderStatusParams);
      updateStatusResponse.fold((failure) {
        emit(Failed(failure));
      }, (statusSuccess) {
        emit(Success<ActionSuccess>(statusSuccess));
      });
    });
  }

  void _updatePaymentStatusForQris(Map<String, dynamic> params) async {
    final response = await _repository.updateQrisPaymentInfo(params);
    response.fold((failure) {
      emit(Failed(failure));
    }, (paymentInfoSuccess) async {
      emit(Success<QrisUpdatePaymentResponse>(paymentInfoSuccess));
    });
  }

  void _updatePaymentStatusForWebShop(Map<String, dynamic> params) async {
    final response = await _repository.updatePaymentInfo(params);
    response.fold((failure) {
      emit(Failed(failure));
    }, (paymentInfoSuccess) async {
      emit(Success<ActionSuccess>(paymentInfoSuccess));
    });
  }
}
