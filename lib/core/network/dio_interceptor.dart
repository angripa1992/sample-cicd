import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:klikit/core/network/token_provider.dart';
import 'package:klikit/core/network/urls.dart';

import 'dio_logger.dart';
import 'error_handler.dart';

class DioInterceptor extends QueuedInterceptorsWrapper {
  final DioLogger _dioLogger = DioLogger();
  final TokenProvider _tokenProvider;
  final Dio _dio;

  DioInterceptor(this._tokenProvider, this._dio);

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.path == Urls.login || options.path == Urls.forgetPassword) {
      handler.next(options);
    } else {
      if (_tokenProvider.accessToken == null) {
        final tokenResponse = await _tokenProvider.fetchTokenFromServer();
        tokenResponse.fold(
          (accessToken) {
            options.headers['Authorization'] = 'Bearer $accessToken';
            handler.next(options);
          },
          (errorCode) {},
        );
      } else {
        options.headers['Authorization'] =
            'Bearer ${_tokenProvider.accessToken}';
        handler.next(options);
      }
    }
    if (!kReleaseMode) {
      _dioLogger.logRequest(options);
    }
  }

  @override
  void onError(
    DioError error,
    ErrorInterceptorHandler handler,
  ) async {
    if (!kReleaseMode) {
      _dioLogger.logError(error);
    }
    var options = error.response!.requestOptions;
    if (options.path == Urls.login || options.path == Urls.forgetPassword) {
      return handler.next(error);
    } else {
      if (error.response?.statusCode == ResponseCode.UNAUTHORISED) {
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
            options.headers['Authorization'] = 'Bearer $accessToken';
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
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (!kReleaseMode) {
      _dioLogger.logResponse(response);
    }
    handler.next(response);
  }
}
