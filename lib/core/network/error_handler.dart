import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

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

  ErrorHandler.handleInternetConnection() {
    failure = Failure(ResponseCode.NO_INTERNET_CONNECTION,ResponseMessage.NO_INTERNET_CONNECTION);
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
        return _handleResponseError(error);
    }
  }

  Failure _handleResponseError(DioError error){
    try{
      final message = error.response?.data['message'];
      return Failure(ResponseCode.RESPONSE, message);
    }catch(error){
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
  static const int RESPONSE = 401;
  static const int NOT_FOUND = 404;
  static const int UPDATE_REQUIRED = 418;
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
  static String NO_CONTENT = AppStrings.noContent.tr();
  static String BAD_REQUEST = AppStrings.badRequestError.tr();
  static String FORBIDDEN = AppStrings.forbiddenError.tr();
  static String UNAUTHORISED = AppStrings.unauthorizedError.tr();
  static String NOT_FOUND = AppStrings.notFoundError.tr();
  static String INTERNAL_SERVER_ERROR = AppStrings.internalServerError.tr();
  static String DEFAULT = AppStrings.defaultError.tr();
  static String CONNECT_TIMEOUT = AppStrings.timeoutError.tr();
  static String CANCEL = AppStrings.defaultError.tr();
  static String RECEIVE_TIMEOUT = AppStrings.timeoutError.tr();
  static String SEND_TIMEOUT = AppStrings.timeoutError.tr();
  static String CACHE_ERROR = AppStrings.defaultError.tr();
  static String NO_INTERNET_CONNECTION = AppStrings.noInternetError.tr();
}