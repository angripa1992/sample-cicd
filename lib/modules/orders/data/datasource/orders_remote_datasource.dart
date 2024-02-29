import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/core/network/rest_client.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/data/models/orders_model.dart';
import 'package:klikit/modules/orders/data/models/settings_model.dart';

import '../../edit_order/grab_order_update_request_model.dart';
import '../models/attachment_image_file.dart';
import '../models/cancellation_reason_model.dart';
import '../models/order_status_model.dart';
import '../models/qris_payment_success_response.dart';
import '../models/webshop_order_details_model.dart';

abstract class OrderRemoteDatasource {
  Future<List<OrderStatusModel>> fetchOrderStatus();

  Future<SettingsModel> fetchSettings(int id);

  Future<OrdersModel> fetchOrder(Map<String, dynamic> params);

  Future<OrderModel> fetchOrderById(int id);

  Future<WebShopOrderDetailsModel> fetchOmsOrderById(String externalID);

  Future<ActionSuccess> updateOrderStatus(Map<String, dynamic> params);

  Future<ActionSuccess> updatePaymentInfo(Map<String, dynamic> params);

  Future<QrisUpdatePaymentResponse> updateQrisPaymentInfo(Map<String, dynamic> params);

  Future<ActionSuccess> addComment(Map<String, dynamic> params, int orderID);

  Future<ActionSuccess> deleteComment(int orderID);

  Future<ActionSuccess> updateGrabOrder(GrabOrderUpdateRequestModel model);

  Future<ActionSuccess> findRider(int id);

  Future<OrderModel> calculateGrabOrder(OrderModel model);

  Future<List<CancellationReasonModel>> fetchCancellationReasons();

  Future<ActionSuccess> updatePrepTime(int orderID, Map<String, dynamic> params);

  Future<ActionSuccess> cancelRider(int orderID);

  Future<List<AttachmentImageFile>> fetchAttachments(int orderID);
}

class OrderRemoteDatasourceImpl extends OrderRemoteDatasource {
  final RestClient _restClient;

  OrderRemoteDatasourceImpl(this._restClient);

  @override
  Future<List<OrderStatusModel>> fetchOrderStatus() async {
    try {
      final List<dynamic> response = await _restClient.request(Urls.status, Method.GET, null);
      final List<OrderStatusModel> result = response.map((e) => OrderStatusModel.fromJson(e)).toList();
      return result;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<SettingsModel> fetchSettings(int id) async {
    try {
      final response = await _restClient.request('${Urls.printerSettings}/$id', Method.GET, null);
      return SettingsModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<OrdersModel> fetchOrder(Map<String, dynamic> params) async {
    try {
      final response = await _restClient.request(Urls.order, Method.GET, params);
      return OrdersModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> updateOrderStatus(Map<String, dynamic> params) async {
    try {
      final response = await _restClient.request(Urls.updateStatus, Method.PATCH, params);
      return ActionSuccess.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> addComment(Map<String, dynamic> params, int orderID) async {
    try {
      final response = await _restClient.request(Urls.comment(orderID), Method.PATCH, params);
      return ActionSuccess.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> deleteComment(int orderID) async {
    try {
      final response = await _restClient.request(Urls.comment(orderID), Method.DELETE, null);
      return ActionSuccess.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<OrderModel> fetchOrderById(int id) async {
    try {
      final response = await _restClient.request('${Urls.order}/$id', Method.GET, null);
      final str = jsonEncode(response);
      return OrderModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> updatePaymentInfo(Map<String, dynamic> params) async {
    try {
      final response = await _restClient.request(Urls.updatePaymentInfo, Method.PATCH, params);
      return ActionSuccess.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<QrisUpdatePaymentResponse> updateQrisPaymentInfo(Map<String, dynamic> params) async {
    try {
      final response = await _restClient.request(Urls.updatePaymentInfo, Method.PATCH, params);
      return QrisUpdatePaymentResponse.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<OrderModel> calculateGrabOrder(OrderModel model) async {
    try {
      final response = await _restClient.request(
        Urls.calculateGrabOrderBill,
        Method.POST,
        model.toJson(),
      );
      return OrderModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> updateGrabOrder(GrabOrderUpdateRequestModel model) async {
    try {
      final payload = model.toJson();
      final response = await _restClient.request(Urls.updateGrabOrder, Method.PUT, payload);
      return ActionSuccess.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> findRider(int id) async {
    try {
      final response = await _restClient.request(Urls.findRider(id), Method.PATCH, {});
      return ActionSuccess.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<CancellationReasonModel>> fetchCancellationReasons() async {
    try {
      final List<dynamic> response = await _restClient.request(
        Urls.cancellationReasons,
        Method.GET,
        {'type_id': 1},
      );
      return response.map((e) => CancellationReasonModel.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<WebShopOrderDetailsModel> fetchOmsOrderById(String externalID) async {
    try {
      final response = await _restClient.request('${Urls.omsOrder}/$externalID', Method.GET, null);
      return WebShopOrderDetailsModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> updatePrepTime(int orderID, Map<String, dynamic> params) async {
    try {
      final response = await _restClient.request(Urls.updatePrepTime(orderID), Method.PATCH, params);
      return ActionSuccess.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> cancelRider(int orderID) async {
    try {
      await _restClient.request(Urls.cancelRider(orderID), Method.DELETE, null);
      return ActionSuccess('Successfully canceled rider');
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<AttachmentImageFile>> fetchAttachments(int orderID) async {
    try {
      final List<dynamic> responses = await _restClient.request(Urls.orderAttachments(orderID), Method.GET, null);
      return responses.map((e) => AttachmentImageFile.fromJson(e)).toList();
    } on DioException {
      rethrow;
    }
  }
}
