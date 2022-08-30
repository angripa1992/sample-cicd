import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/modules/user/data/request_model/login_request_model.dart';

import '../../../../core/network/rest_client.dart';
import '../models/user_model.dart';

abstract class LoginRemoteDataSource{
  Future<UserModel> login(LoginRequestModel params);
}

class LoginRemoteDataSourceImpl extends LoginRemoteDataSource{
  final RestClient _restClient;

  LoginRemoteDataSourceImpl(this._restClient);

  @override
  Future<UserModel> login(LoginRequestModel params) async{
    try{
      final response = await _restClient.request(Urls.login, Method.POST, params.toJson());
      return UserModel.fromJson(response);
    }on DioError{
      rethrow;
    }
  }

}