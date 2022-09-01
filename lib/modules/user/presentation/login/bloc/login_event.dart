import 'package:equatable/equatable.dart';

import '../../../data/request_model/login_request_model.dart';

abstract class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginEventAuthenticate extends LoginEvent {
  final LoginRequestModel loginParams;

  LoginEventAuthenticate(this.loginParams);
}
