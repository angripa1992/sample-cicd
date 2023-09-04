import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/network/rest_client.dart';
import 'package:klikit/core/network/urls.dart';

import '../app/session_manager.dart';
import '../core/provider/device_information_provider.dart';

class FcmTokenManager {
  final RestClient _restClient;
  final DeviceInfoProvider _deviceInformationProvider;

  FcmTokenManager(this._restClient, this._deviceInformationProvider);

  Future<Either<Failure, bool>> registerToken(String fcmToken) async {
    final platform = _deviceInformationProvider.platformName();
    final String os = await _deviceInformationProvider.getOsVersion();
    final String model = await _deviceInformationProvider.getDeviceModel();
    final userID = SessionManager().user().id;
    final branchID = SessionManager().user().branchId;
    final deviceInfo = '$platform/0s-$os/model-$model';
    final uuid = md5.convert(utf8.encode('$userID/$branchID/$deviceInfo/$fcmToken')).toString();

    final Map<String, dynamic> params = {};
    params['user_id'] = userID;
    params['token'] = fcmToken;
    params['platform'] = platform;
    params['app_type'] = 2;
    params['branch_id'] = branchID;
    params['uuid'] = uuid;
    try {
      await _restClient.request(Urls.tokenRegistration, Method.POST, params);
      return const Right(true);
    } on DioException catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
