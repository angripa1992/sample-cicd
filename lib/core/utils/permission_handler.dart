import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {
  static final _instance = PermissionHandler._internal();

  factory PermissionHandler() => _instance;

  PermissionHandler._internal();

  Future<void> requestPermissions() async {
    final Map<Permission, PermissionStatus> statues = await [Permission.location, Permission.notification].request();
    final notificationStatus = statues[Permission.notification];
    final locationStatus = statues[Permission.location];
    if (notificationStatus!.isPermanentlyDenied || locationStatus!.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  Future<bool> isLocationPermissionGranted() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }
}
