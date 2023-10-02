import 'package:dio/dio.dart';
import 'package:klikit/modules/common/model/branch_info_model.dart';

import '../../../app/enums.dart';
import '../../../app/session_manager.dart';
import '../../../core/network/rest_client.dart';
import '../../../core/network/urls.dart';
import '../model/brand_request_model.dart';
import '../model/brand_model.dart';
import '../model/payment_info.dart';
import '../model/provider_model.dart';
import '../model/source_model.dart';

abstract class BusinessRemoteDataSource {
  Future<BrandModel> fetchBrand(BrandRequestModel requestModel);

  Future<List<ProviderModel>> fetchProvider(Map<String, dynamic> param);

  Future<List<SourcesModel>> fetchSources();

  Future<List<PaymentMethodModel>> fetchPaymentMethods();

  Future<List<PaymentStatusModel>> fetchPaymentStatus();

  Future<BusinessBranchInfoModel> fetchBranchDetails(int branchID);
}

class BusinessRemoteDataSourceImpl extends BusinessRemoteDataSource {
  final RestClient _restClient;

  BusinessRemoteDataSourceImpl(this._restClient);

  @override
  Future<BrandModel> fetchBrand(BrandRequestModel requestModel) async {
    try {
      final response = await _restClient.request(Urls.brand, Method.GET, requestModel.toJson());
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
  Future<BusinessBranchInfoModel> fetchBranchDetails(int branchID) async {
    try {
      final response = await _restClient.request(Urls.branch(branchID), Method.GET, null);
      return BusinessBranchInfoModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }
}
