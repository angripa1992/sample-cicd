import 'package:dio/dio.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/network/token_provider.dart';
import 'package:klikit/core/network/urls.dart';

import '../../app/di.dart';
import '../../app/enums.dart';
import '../../environment_variables.dart';
import '../provider/device_information_provider.dart';
import '../utils/app_update_manager.dart';
import 'dio_logger.dart';
import 'error_handler.dart';

class RestClient {
  static const String contentType = 'Content-Type';
  static const String authorization = 'Authorization';
  static const String deviceAgent = 'Device-Agent';
  static const String appAgent = 'Mobile-App-Agent';
  static const String appVersion = 'App-Version';
  static const String appVersionName = 'App-Version-Name';
  final TokenProvider _tokenProvider;
  final DioLogger _dioLogger = DioLogger();
  final Dio _dio = Dio();

  RestClient(this._tokenProvider) {
    _initInterceptor();
  }

  String _token(String? accessToken) => 'Bearer $accessToken';

  void _addHeader() async {
    final deviceInfoProvider = getIt.get<DeviceInfoProvider>();
    final versionCode = await deviceInfoProvider.versionCode();
    final versionName = await deviceInfoProvider.versionName();
    _dio.options.headers[contentType] = 'application/json';
    _dio.options.headers[appAgent] = 'enterprise/${deviceInfoProvider.platformName()}/$versionCode';
    _dio.options.headers[appVersion] = versionCode;
    _dio.options.headers[appVersionName] = versionName.removeDot();
  }

  void _initInterceptor() {
    _dioLogger.setLogStatus(LogStatus.OPEN);
    _dio.options.baseUrl = getIt.get<EnvironmentVariables>().baseUrl;
    _addHeader();
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          if (options.path == Urls.login ||
              options.path == Urls.forgetPassword) {
            handler.next(options);
          } else {
            if (_tokenProvider.getAccessToken() == null) {
              final tokenResponse = await _tokenProvider.fetchTokenFromServer();
              tokenResponse.fold(
                (accessToken) {
                  options.headers[authorization] = _token(accessToken);
                  handler.next(options);
                },
                (errorCode) {
                  SessionManager().logout();
                },
              );
            } else {
              options.headers[authorization] =
                  _token(_tokenProvider.getAccessToken());
              handler.next(options);
            }
          }
          _dioLogger.logRequest(options);
        },
        onError: (error, handler) async {
          _dioLogger.logError(error);
          var options = error.response!.requestOptions;
          if (error.response?.statusCode == ResponseCode.UPDATE_REQUIRED) {
            AppUpdateManager().showAppUpdateDialog();
            return handler.reject(error);
          }
          if (options.path == Urls.login ||
              options.path == Urls.forgetPassword) {
            return handler.next(error);
          } else {
            if (error.response?.statusCode == ResponseCode.UNAUTHORISED) {
              if (_token(_tokenProvider.getAccessToken()) !=
                  options.headers[authorization]) {
                options.headers[authorization] = _token(_tokenProvider.getAccessToken());
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
                  options.headers[authorization] = _token(accessToken);
                  _dio.fetch(options).then(
                    (r) => handler.resolve(r),
                    onError: (e) {
                      handler.reject(e);
                    },
                  );
                },
                (errorCode) {
                  if (errorCode == ResponseCode.UNAUTHORISED) {
                    return;
                  }
                  handler.reject(error);
                },
              );
              return;
            }
          }
          return handler.next(error);
        },
        onResponse: (response, handler) {
          _dioLogger.logResponse(response);
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
