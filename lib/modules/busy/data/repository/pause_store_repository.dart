import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/busy/domain/entity/pause_store_data.dart';
import 'package:klikit/modules/busy/domain/entity/pause_store_update_response.dart';

import '../../../../core/network/network_connectivity.dart';
import '../../domain/repository/pause_store_repository.dart';
import '../datasource/pause_store_datasource.dart';

class PauseStoreRepositoryImpl extends PauseStoreRepository {
  final NetworkConnectivity _networkConnectivity;
  final PauseStoreRemoteDataSource _dataSource;

  PauseStoreRepositoryImpl(this._networkConnectivity, this._dataSource);

  @override
  Future<Either<Failure, PauseStoresData>> fetchPauseStoresData(int branchID) async {
    if (await _networkConnectivity.hasConnection()) {
      try {
        final response = await _dataSource.fetchPausedStore(branchID);
        return Right(response.toEntity());
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, PauseStoreUpdateResponse>> updatePauseStore(Map<String, dynamic> params) async {
    if (await _networkConnectivity.hasConnection()) {
      try {
        final response = await _dataSource.updatePauseStore(params);
        return Right(response.toEntity());
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
