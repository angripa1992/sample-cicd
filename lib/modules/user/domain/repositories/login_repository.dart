import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/user/data/request_model/login_request_model.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';

abstract class LoginRepository{
  Future<Either<Failure,User>> login(LoginRequestModel params);
}