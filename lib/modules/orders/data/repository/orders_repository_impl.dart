import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/network/network_connectivity.dart';
import 'package:klikit/modules/orders/data/datasource/orders_remote_datasource.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/data/models/order_status_model.dart';
import 'package:klikit/modules/orders/data/request_models/brand_request_model.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/modules/orders/domain/entities/busy_mode.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart' as order;
import 'package:klikit/modules/orders/domain/entities/provider.dart';
import 'package:klikit/modules/orders/domain/entities/settings.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDatasource _datasource;
  final NetworkConnectivity _connectivity;

  OrderRepositoryImpl(this._datasource, this._connectivity);

  @override
  Future<Either<Failure, Brands>> fetchBrand(
      BrandRequestModel requestModel) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchBrand(requestModel);
        return Right(response.toEntity());
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, order.Orders>> fetchOrder(
      Map<String, dynamic> params) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchOrder(params);
        return Right(response.toEntity());
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, List<OrderStatusModel>>> fetchOrderStatus() async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchOrderStatus();
        return Right(response);
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, List<Provider>>> fetchProvider(
      Map<String, dynamic> param) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchProvider(param);
        final data = response.map((e) => e.toEntity()).toList();
        return Right(data);
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, Settings>> fetchSettings(int id) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchSettings(id);
        return Right(response.toEntity());
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, BusyModeGetResponse>> isBusy(
    Map<String, dynamic> params,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.isBusy(params);
        return Right(response.toEntity());
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, BusyModePostResponse>> updateBusyMode(
    Map<String, dynamic> params,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updateBusyMode(params);
        return Right(response.toEntity());
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> updateStatus(
      Map<String, dynamic> params) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updateOrderStatus(params);
        return Right(response);
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> addComment(
    Map<String, dynamic> params,
    int orderID,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.addComment(params, orderID);
        return Right(response);
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> deleteComment(int orderID) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.deleteComment(orderID);
        return Right(response);
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<order.Order?> fetchOrderById(int id) async{
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchOrderById(id);
        return response.toEntity();
      } on DioError {
        return null;
      }
    } else {
      return null;
    }
  }
}
