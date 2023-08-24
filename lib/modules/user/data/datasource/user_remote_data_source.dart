import 'package:dio/dio.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/modules/user/data/models/success_response.dart';
import 'package:klikit/modules/user/data/request_model/change_password_request_model.dart';
import 'package:klikit/modules/user/data/request_model/login_request_model.dart';
import 'package:klikit/modules/user/data/request_model/reset_link_request_model.dart';
import 'package:klikit/modules/user/data/request_model/user_update_request_model.dart';

import '../../../../core/network/rest_client.dart';
import '../models/user_model.dart';
import '../models/user_settings_model.dart';

abstract class UserRemoteDataSource {
  Future<UserModel> login(LoginRequestModel params);

  Future<SuccessResponseModel> logout();

  Future<SuccessResponseModel> updateUserInfo(
      UserUpdateRequestModel params, int userID);

  Future<SuccessResponseModel> sendResetLink(
      ResetLinkRequestModel requestModel);

  Future<SuccessResponseModel> changePassword(
      ChangePasswordRequestModel requestModel);

  Future<SuccessResponseModel> changeUserSetting(Map<String, dynamic> params);

  Future<UserSettingsModel> getUserSettings(int userId);
}

class UserRemoteDataSourceImpl extends UserRemoteDataSource {
  final RestClient _restClient;

  UserRemoteDataSourceImpl(this._restClient);

  @override
  Future<UserModel> login(LoginRequestModel params) async {
    try {
      final response = await _restClient.request(Urls.login, Method.POST, params.toJson());
      return UserModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<SuccessResponseModel> logout() async {
    try {
      final response =
          await _restClient.request(Urls.logout, Method.POST, null);
      return SuccessResponseModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<SuccessResponseModel> updateUserInfo(
      UserUpdateRequestModel params, int userID) async {
    try {
      final response = await _restClient.request(
          '${Urls.userUpdate}/$userID', Method.PATCH, params.toJson());
      return SuccessResponseModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<SuccessResponseModel> sendResetLink(
      ResetLinkRequestModel requestModel) async {
    try {
      final response = await _restClient.request(
          Urls.forgetPassword, Method.POST, requestModel.toJson());
      return SuccessResponseModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<SuccessResponseModel> changePassword(
      ChangePasswordRequestModel requestModel) async {
    try {
      final response = await _restClient.request(
          Urls.changePassword, Method.POST, requestModel.toJson());
      return SuccessResponseModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<SuccessResponseModel> changeUserSetting(
      Map<String, dynamic> params) async {
    try {
      final response =
          await _restClient.request(Urls.userSettings, Method.POST, params);
      return SuccessResponseModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }

  @override
  Future<UserSettingsModel> getUserSettings(int userId) async {
    try {
      final response = await _restClient.request(
          '${Urls.userSettings}/$userId', Method.GET, null);
      return UserSettingsModel.fromJson(response);
    } on DioException {
      rethrow;
    }
  }
}
