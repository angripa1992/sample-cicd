import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/usecases/usecase.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/modules/user/domain/repositories/login_repository.dart';

import '../../data/request_model/login_request_model.dart';

class AuthenticateUser implements UseCase<User,LoginRequestModel>{
  final LoginRepository _repository;

  AuthenticateUser(this._repository);

  @override
  Future<Either<Failure, User>> call(LoginRequestModel params) {
    return _repository.login(params);
  }

}