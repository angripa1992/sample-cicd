import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/enums.dart';

class PublicRestClient {
  static final _instance = PublicRestClient._internal();
  static final _dio = Dio()..interceptors.add(PrettyDioLogger());

  factory PublicRestClient() => _instance;

  PublicRestClient._internal();

  Future<dynamic> request(
    String url,
    Method method,
    Map<String, dynamic>? params,
  ) async {
    Response response;
    try {
      if (method == Method.POST) {
        response = await _dio.post(url, data: params);
      } else if (method == Method.DELETE) {
        response = await _dio.delete(url);
      } else if (method == Method.PATCH) {
        response = await _dio.patch(url, data: params);
      } else if (method == Method.PUT) {
        response = await _dio.put(url, data: params);
      } else {
        response = await _dio.get(
          url,
          queryParameters: params,
        );
      }
      return response.data;
    } on DioException {
      rethrow;
    }
  }
}
