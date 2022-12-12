import 'dart:io';

import 'package:package_info_plus/package_info_plus.dart';
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
}