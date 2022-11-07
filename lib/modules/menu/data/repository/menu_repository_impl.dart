import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/menu/data/datasource/menu_remote_datasource.dart';
import 'package:klikit/modules/menu/domain/entities/brands.dart';
import 'package:klikit/modules/menu/domain/entities/menues.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';

import '../../../../core/network/network_connectivity.dart';

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
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, MenusData>> fetchMenus(int brandID) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _datasource.fetchMenus(brandID);
        return Right(response.toEntity());
      } on DioError catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
