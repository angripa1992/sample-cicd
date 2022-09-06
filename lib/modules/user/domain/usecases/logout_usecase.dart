import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';

import '../repositories/user_repository.dart';

class LogoutUser extends UseCase<SuccessResponse,NoParams>{
  final UserRepository _repository;

  LogoutUser(this._repository);

  @override
  Future<Either<Failure, SuccessResponse>> call(NoParams params) {
    return _repository.logout();
  }

}