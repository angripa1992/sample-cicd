import 'package:dio/dio.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/core/network/rest_client.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/modules/orders/data/models/brand_model.dart';
import 'package:klikit/modules/orders/data/models/orders_model.dart';
import 'package:klikit/modules/orders/data/models/provider_model.dart';
import 'package:klikit/modules/orders/data/models/settings_model.dart';
import 'package:klikit/modules/orders/data/request_models/brand_request_model.dart';
import 'package:klikit/modules/orders/data/request_models/order_request_model.dart';
import 'package:klikit/modules/orders/data/request_models/provider_request_model.dart';

import '../models/order_status_model.dart';

abstract class OrderRemoteDatasource{
  Future<OrderStatusModel> fetchOrderStatus();
  Future<BrandModel> fetchBrand(BrandRequestModel requestModel);
  Future<ProviderModel> fetchProvider(ProviderRequestModel requestModel);
  Future<SettingsModel> fetchSettings(int id);
  Future<OrdersModel> fetchOrder(OrderRequestModel requestModel);
}

class OrderRemoteDatasourceImpl extends OrderRemoteDatasource{
  final RestClient _restClient;

  OrderRemoteDatasourceImpl(this._restClient);

  @override
  Future<OrderStatusModel> fetchOrderStatus() async{
    try{
      final response = await _restClient.request(Urls.status, Method.GET, null);
      return OrderStatusModel.fromJson(response);
    }on DioError{
      rethrow;
    }
  }

  @override
  Future<BrandModel> fetchBrand(BrandRequestModel requestModel) async{
    try{
      final response = await _restClient.request(Urls.brand, Method.GET, requestModel.toJson());
      return BrandModel.fromJson(response);
    }on DioError{
      rethrow;
    }
  }

  @override
  Future<ProviderModel> fetchProvider(ProviderRequestModel requestModel) async{
    try{
      final response = await _restClient.request(Urls.provider, Method.GET, requestModel.toJson());
      return ProviderModel.fromJson(response);
    }on DioError{
      rethrow;
    }
  }

  @override
  Future<SettingsModel> fetchSettings(int id) async{
    try{
      final response = await _restClient.request('${Urls.printerSettings}/$id', Method.GET,null);
      return SettingsModel.fromJson(response);
    }on DioError{
      rethrow;
    }
  }

  @override
  Future<OrdersModel> fetchOrder(OrderRequestModel requestModel) async{
    try{
      final response = await _restClient.request(Urls.order, Method.GET,requestModel.toJson());
      return OrdersModel.fromJson(response);
    }on DioError{
      rethrow;
    }
  }
}