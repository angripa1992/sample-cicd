import 'package:dio/dio.dart';
import 'package:klikit/modules/home/data/model/summary_data_model.dart';

import '../../../../app/enums.dart';
import '../../../../core/network/rest_client.dart';
import '../../../../core/network/urls.dart';
import '../model/z_report_data_model.dart';

abstract class HomeRemoteDataSource {
  Future<ZReportData> fetchZReportData(Map<String, dynamic> params);

  Future<OrderSummaryDataModel> fetchSummaryData(Map<String, dynamic> params);
}

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final RestClient _restClient;

  HomeRemoteDataSourceImpl(this._restClient);

  @override
  Future<ZReportData> fetchZReportData(Map<String, dynamic> params) async {
    try {
      final response = await _restClient.request(Urls.zReportSummary, Method.GET, params);
      return ZReportData.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<OrderSummaryDataModel> fetchSummaryData(Map<String, dynamic> params) async {
    try {
      final response = await _restClient.request(Urls.orderSummary, Method.GET, params);
      return OrderSummaryDataModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }
}
