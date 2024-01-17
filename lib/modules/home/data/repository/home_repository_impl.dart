import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/home/data/model/z_report_data_model.dart';
import 'package:klikit/modules/home/domain/entities/summary_data.dart';

import '../../../../core/network/network_connectivity.dart';
import '../../domain/repository/home_repository.dart';
import '../datasource/home_data_source.dart';

class HomeRepositoryImpl extends HomeRepository {
  final NetworkConnectivity _networkConnectivity;
  final HomeRemoteDataSource _dataSource;

  HomeRepositoryImpl(
    this._networkConnectivity,
    this._dataSource,
  );

  @override
  Future<Either<Failure, ZReportData>> fetchZReportData(Map<String, dynamic> params) async {
    if (await _networkConnectivity.hasConnection()) {
      try {
        final response = await _dataSource.fetchZReportData(params);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, OrderSummaryData>> fetchSummary(Map<String, dynamic> params) async {
    if (await _networkConnectivity.hasConnection()) {
      try {
        final response = await _dataSource.fetchSummaryData(params);
        return Right(response.toEntity());
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
