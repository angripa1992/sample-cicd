import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/network/network_connectivity.dart';
import 'package:klikit/modules/orders/data/datasource/orders_remote_datasource.dart';
import 'package:klikit/modules/orders/data/request_models/brand_request_model.dart';
import 'package:klikit/modules/orders/data/request_models/order_request_model.dart';
import 'package:klikit/modules/orders/data/request_models/provider_request_model.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/entities/order_status.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/modules/orders/domain/entities/settings.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDatasource _datasource;
  final NetworkConnectivity _connectivity;

  OrderRepositoryImpl(this._datasource, this._connectivity);

  @override
  Future<Either<Brands, Failure>> fetchBrand(
      BrandRequestModel requestModel) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchBrand(requestModel);
        return Left(response.toEntity());
      } on DioError catch (error) {
        return Right(ErrorHandler.handle(error).failure);
      }
    } else {
      return Right(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Orders, Failure>> fetchOrder(
      OrderRequestModel requestModel) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchOrder(requestModel);
        return Left(response.toEntity());
      } on DioError catch (error) {
        return Right(ErrorHandler.handle(error).failure);
      }
    } else {
      return Right(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<OrderStatus, Failure>> fetchOrderStatus() async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchOrderStatus();
        return Left(response.toEntity());
      } on DioError catch (error) {
        return Right(ErrorHandler.handle(error).failure);
      }
    } else {
      return Right(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Provider, Failure>> fetchProvider(
      ProviderRequestModel requestModel) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchProvider(requestModel);
        return Left(response.toEntity());
      } on DioError catch (error) {
        return Right(ErrorHandler.handle(error).failure);
      }
    } else {
      return Right(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Settings, Failure>> fetchSettings(int id) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchSettings(id);
        return Left(response.toEntity());
      } on DioError catch (error) {
        return Right(ErrorHandler.handle(error).failure);
      }
    } else {
      return Right(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
