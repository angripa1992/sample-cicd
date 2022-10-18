import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:klikit/core/network/token_provider.dart';
import 'package:klikit/core/network/urls.dart';

import '../../app/di.dart';
import '../../app/enums.dart';
import '../../environment_variables.dart';
import 'dio_logger.dart';
import 'error_handler.dart';

class RestClient {
  static const String _CONTENT_TYPE = 'Content-Type';
  static const String _AUTHORIZATION = 'Authorization';
  final TokenProvider _tokenProvider;
  final DioLogger _dioLogger = DioLogger();
  final Dio _dio = Dio();

  RestClient(this._tokenProvider) {
    _initInterceptor();
  }

  String _token(String? accessToken) => 'Bearer $accessToken';

  void _initInterceptor() {
    _dio.options.baseUrl = getIt.get<EnvironmentVariables>().baseUrl;
    _dio.options.headers[_CONTENT_TYPE] = 'application/json';
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path == Urls.login ||
              options.path == Urls.forgetPassword) {
            handler.next(options);
          } else {
            if (_tokenProvider.accessToken == null) {
              final tokenResponse = await _tokenProvider.fetchTokenFromServer();
              tokenResponse.fold(
                (accessToken) {
                  options.headers[_AUTHORIZATION] = _token(accessToken);
                  handler.next(options);
                },
                (errorCode) {},
              );
            } else {
              options.headers[_AUTHORIZATION] =
                  _token(_tokenProvider.accessToken);
              handler.next(options);
            }
          }
          if (!kReleaseMode) {
            _dioLogger.logRequest(options);
          }
        },
        onError: (error, handler) async {
          if (!kReleaseMode) {
            _dioLogger.logError(error);
          }
          var options = error.response!.requestOptions;
          if (options.path == Urls.login ||
              options.path == Urls.forgetPassword) {
            return handler.next(error);
          } else {
            if (error.response?.statusCode == ResponseCode.UNAUTHORISED) {
              if (_token(_tokenProvider.accessToken) !=
                  options.headers[_AUTHORIZATION]) {
                options.headers[_AUTHORIZATION] =
                    _token(_tokenProvider.accessToken);
                _dio.fetch(options).then(
                  (r) => handler.resolve(r),
                  onError: (e) {
                    handler.reject(e);
                  },
                );
                return;
              }
              final tokenResponse = await _tokenProvider.fetchTokenFromServer();
              tokenResponse.fold(
                (accessToken) {
                  options.headers[_AUTHORIZATION] = _token(accessToken);
                  _dio.fetch(options).then(
                    (r) => handler.resolve(r),
                    onError: (e) {
                      handler.reject(e);
                    },
                  );
                },
                (errorCode) {
                  handler.reject(error);
                },
              );
              return;
            }
          }
          return handler.next(error);
        },
        onResponse: (response, handler) {
          if (!kReleaseMode) {
            _dioLogger.logResponse(response);
          }
          handler.next(response);
        },
      ),
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
