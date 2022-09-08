import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/user/data/request_model/change_password_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/domain/repositories/user_repository.dart';

class ChangePassword extends UseCase<SuccessResponse,ChangePasswordRequestModel>{
  final UserRepository _repository;

  ChangePassword(this._repository);

  @override
  Future<Either<Failure, SuccessResponse>> call(ChangePasswordRequestModel params) {
   return _repository.changePassword(params);
  }

}