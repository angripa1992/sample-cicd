import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/user/data/request_model/user_update_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';

import '../repositories/user_repository.dart';

class UpdateUserInfo extends UseCase<SuccessResponse,UpdateUserInfoParams>{
  final UserRepository _repository;

  UpdateUserInfo(this._repository);

  @override
  Future<Either<Failure, SuccessResponse>> call(UpdateUserInfoParams params) {
    return _repository.updateUserInfo(params.updateRequestModel, params.userID);
  }

}

class UpdateUserInfoParams extends NoParams{
  final UserUpdateRequestModel updateRequestModel;
  final int userID;

  UpdateUserInfoParams(this.updateRequestModel, this.userID);
}