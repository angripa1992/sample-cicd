import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/menu/data/datasource/menu_remote_datasource.dart';
import 'package:klikit/modules/menu/data/models/modifier_request_model.dart';
import 'package:klikit/modules/menu/domain/entities/brands.dart';
import 'package:klikit/modules/menu/domain/entities/modifier_disabled_response.dart';
import 'package:klikit/modules/menu/domain/entities/modifiers_group.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';
import 'package:klikit/modules/menu/domain/usecase/update_item.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../core/network/network_connectivity.dart';
import '../../domain/entities/menu/menu_data.dart';
import '../../domain/entities/menu/menu_out_of_stock.dart';
import '../../domain/usecase/fetch_menus.dart';
import '../mapper/mmv1_to_menu.dart';

class MenuRepositoryImpl extends MenuRepository {
  final MenuRemoteDatasource _datasource;
  final NetworkConnectivity _connectivity;

  MenuRepositoryImpl(this._datasource, this._connectivity);

  @override
  Future<Either<Failure, MenuBrands>> fetchMenuBrands(
      Map<String, dynamic> params) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchMenuBrands(params);
        return Right(response.toEntity());
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, MenuData>> fetchMenuV1(FetchMenuParams params) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchMenuV1(params);
        return Right(mapMMV1toMenu(response));
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, MenuOutOfStock>> updateItem(
      UpdateItemParam params) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updateItem(params);
        return Right(response.toEntity());
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> updateMenu(
    UpdateMenuParams params,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updateMenu(params);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, List<ModifiersGroup>>> fetchModifiersGroups(
    Map<String, dynamic> params,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchModifiersGroup(params);
        return Right(response.map((e) => e.toEntity()).toList());
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ModifierDisabledResponse>> disableModifier(
    ModifierRequestModel params,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.disableModifier(params);
        return Right(response.toEntity());
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> enableModifier(
    ModifierRequestModel params,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.enableModifier(params);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
