import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/network/rest_client.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/printer/data/printer_setting.dart';

import '../../core/network/network_connectivity.dart';

abstract class PrinterSettingRepository {
  Future<Either<Failure, List<PrinterSetting>>> getPrinterSettings(int branchId);

  Future<Either<Failure, ActionSuccess>> updatePrinterSettings(Map<String, dynamic> params);
}

class PrinterSettingRepositoryImpl extends PrinterSettingRepository {
  final NetworkConnectivity _connectivity;
  final RestClient _restClient;

  PrinterSettingRepositoryImpl(this._connectivity, this._restClient);

  @override
  Future<Either<Failure, List<PrinterSetting>>> getPrinterSettings(int branchId) async {
    if (await _connectivity.hasConnection()) {
      try {
        final List<dynamic> response = await _restClient.request(
          '${Urls.printerSettings}/$branchId',
          Method.GET,
          null,
        );
        final List<PrinterSetting> settings = response.map((e) => PrinterSettingModel.fromJson(e).toEntity()).toList();
        return Right(settings);
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }

  @override
  Future<Either<Failure, ActionSuccess>> updatePrinterSettings(Map<String, dynamic> params) async {
    if (await _connectivity.hasConnection()) {
      try {
        final response = await _restClient.request(Urls.printerSettings, Method.POST, params);
        return Right(ActionSuccess.fromJson(response));
      } on DioException catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      return Left(ErrorHandler.handleInternetConnection().failure);
    }
  }
}
