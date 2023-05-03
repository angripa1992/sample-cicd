import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/modules/add_order/data/models/billing_request.dart';
import 'package:klikit/modules/add_order/data/models/place_order_data.dart';
import 'package:klikit/modules/add_order/data/models/placed_order_response.dart';
import 'package:klikit/modules/add_order/domain/entities/billing_response.dart';
import 'package:klikit/modules/add_order/domain/entities/item_modifier_group.dart';
import 'package:klikit/modules/add_order/domain/entities/order_source.dart';

import '../../../../core/network/error_handler.dart';
import '../../../../core/network/network_connectivity.dart';
import '../../../menu/domain/entities/menues.dart';
import '../../data/datasource/add_order_datasource.dart';
import '../../domain/repository/add_order_repository.dart';

class AddOrderRepositoryImpl extends AddOrderRepository {
  final AddOrderDatasource _datasource;
  final NetworkConnectivity _connectivity;

  AddOrderRepositoryImpl(this._datasource, this._connectivity);

  @override
  Future<Either<Failure, MenusData>> fetchMenus({
    required int branchId,
    required int brandId,
  }) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response =
            await _datasource.fetchMenus(branchId: branchId, brandId: brandId);
        return Right(response.toEntity());
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, List<ItemModifierGroup>>> fetchModifiers(
      {required int itemId}) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchModifiers(itemId: itemId);
        return Right(response.map((e) => e.toEntity()).toList());
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, CartBill>> calculateBill(
      {required BillingRequestModel model}) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.calculateBill(model: model);
        return Right(response.toEntity());
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<List<AddOrderSourceType>> fetchSources() async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchSources();
        return response.map((e) => e.toEntity()).toList();
      } on DioError catch (error) {
        return Future.error(error);
      }
    } else {
      return Future.error(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, PlacedOrderResponse>> placeOrder(
      {required PlaceOrderDataModel body}) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.placeOrder(body);
        return Right(response);
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
