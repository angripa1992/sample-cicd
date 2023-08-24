import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/user/data/request_model/login_request_model.dart';
import 'package:klikit/modules/user/data/request_model/reset_link_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';

import '../../data/request_model/change_password_request_model.dart';
import '../../data/request_model/user_update_request_model.dart';
import '../entities/user_settings.dart';

abstract class UserRepository {
  Future<Either<Failure, User>> login(LoginRequestModel params);

  Future<Either<Failure, SuccessResponse>> logout();

  Future<Either<Failure, SuccessResponse>> updateUserInfo(
      UserUpdateRequestModel params, int userID);

  Future<Either<Failure, SuccessResponse>> sendResetLink(
      ResetLinkRequestModel requestModel);

  Future<Either<Failure, SuccessResponse>> changePassword(
      ChangePasswordRequestModel requestModel);

  Future<Either<Failure, SuccessResponse>> changeSettings(
      Map<String, dynamic> params);

  Future<Either<Failure, UserSettings>> getUserSettings(int userId);
}
