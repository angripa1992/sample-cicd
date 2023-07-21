import 'package:dio/dio.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/core/network/rest_client.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/data/models/brand_model.dart';
import 'package:klikit/modules/orders/data/models/busy_mode_model.dart';
import 'package:klikit/modules/orders/data/models/orders_model.dart';
import 'package:klikit/modules/orders/data/models/provider_model.dart';
import 'package:klikit/modules/orders/data/models/settings_model.dart';
import 'package:klikit/modules/orders/data/models/source_model.dart';
import 'package:klikit/modules/orders/data/request_models/brand_request_model.dart';

import '../../edit_order/grab_order_update_request_model.dart';
import '../models/cancellation_reason_model.dart';
import '../models/order_status_model.dart';
import '../models/payment_info.dart';

abstract class OrderRemoteDatasource {
  Future<List<OrderStatusModel>> fetchOrderStatus();

  Future<BrandModel> fetchBrand(BrandRequestModel requestModel);

  Future<List<ProviderModel>> fetchProvider(Map<String, dynamic> param);

  Future<List<SourcesModel>> fetchSources();

  Future<List<PaymentMethodModel>> fetchPaymentMethods();

  Future<List<PaymentStatusModel>> fetchPaymentStatus();

  Future<SettingsModel> fetchSettings(int id);

  Future<OrdersModel> fetchOrder(Map<String, dynamic> params);

  Future<OrderModel> fetchOrderById(int id);

  Future<BusyModeGetResponseModel> isBusy(Map<String, dynamic> params);

  Future<BusyModePostResponseModel> updateBusyMode(Map<String, dynamic> params);

  Future<ActionSuccess> updateOrderStatus(Map<String, dynamic> params);

  Future<ActionSuccess> updatePaymentInfo(Map<String, dynamic> params);

  Future<ActionSuccess> addComment(Map<String, dynamic> params, int orderID);

  Future<ActionSuccess> deleteComment(int orderID);

  Future<ActionSuccess> updateGrabOrder(GrabOrderUpdateRequestModel model);

  Future<ActionSuccess> findRider(int id);

  Future<OrderModel> calculateGrabOrder(OrderModel model);

  Future<List<CancellationReasonModel>> fetchCancellationReasons();
}

class OrderRemoteDatasourceImpl extends OrderRemoteDatasource {
  final RestClient _restClient;

  OrderRemoteDatasourceImpl(this._restClient);

  @override
  Future<List<OrderStatusModel>> fetchOrderStatus() async {
    try {
      final List<dynamic> response =
          await _restClient.request(Urls.status, Method.GET, null);
      final List<OrderStatusModel> result =
          response.map((e) => OrderStatusModel.fromJson(e)).toList();
      return result;
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<BrandModel> fetchBrand(BrandRequestModel requestModel) async {
    try {
      final response = await _restClient.request(
          Urls.brand, Method.GET, requestModel.toJson());
      return BrandModel.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<List<ProviderModel>> fetchProvider(Map<String, dynamic> param) async {
    try {
      final List<dynamic> response =
          await _restClient.request(Urls.provider, Method.GET, param);
      final data = response.map((e) => ProviderModel.fromJson(e)).toList();
      return data;
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<SettingsModel> fetchSettings(int id) async {
    try {
      final response = await _restClient.request(
          '${Urls.printerSettings}/$id', Method.GET, null);
      return SettingsModel.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<OrdersModel> fetchOrder(Map<String, dynamic> params) async {
    try {
      final response =
          await _restClient.request(Urls.order, Method.GET, params);
      return OrdersModel.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<BusyModeGetResponseModel> isBusy(Map<String, dynamic> params) async {
    try {
      final response = await _restClient.request(Urls.busy, Method.GET, params);
      return BusyModeGetResponseModel.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<BusyModePostResponseModel> updateBusyMode(
      Map<String, dynamic> params) async {
    try {
      final response =
          await _restClient.request(Urls.busy, Method.POST, params);
      return BusyModePostResponseModel.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> updateOrderStatus(Map<String, dynamic> params) async {
    try {
      final response =
          await _restClient.request(Urls.updateStatus, Method.PATCH, params);
      return ActionSuccess.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> addComment(
      Map<String, dynamic> params, int orderID) async {
    try {
      final response = await _restClient.request(
          Urls.comment(orderID), Method.PATCH, params);
      return ActionSuccess.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> deleteComment(int orderID) async {
    try {
      final response =
          await _restClient.request(Urls.comment(orderID), Method.DELETE, null);
      return ActionSuccess.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<OrderModel> fetchOrderById(int id) async {
    try {
      final response =
          await _restClient.request('${Urls.order}/$id', Method.GET, null);
      return OrderModel.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<List<SourcesModel>> fetchSources() async {
    try {
      final List<dynamic> response =
          await _restClient.request(Urls.sources, Method.GET, null);
      final data = response.map((e) => SourcesModel.fromJson(e)).toList();
      return data;
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<List<PaymentMethodModel>> fetchPaymentMethods() async {
    try {
      final List<dynamic> response =
          await _restClient.request(Urls.paymentMethod, Method.GET, null);
      final data = response.map((e) => PaymentMethodModel.fromJson(e)).toList();
      return data;
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<List<PaymentStatusModel>> fetchPaymentStatus() async {
    try {
      final List<dynamic> response =
          await _restClient.request(Urls.paymentStatus, Method.GET, null);
      final data = response.map((e) => PaymentStatusModel.fromJson(e)).toList();
      return data;
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> updatePaymentInfo(Map<String, dynamic> params) async {
    try {
      final response = await _restClient.request(
          Urls.updatePaymentInfo, Method.PATCH, params);
      return ActionSuccess.fromJson(response);
    } on DioError {
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
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> updateGrabOrder(
      GrabOrderUpdateRequestModel model) async {
    try {
      final payload = model.toJson();
      final response =
          await _restClient.request(Urls.updateGrabOrder, Method.PUT, payload);
      return ActionSuccess.fromJson(response);
    } on DioError {
      rethrow;
    }
  }

  @override
  Future<ActionSuccess> findRider(int id) async {
    try {
      final response =
          await _restClient.request(Urls.findRider(id), Method.PATCH, {});
      return ActionSuccess.fromJson(response);
    } on DioError {
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
    } on DioError {
      rethrow;
    }
  }
}
