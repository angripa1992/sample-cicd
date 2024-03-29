import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/modules/add_order/data/models/applied_promo.dart';
import 'package:klikit/modules/add_order/data/models/placed_order_response.dart';
import 'package:klikit/modules/add_order/data/models/request/billing_request.dart';
import 'package:klikit/modules/add_order/data/models/request/place_order_data_request.dart';
import 'package:klikit/modules/add_order/data/models/request/webshop_calculate_bill_payload.dart';
import 'package:klikit/modules/add_order/data/models/request/webshop_pace_order_payload.dart';
import 'package:klikit/modules/add_order/data/models/update_webshop_order_response.dart';
import 'package:klikit/modules/add_order/domain/entities/cart_bill.dart';
import 'package:klikit/modules/add_order/domain/entities/modifier/item_modifier_group.dart';
import 'package:klikit/modules/add_order/domain/entities/order_source.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_branch_info.dart';

import '../../../../core/network/error_handler.dart';
import '../../../../core/network/network_connectivity.dart';
import '../../data/datasource/add_order_datasource.dart';
import '../../domain/repository/add_order_repository.dart';

class AddOrderRepositoryImpl extends AddOrderRepository {
  final AddOrderDatasource _datasource;
  final NetworkConnectivity _connectivity;

  AddOrderRepositoryImpl(this._datasource, this._connectivity);

  @override
  Future<Either<Failure, List<MenuItemModifierGroup>>> fetchModifiers({
    required int itemId,
    required int sectionID,
    required int categoryID,
    required MenuBranchInfo branchInfo,
    required int type,
  }) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchModifiers(
          itemID: itemId,
          sectionID: sectionID,
          categoryID: categoryID,
          branchInfo: branchInfo,
          type: type,
        );
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, CartBill>> calculateBill({
    required BillingRequestModel model,
  }) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.calculateBill(model: model);
        return Right(response.toEntity());
      } on DioException catch (error) {
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
      } on DioException catch (error) {
        return Future.error(error);
      }
    } else {
      return Future.error(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, PlacedOrderResponse>> placeOrder({
    required PlaceOrderDataRequestModel body,
  }) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.placeOrder(body);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, List<Promo>>> fetchPromos(
    Map<String, dynamic> params,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchPromos(params);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, CartBill>> webShopCalculateBill({required WebShopCalculateBillPayload payload}) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.webShopCalculateBill(model: payload);
        return Right(response.toCartBill());
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, UpdateWebShopOrderResponse>> updateWebShopOrder(int id, WebShopPlaceOrderPayload payload) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updateWebShopOrder(id, payload);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
