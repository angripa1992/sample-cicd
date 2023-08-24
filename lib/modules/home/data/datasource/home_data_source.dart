import 'package:dio/dio.dart';

import '../../../../app/enums.dart';
import '../../../../core/network/rest_client.dart';
import '../../../../core/network/urls.dart';
import '../model/z_report_data_model.dart';

abstract class HomeRemoteDataSource {
  Future<ZReportDataModel> fetchZReportData(Map<String, dynamic> params);
}

class HomeRemoteDataSourceImpl extends HomeRemoteDataSource {
  final RestClient _restClient;

  HomeRemoteDataSourceImpl(this._restClient);

  @override
  Future<ZReportDataModel> fetchZReportData(Map<String, dynamic> params) async {
    try {
      final response = await _restClient.request(
        Urls.zReportSummary,
        Method.GET,
        params,
      );
      return ZReportDataModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }
}
