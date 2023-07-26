import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/core/network/error_handler.dart';

import '../../../app/enums.dart';
import '../../../core/network/network_connectivity.dart';
import '../../../core/network/public_rest_client.dart';
import '../../../env/environment_variables.dart';
import '../model/consumer_protection.dart';
import '../model/consumer_protection_model.dart';

abstract class ConsumerProtectionRepository {
  Future<Either<Failure, ConsumerProtection?>> fetchConsumerProtection();

  Future<Either<Failure, ConsumerProtection?>>
      fetchConsumerProtectionFakeData();
}

class ConsumerProtectionRepositoryImpl extends ConsumerProtectionRepository {
  final NetworkConnectivity _connectivity;
  final EnvironmentVariables _environmentVariables;

  ConsumerProtectionRepositoryImpl(
      this._connectivity, this._environmentVariables);

  @override
  Future<Either<Failure, ConsumerProtection?>> fetchConsumerProtection() async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await PublicRestClient().request(
          '${_environmentVariables.baseUrl}/v1/countries/consumer-protection',
          Method.GET,
          null,
        );
        if (response.isEmpty) {
          return const Right(null);
        } else {
          return Right(ConsumerProtectionModel.fromJson(response).toEntity());
        }
      } on DioException catch (error) {
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
        final response = await PublicRestClient().request(
          'http://192.168.20.194:8088/v1/countries/consumer-protection',
          Method.GET,
          null,
        );
        if (response.isEmpty) {
          return const Right(null);
        } else {
          return Right(ConsumerProtectionModel.fromJson(response).toEntity());
        }
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
