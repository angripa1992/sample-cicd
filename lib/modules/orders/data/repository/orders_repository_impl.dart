import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/network/network_connectivity.dart';
import 'package:klikit/modules/orders/data/datasource/orders_remote_datasource.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/data/models/attachment_image_file.dart';
import 'package:klikit/modules/orders/data/models/order_status_model.dart';
import 'package:klikit/modules/orders/data/models/webshop_order_details_model.dart';
import 'package:klikit/modules/orders/domain/entities/cancellation_reason.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart' as order;
import 'package:klikit/modules/orders/domain/entities/settings.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/modules/orders/edit_order/grab_order_update_request_model.dart';

import '../../../common/business_information_provider.dart';
import '../../../common/entities/source.dart';
import '../models/orders_model.dart';
import '../models/qris_payment_success_response.dart';

class OrderRepositoryImpl extends OrderRepository {
  final OrderRemoteDatasource _datasource;
  final NetworkConnectivity _connectivity;
  final BusinessInformationProvider _orderInformationProvider;

  OrderRepositoryImpl(this._datasource, this._connectivity, this._orderInformationProvider);

  @override
  Future<Either<Failure, order.Orders>> fetchOrder(Map<String, dynamic> params) async {
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
      } on DioException catch (error) {
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
      } on DioException catch (error) {
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
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> updateStatus(Map<String, dynamic> params) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updateOrderStatus(params);
        return Right(response);
      } on DioException catch (error) {
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
      } on DioException catch (error) {
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
      } on DioException catch (error) {
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
      } on DioException {
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
      orderSource = OrderSource(source.id, source.name, source.image, SourceTpe.source);
    } else {
      final provider = await _orderInformationProvider.findProviderById(providerId);
      orderSource = OrderSource(provider.id, provider.title, provider.logo, SourceTpe.provider);
    }
    return orderModel.toEntity(orderSource: orderSource);
  }

  @override
  Future<Either<Failure, ActionSuccess>> updatePaymentInfo(Map<String, dynamic> params) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updatePaymentInfo(params);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, QrisUpdatePaymentResponse>> updateQrisPaymentInfo(Map<String, dynamic> params) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updateQrisPaymentInfo(params);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, order.Order>> calculateGrabBill(OrderModel model) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.calculateGrabOrder(model);
        final order = await _extractOrderWithSource(response);
        return Right(order);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> updateGrabOrder(GrabOrderUpdateRequestModel model) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updateGrabOrder(model);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> findRider(int id) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.findRider(id);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, List<CancellationReason>>> fetchCancellationReason() async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchCancellationReasons();
        return Right(response.map((e) => e.toEntity()).toList());
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<WebShopOrderDetailsModel?> fetchOmsOrderById(String externalID) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchOmsOrderById(externalID);
        return response;
      } on DioException {
        return null;
      }
    } else {
      return null;
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> updatePrepTime(int orderID, Map<String, dynamic> params) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updatePrepTime(orderID, params);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> cancelRider(int orderID) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.cancelRider(orderID);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<List<AttachmentImageFile>> fetchAttachments(int orderID) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchAttachments(orderID);
        return response;
      } on DioException {
        return [];
      }
    } else {
      return [];
    }
  }
}
