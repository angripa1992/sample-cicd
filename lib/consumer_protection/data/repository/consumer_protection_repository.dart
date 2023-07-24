import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/core/network/error_handler.dart';

import '../../../core/network/network_connectivity.dart';
import '../../../env/environment_variables.dart';
import '../model/consumer_protection.dart';
import '../model/consumer_protection_model.dart';

abstract class ConsumerProtectionRepository {
  Future<Either<Failure, ConsumerProtection?>> fetchConsumerProtection();

  Future<Either<Failure, ConsumerProtection?>>
      fetchConsumerProtectionFakeData();
}

class ConsumerProtectionRepositoryImpl extends ConsumerProtectionRepository {
  static final _dio = Dio();
  final NetworkConnectivity _connectivity;
  final EnvironmentVariables _environmentVariables;

  ConsumerProtectionRepositoryImpl(
      this._connectivity, this._environmentVariables);

  @override
  Future<Either<Failure, ConsumerProtection?>> fetchConsumerProtection() async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _dio.get(
            '${_environmentVariables.baseUrl}/v1/countries/consumer-protection');
        final Map<String, dynamic> responseData = response.data;
        if (responseData.isEmpty) {
          return const Right(null);
        } else {
          return Right(
              ConsumerProtectionModel.fromJson(responseData).toEntity());
        }
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ConsumerProtection?>>
      fetchConsumerProtectionFakeData() async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _dio
            .get('http://192.168.20.194:8088/v1/countries/consumer-protection');
        final Map<String, dynamic> responseData = response.data;
        if (responseData.isEmpty) {
          return const Right(null);
        } else {
          return Right(
              ConsumerProtectionModel.fromJson(responseData).toEntity());
        }
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
