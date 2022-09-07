import 'package:dio/dio.dart';
import 'package:klikit/core/network/dio_interceptor.dart';
import 'package:klikit/core/network/token_provider.dart';

import '../../app/di.dart';
import '../../app/enums.dart';
import '../../environment_variables.dart';
import 'dio_logger.dart';

class RestClient {
  final TokenProvider _tokenProvider;
  final Dio _dio = Dio();

  RestClient(this._tokenProvider) {
    _initInterceptor();
  }

  void _initInterceptor() {
    _dio.options.baseUrl = getIt.get<EnvironmentVariables>().baseUrl;
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.interceptors.add(
      DioInterceptor(_tokenProvider, _dio),
      // QueuedInterceptorsWrapper(
      //   onRequest: (options, handler) async {
      //     if (options.path == Urls.login) {
      //       handler.next(options);
      //     } else {
      //       if (_tokenProvider.accessToken == null) {
      //         final tokenResponse = await _tokenProvider.fetchTokenFromServer();
      //         tokenResponse.fold(
      //           (accessToken) {
      //             options.headers['Authorization'] = 'Bearer $accessToken';
      //             handler.next(options);
      //           },
      //           (errorCode) {},
      //         );
      //       } else {
      //         options.headers['Authorization'] =
      //             'Bearer ${_tokenProvider.accessToken}';
      //         handler.next(options);
      //       }
      //     }
      //     if (!kReleaseMode) {
      //       _dioLogger.logRequest(options);
      //     }
      //   },
      //   onError: (error, handler) async {
      //     if (!kReleaseMode) {
      //       _dioLogger.logError(error);
      //     }
      //     if (error.response?.statusCode == ResponseCode.UNAUTHORISED) {
      //       var options = error.response!.requestOptions;
      //       if ("Bearer ${_tokenProvider.accessToken}" != options.headers['Authorization']) {
      //         options.headers['Authorization'] = "Bearer ${_tokenProvider.accessToken}";
      //         _dio.fetch(options).then(
      //           (r) => handler.resolve(r),
      //           onError: (e) {
      //             handler.reject(e);
      //           },
      //         );
      //         return;
      //       }
      //       final tokenResponse = await _tokenProvider.fetchTokenFromServer();
      //       tokenResponse.fold(
      //         (accessToken) {
      //           options.headers['Authorization'] = 'Bearer $accessToken';
      //           _dio.fetch(options).then(
      //             (r) => handler.resolve(r),
      //             onError: (e) {
      //               handler.reject(e);
      //             },
      //           );
      //         },
      //         (errorCode) {
      //           handler.reject(error);
      //         },
      //       );
      //       return;
      //     }
      //     return handler.next(error);
      //   },
      //   onResponse: (response, handler) {
      //     if (!kReleaseMode) {
      //       _dioLogger.logResponse(response);
      //     }
      //     handler.next(response);
      //   },
      // ),
    );
  }

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
      } else {
        response = await _dio.get(
          url,
          queryParameters: params,
        );
      }
      return response.data;
    } on DioError {
      rethrow;
    }
  }
}
