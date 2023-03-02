import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/network/network_connectivity.dart';
import 'package:klikit/modules/orders/data/datasource/orders_remote_datasource.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/data/models/order_status_model.dart';
import 'package:klikit/modules/orders/domain/entities/busy_mode.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart' as order;
import 'package:klikit/modules/orders/domain/entities/settings.dart';
import 'package:klikit/modules/orders/domain/entities/source.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

import '../../provider/order_information_provider.dart';
import '../models/orders_model.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDatasource _datasource;
  final NetworkConnectivity _connectivity;
  final OrderInformationProvider _orderInformationProvider;

  OrderRepositoryImpl(
      this._datasource, this._connectivity, this._orderInformationProvider);

  @override
  Future<Either<Failure, order.Orders>> fetchOrder(
      Map<String, dynamic> params) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchOrder(params);
        if (response.orders == null) {
          return Right(response.emptyObject());
        }
        final List<order.Order> orders = [];
        for (var orderModel in response.orders!) {
          final orderWithSource = await _extractOrderWithSource(orderModel);
          orders.add(orderWithSource);
        }
        return Right(response.toEntity(orders));
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
  Future<order.Order?> fetchOrderById(int id) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchOrderById(id);
        return _extractOrderWithSource(response);
      } on DioError {
        return null;
      }
    } else {
      return null;
    }
  }

  Future<order.Order> _extractOrderWithSource(OrderModel orderModel) async {
    final sourceId = orderModel.source.orZero();
    final providerId = orderModel.providerId.orZero();
    late OrderSource orderSource;
    if (sourceId > 0) {
      final source = await _orderInformationProvider.findSourceById(sourceId);
      orderSource =
          OrderSource(source.id, source.name, source.image, SourceTpe.source);
    } else {
      final provider =
          await _orderInformationProvider.findProviderById(providerId);
      orderSource = OrderSource(
          provider.id, provider.title, provider.logo, SourceTpe.provider);
    }
    return orderModel.toEntity(orderSource: orderSource);
  }
}
