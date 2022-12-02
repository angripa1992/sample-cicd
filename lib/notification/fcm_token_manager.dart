import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/network/rest_client.dart';
import 'package:klikit/core/network/urls.dart';
import 'package:klikit/notification/fcm_service.dart';

import '../app/app_preferences.dart';
import '../core/provider/device_information_provider.dart';

class FcmTokenManager {
  final RestClient _restClient;
  final AppPreferences _appPreferences;
  final DeviceInfoProvider _deviceInformationProvider;

  FcmTokenManager(this._restClient, this._appPreferences, this._deviceInformationProvider);

  Future<Either<Failure,bool>> registerToken(String fcmToken) async{
    final String? deviceId = await _deviceInformationProvider.FID();
    final Map<String,dynamic> params = {};
    params['user_id'] = _appPreferences.getUser().userInfo.id;
    params['token'] = fcmToken;
    params['platform'] = _deviceInformationProvider.platformName();
    params['app_type'] = 2;
    params['branch_id'] = _appPreferences.getUser().userInfo.branchId;
    if(deviceId != null){
      params['uuid'] = deviceId;
    }
    try {
      final response = await _restClient.request(Urls.tokenRegistration, Method.POST, params);
      return const Right(true);
    } on DioError catch (error) {
      return Left(ErrorHandler.handle(error).failure);
    }
  }
}
