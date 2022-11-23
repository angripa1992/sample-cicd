import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';

class DeviceInformationProvider{
  final _deviceInfo = DeviceInfoPlugin();

  Future<String?> getDeviceId() async{
    if(Platform.isIOS){
      final iosInfo = await _deviceInfo.iosInfo;
      return iosInfo.identifierForVendor;
    }else{
      return null;
    }
  }

  String getPlatformName(){
    if(Platform.isIOS){
      return 'IOS';
    }else{
      return 'ANDROID';
    }
  }
}