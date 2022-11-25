import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/core/utils/permission_handler.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/printer/bluetooth_printer_handler.dart';
import 'package:klikit/printer/presentation/device_list_bottom_sheet.dart';

class PrintingHandler {
  final AppPreferences _preferences;
  final BluetoothPrinterHandler _bluetoothPrinterHandler;

  PrintingHandler(this._preferences, this._bluetoothPrinterHandler);

  Future<bool> _isPermissionGranted() async {
    if (await PermissionHandler().isLocationPermissionGranted()) {
      return true;
    } else {
      return await PermissionHandler().requestLocationPermission();
    }
  }

  void verifyConnection() async {
    if (_preferences.connectionType() == ConnectionType.BLUETOOTH) {
      _verifyBleConnection();
    }
  }

  void _verifyBleConnection() async {
    if (await _isPermissionGranted()) {
      if (await _bluetoothPrinterHandler.isBluetoothOn()) {
        if (!await _bluetoothPrinterHandler.isConnected()) {
          showBleDeviceList();
        }
      } else {
        showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context,
            'Please On your bluetooth');
      }
    }
  }

  void showBleDeviceList() async {
    final devices = await _bluetoothPrinterHandler.getDevices();
    debugPrint(
        '*****************************BLE DEVICES $devices***********************');
    showBleDeviceListView(
      onConnect: (device) async{
        final isConnected = await _bluetoothPrinterHandler.connect(device);
        if(isConnected){
          showSuccessSnackBar(RoutesGenerator.navigatorKey.currentState!.context, 'Successfully Connected');
        }else{
          showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context, 'Can not connect to this device');
        }
      },
      devices: devices,
    );
  }
}
