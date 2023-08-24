import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/orders/data/request_models/brand_request_model.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/modules/orders/domain/entities/payment_info.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/modules/orders/domain/entities/source.dart';

import '../../../../core/network/network_connectivity.dart';
import '../../domain/repository/order_info_provider_repo.dart';
import '../datasource/orders_remote_datasource.dart';

class OrderInfoProviderRepoImpl extends OrderInfoProviderRepo {
  final OrderRemoteDatasource _datasource;
  final NetworkConnectivity _connectivity;

  OrderInfoProviderRepoImpl(this._datasource, this._connectivity);

  @override
  Future<Either<Failure, List<Provider>>> fetchProvider(
      Map<String, dynamic> param) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchProvider(param);
        final data = response.map((e) => e.toEntity()).toList();
        return Right(data);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, Brands>> fetchBrand(
      BrandRequestModel requestModel) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchBrand(requestModel);
        return Right(response.toEntity());
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, List<Sources>>> fetchSources() async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchSources();
        final data = response.map((e) => e.toEntity()).toList();
        return Right(data);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, List<PaymentMethod>>> fetchPaymentMethods() async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchPaymentMethods();
        final data = response.map((e) => e.toEntity()).toList();
        return Right(data);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, List<PaymentStatus>>> fetchPaymentSources() async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchPaymentStatus();
        final data = response.map((e) => e.toEntity()).toList();
        return Right(data);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
