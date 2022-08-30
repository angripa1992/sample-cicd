import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/network/network_connectivity.dart';
import 'package:klikit/modules/user/data/datasource/login_remote_data_source.dart';
import 'package:klikit/modules/user/data/maper/user_login_mapper.dart';
import 'package:klikit/modules/user/data/request_model/login_request_model.dart';
import 'package:klikit/modules/user/domain/entities/user.dart';
import 'package:klikit/modules/user/domain/repositories/login_repository.dart';

class LoginRepositoryImpl extends LoginRepository{
  final LoginRemoteDataSource _loginRemoteDataSource;
  final NetworkConnectivity _networkConnectivity;

  LoginRepositoryImpl(this._networkConnectivity, this._loginRemoteDataSource,);

  @override
  Future<Either<Failure, User>> login(LoginRequestModel params) async{
    if(await _networkConnectivity.hasConnection()){
      try{
        final response = await _loginRemoteDataSource.login(params);
        return Right(mapUserModelToUser(response));
      }on DioError catch (error){
        return Left(ErrorHandler.handle(error).failure);
      }
    }else{
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

}