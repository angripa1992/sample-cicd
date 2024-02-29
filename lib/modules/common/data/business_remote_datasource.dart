import 'package:dio/dio.dart';
import 'package:klikit/modules/common/model/branch_model.dart';
import 'package:klikit/modules/common/model/delivery_time_success_response.dart';

import '../../../app/enums.dart';
import '../../../app/session_manager.dart';
import '../../../core/network/rest_client.dart';
import '../../../core/network/urls.dart';
import '../model/brand_model.dart';
import '../model/payment_info.dart';
import '../model/provider_model.dart';
import '../model/source_model.dart';

abstract class BusinessRemoteDataSource {
  Future<BrandModel> fetchBrand(Map<String, dynamic> param);

  Future<List<ProviderModel>> fetchProvider(Map<String, dynamic> param);

  Future<List<SourcesModel>> fetchSources();

  Future<List<PaymentMethodModel>> fetchPaymentMethods();

  Future<List<PaymentChannelModel>> fetchAllPaymentChannels();

  Future<List<PaymentStatusModel>> fetchPaymentStatus();

  Future<BranchDataModel> fetchBranches(Map<String, dynamic> params);

  Future<DeliveryTimeDataModel> setDeliveryTime(DeliveryTimeDataModel data);

  Future<DeliveryTimeDataModel> fetchDeliveryTIme(int branchId);
}

class BusinessRemoteDataSourceImpl extends BusinessRemoteDataSource {
  final RestClient _restClient;

  BusinessRemoteDataSourceImpl(this._restClient);

  @override
  Future<BrandModel> fetchBrand(Map<String, dynamic> param) async {
    try {
      final response = await _restClient.request(Urls.brand, Method.GET, param);
      return BrandModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<ProviderModel>> fetchProvider(Map<String, dynamic> param) async {
    try {
      final List<dynamic> response = await _restClient.request(Urls.provider, Method.GET, param);
      final data = response.map((e) => ProviderModel.fromJson(e)).toList();
      return data;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<SourcesModel>> fetchSources() async {
    try {
      final List<dynamic> response = await _restClient.request(Urls.sources, Method.GET, null);
      final data = response.map((e) => SourcesModel.fromJson(e)).toList();
      return data;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<PaymentMethodModel>> fetchPaymentMethods() async {
    try {
      final List<dynamic> response = await _restClient.request(
        Urls.paymentMethod,
        Method.GET,
        {
          'country_id': SessionManager().country(),
        },
      );
      final data = response.map((e) => PaymentMethodModel.fromJson(e)).toList();
      return data;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<PaymentStatusModel>> fetchPaymentStatus() async {
    try {
      final List<dynamic> response = await _restClient.request(Urls.paymentStatus, Method.GET, null);
      final data = response.map((e) => PaymentStatusModel.fromJson(e)).toList();
      return data;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<BranchDataModel> fetchBranches(Map<String, dynamic> params) async {
    try {
      final response = await _restClient.request(Urls.branch, Method.GET, params);
      return BranchDataModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<List<PaymentChannelModel>> fetchAllPaymentChannels() async {
    try {
      final List<dynamic> response = await _restClient.request(Urls.allPaymentChannels, Method.GET, null);
      final data = response.map((e) => PaymentChannelModel.fromJson(e)).toList();
      return data;
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<DeliveryTimeDataModel> fetchDeliveryTIme(int branchId) async {
    try {
      final response = await _restClient.request(
        Urls.deliveryTime,
        Method.GET,
        {
          'branch_id': branchId,
        },
      );
      return DeliveryTimeDataModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<DeliveryTimeDataModel> setDeliveryTime(DeliveryTimeDataModel data) async {
    try {
      final response = await _restClient.request(
        Urls.deliveryTime,
        Method.POST,
        data.toJson(),
      );
      return DeliveryTimeDataModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }
}
