import 'package:equatable/equatable.dart';

import '../../../../../core/network/error_handler.dart';
import '../../../domain/entities/user.dart';

abstract class LoginState extends Equatable {
  @override
  List<Object> get props => [];
}

class LoginStateEmpty extends LoginState {}

class LoginStateLoading extends LoginState {}

class LoginStateSuccess extends LoginState {
  final User user;

  LoginStateSuccess(this.user);

  @override
  List<Object> get props => [user];
}

class LoginStateError extends LoginState {
  final Failure failure;

  LoginStateError(this.failure);

  @override
  List<Object> get props => [failure];
}
