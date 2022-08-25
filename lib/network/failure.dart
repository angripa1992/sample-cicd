import 'package:klikit/network/response_code.dart';
import 'package:klikit/network/response_message.dart';

class Failure {
  int code;
  String message;

  Failure(this.code, this.message);
}

class DefaultFailure extends Failure {
  DefaultFailure() : super(ResponseCode.DEFAULT, ResponseMessage.DEFAULT);
}
