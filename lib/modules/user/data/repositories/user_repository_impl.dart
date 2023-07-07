import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/network/network_connectivity.dart';
import 'package:klikit/modules/user/data/datasource/user_remote_data_source.dart';
import 'package:klikit/modules/user/data/maper/user_mapper.dart';
import 'package:klikit/modules/user/data/request_model/change_password_request_model.dart';
import 'package:klikit/modules/user/data/request_model/login_request_model.dart';
import 'package:klikit/modules/user/data/request_model/reset_link_request_model.dart';
import 'package:klikit/modules/user/data/request_model/user_update_request_model.dart';
import 'package:klikit/modules/user/domain/entities/success_response.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/modules/user/domain/entities/user_settings.dart';
import 'package:klikit/modules/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserRemoteDataSource _userRemoteDataSource;
  final NetworkConnectivity _networkConnectivity;

  UserRepositoryImpl(
    this._networkConnectivity,
    this._userRemoteDataSource,
  );

  @override
  Future<Either<Failure, User>> login(LoginRequestModel params) async {
    if (await _networkConnectivity.hasConnection()) {
      try {
        final response = await _userRemoteDataSource.login(params);
        return Right(mapUserModelToUser(response));
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> logout() async {
    if (await _networkConnectivity.hasConnection()) {
      try {
        final response = await _userRemoteDataSource.logout();
        return Right(mapSuccessResponse(response));
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> updateUserInfo(
      UserUpdateRequestModel params, int userID) async {
    if (await _networkConnectivity.hasConnection()) {
      try {
        final response =
            await _userRemoteDataSource.updateUserInfo(params, userID);
        return Right(mapSuccessResponse(response));
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> sendResetLink(
      ResetLinkRequestModel requestModel) async {
    if (await _networkConnectivity.hasConnection()) {
      try {
        final response =
            await _userRemoteDataSource.sendResetLink(requestModel);
        return Right(mapSuccessResponse(response));
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> changePassword(
      ChangePasswordRequestModel requestModel) async {
    if (await _networkConnectivity.hasConnection()) {
      try {
        final response =
            await _userRemoteDataSource.changePassword(requestModel);
        return Right(mapSuccessResponse(response));
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, SuccessResponse>> changeSettings(
      Map<String, dynamic> params) async {
    if (await _networkConnectivity.hasConnection()) {
      try {
        final response = await _userRemoteDataSource.changeUserSetting(params);
        return Right(mapSuccessResponse(response));
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, UserSettings>> getUserSettings(int userId) async {
    if (await _networkConnectivity.hasConnection()) {
      try {
        final response = await _userRemoteDataSource.getUserSettings(userId);
        return Right(response.toEntity());
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
