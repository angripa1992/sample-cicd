import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_app_installations/firebase_app_installations.dart';


class DeviceInfoProvider{

  Future<String> FID() async{
    return await FirebaseInstallations.instance.getId();
  }

  String platformName(){
    if(Platform.isIOS){
      return 'ios';
    }else{
      return 'android';
    }
  }

  Future<String> appName() async{
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  Future<String> packageName() async{
    final packageInfo = await PackageInfo.fromPlatform(); 
    return packageInfo.packageName;
  }

  Future<String> versionCode() async{
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  Future<String> versionName() async{
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  //OS version
  Future<String> getVersionInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.release.toString();
  }

  Future<String> getDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model.toString();
    } else {
      return ('Error retreiving device model');
    }
  }
}