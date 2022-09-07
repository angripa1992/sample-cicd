import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/user/data/request_model/reset_link_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/domain/repositories/user_repository.dart';

class SentResetLink extends UseCase<SuccessResponse,ResetLinkRequestModel>{
  final UserRepository _repository;

  SentResetLink(this._repository);

  @override
  Future<Either<Failure, SuccessResponse>> call(ResetLinkRequestModel params) {
    return _repository.sendResetLink(params);
  }

}