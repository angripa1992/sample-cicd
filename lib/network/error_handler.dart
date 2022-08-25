import 'package:dio/dio.dart';
import 'package:klikit/network/failure.dart';
import 'package:klikit/network/response_code.dart';
import 'package:klikit/network/response_message.dart';

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
