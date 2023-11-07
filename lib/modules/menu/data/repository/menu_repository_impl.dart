import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/menu/data/datasource/menu_remote_datasource.dart';
import 'package:klikit/modules/menu/data/models/modifier_request_model.dart';
import 'package:klikit/modules/menu/domain/entities/modifier/affected_modifier_response.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';
import 'package:klikit/modules/menu/domain/usecase/update_item_snooze.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu_enabled.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';

import '../../../../core/network/network_connectivity.dart';
import '../../domain/entities/menu/menu_data.dart';
import '../../domain/entities/menu/menu_out_of_stock.dart';
import '../../domain/entities/modifier/modifier_group.dart';
import '../../domain/usecase/fetch_menus.dart';
import '../../domain/usecase/ftech_modifier_groups.dart';
import '../mapper/modifierv1_to_modifier.dart';
import '../mapper/modifierv2_to_modifier.dart';

class MenuRepositoryImpl extends MenuRepository {
  final MenuRemoteDatasource _datasource;
  final NetworkConnectivity _connectivity;

  MenuRepositoryImpl(this._datasource, this._connectivity);

  @override
  Future<Either<Failure, MenuData>> fetchMenu(FetchMenuParams params) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchMenus(params);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, MenuOutOfStock>> updateItemSnooze(
    UpdateItemSnoozeParam params,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updateItemSnooze(params);
        return Right(response.toEntity());
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> updateMenuEnabled(
    UpdateMenuParams params,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updateMenuEnabled(params);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, List<ModifierGroup>>> fetchModifiersGroups(
    FetchModifierGroupParams params,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        if (SessionManager().menuV2Enabled()) {
          final response = await _datasource.fetchV2ModifiersGroup(params);
          return Right(mapModifierV2ToModifier(response));
        } else {
          final response = await _datasource.fetchV1ModifiersGroup(params);
          return Right(mapModifierV1ToModifier(response));
        }
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, AffectedModifierResponse>> disableModifier(
    ModifierRequestModel params,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.verifyDisableAffect(params);
        return Right(response.toEntity());
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> updateModifierEnabled(
    ModifierRequestModel params,
  ) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.updateModifierEnabled(params);
        return Right(response);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
