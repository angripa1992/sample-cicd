import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/user/data/request_model/login_request_model.dart';
import 'package:klikit/modules/user/data/request_model/reset_link_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';

import '../../data/models/success_response.dart';
import '../../data/request_model/user_update_request_model.dart';

abstract class UserRepository{
  Future<Either<Failure,User>> login(LoginRequestModel params);
  Future<Either<Failure,SuccessResponse>> logout();
  Future<Either<Failure,SuccessResponse>> updateUserInfo(UserUpdateRequestModel params,int userID);
  Future<Either<Failure,SuccessResponse>> sendResetLink(ResetLinkRequestModel requestModel);
}