import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:klikit/network/token_provider.dart';

import '../app/enums.dart';

class RestClient {
  final TokenProvider _tokenProvider;
  final Dio _dio = Dio();

  RestClient(this._tokenProvider) {
    _initInterceptor();
  }

  void _initInterceptor() {
    _dio.options.baseUrl = '';
    _dio.options.headers['Content-Type'] = 'application/json';
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          if (!kReleaseMode) {
            _logRequest(options);
          }
          if (_tokenProvider.accessToken == null) {
            final tokenResponse = await _tokenProvider.fetchTokenFromServer();
            tokenResponse.fold(
              (accessToken) {
                _dio.options.headers['Authorization'] = 'Bearer $accessToken';
                handler.next(options);
              },
              (errorCode) {},
            );
          } else {
            _dio.options.headers['Authorization'] =
                'Bearer ${_tokenProvider.accessToken}';
            handler.next(options);
          }
        },
        onError: (error, handler) async {
          if (!kReleaseMode) {
            _logError(error);
          }
          if (error.response?.statusCode == 401) {
            var options = error.response!.requestOptions;
            if ("Bearer ${_tokenProvider.accessToken}" !=
                options.headers['Authorization']) {
              options.headers['Authorization'] =
                  "Bearer ${_tokenProvider.accessToken}";
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
                _dio.options.headers['Authorization'] = 'Bearer $accessToken';
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
          }
          return handler.next(error);
        },
        onResponse: (response, handler) {
          if (!kReleaseMode) {
            _logResponse(response);
          }
          handler.next(response);
        },
      ),
    );
  }

  Future<dynamic> request(
      String url, Method method, Map<String, dynamic>? params) async {
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

  void _logRequest(RequestOptions options) {
    _logPrint('*** API Request - Start ***');
    _printKV('URI', options.uri);
    _printKV('METHOD', options.method);
    _logPrint('HEADERS:');
    options.headers.forEach((key, v) => _printKV(' - $key', v));
    _logPrint('BODY:');
    _printAll(options.data ?? "");
    _logPrint('*** API Request - End ***');
  }

  void _logResponse(Response response) {
    _logPrint('*** Api Response - Start ***');
    _printKV('URI', response.requestOptions.uri);
    _printKV('STATUS CODE', response.statusCode);
    _printKV('REDIRECT', response.isRedirect);
    _logPrint('BODY:');
    _printAll(response.data ?? "");
    _logPrint('*** Api Response - End ***');
  }

  void _logError(DioError error) {
    _logPrint('*** Api Error - Start ***:');
    _logPrint('URI: ${error.requestOptions.uri}');
    if (error.response != null) {
      _logPrint('STATUS CODE: ${error.response?.statusCode?.toString()}');
    }
    _logPrint('$error');
    if (error.response != null) {
      _printKV('REDIRECT', error.response?.realUri);
      _logPrint('BODY:');
      _printAll(error.response?.toString());
    }
    _logPrint('*** Api Error - End ***:');
  }

  void _printKV(String key, dynamic v) {
    _logPrint('$key: $v');
  }

  void _printAll(msg) {
    msg.toString().split('\n').forEach(_logPrint);
  }

  void _logPrint(String s) {
    debugPrint(s);
  }
}
