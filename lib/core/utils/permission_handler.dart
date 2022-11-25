import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static final _instance = PermissionHandler._internal();

  factory PermissionHandler() => _instance;

  PermissionHandler._internal();

  Future<bool> requestLocationPermission() async{
    final result = await Permission.location.request();
    return result.isGranted;
  }

  Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }
}
