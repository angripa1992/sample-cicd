import 'package:dio/dio.dart';

import '../../resources/strings.dart';


class Failure {
  int code;
  String message;

  Failure(this.code, this.message);
}

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioError) {
      failure = _handleError(error);
    } else {
      failure = Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
    }
  }

  Failure _handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return Failure(
            ResponseCode.CONNECT_TIMEOUT, ResponseMessage.CONNECT_TIMEOUT);
      case DioErrorType.sendTimeout:
        return Failure(ResponseCode.SEND_TIMEOUT, ResponseMessage.SEND_TIMEOUT);
      case DioErrorType.receiveTimeout:
        return Failure(
            ResponseCode.RECEIVE_TIMEOUT, ResponseMessage.RECEIVE_TIMEOUT);
      case DioErrorType.cancel:
        return Failure(ResponseCode.CANCEL, ResponseMessage.CANCEL);
      case DioErrorType.other:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
      case DioErrorType.response:
        return Failure(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
    }
  }
}


class ResponseCode {
  static const int SUCCESS = 200;
  static const int NO_CONTENT = 201;
  static const int BAD_REQUEST = 400;
  static const int FORBIDDEN = 403;
  static const int UNAUTHORISED = 401;
  static const int NOT_FOUND = 404;
  static const int INTERNAL_SERVER_ERROR = 500;
  // local status code
  static const int DEFAULT = -1;
  static const int CONNECT_TIMEOUT = -2;
  static const int CANCEL = -3;
  static const int RECEIVE_TIMEOUT = -4;
  static const int SEND_TIMEOUT = -5;
  static const int CACHE_ERROR = -6;
  static const int NO_INTERNET_CONNECTION = -7;
}

class ResponseMessage {
  static const String NO_CONTENT = AppStrings.noContent;
  static const String BAD_REQUEST = AppStrings.badRequestError;
  static const String FORBIDDEN = AppStrings.forbiddenError;
  static const String UNAUTHORISED = AppStrings.unauthorizedError;
  static const String NOT_FOUND = AppStrings.notFoundError;
  static const String INTERNAL_SERVER_ERROR = AppStrings.internalServerError;
  static const String DEFAULT = AppStrings.defaultError;
  static const String CONNECT_TIMEOUT = AppStrings.timeoutError;
  static const String CANCEL = AppStrings.defaultError;
  static const String RECEIVE_TIMEOUT = AppStrings.timeoutError;
  static const String SEND_TIMEOUT = AppStrings.timeoutError;
  static const String CACHE_ERROR = AppStrings.defaultError;
  static const String NO_INTERNET_CONNECTION = AppStrings.noInternetError;
}