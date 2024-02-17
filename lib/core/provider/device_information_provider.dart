import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class DeviceInfoProvider {
  String platformName() {
    if (Platform.isIOS) {
      return 'ios';
    } else if (Platform.isWindows) {
      return "windows";
    } else {
      return 'android';
    }
  }

  Future<String> appName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.appName;
  }

  Future<String> packageName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.packageName;
  }

  Future<String> versionCode() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.buildNumber;
  }

  Future<String> versionName() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  //OS version
  Future<String> getOsVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isWindows) {
      WindowsDeviceInfo d = await deviceInfo.windowsInfo;
      return d.computerName;
    }
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.release.toString();
  }

  Future<String> getDeviceModel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isWindows) {
      WindowsDeviceInfo windowsDeviceInfo = await deviceInfo.windowsInfo;
      return windowsDeviceInfo.computerName.toString();
    }
    else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.model.toString();
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.model.toString();
    } else {
      return ('Error retrieving device model');
    }
  }
}
