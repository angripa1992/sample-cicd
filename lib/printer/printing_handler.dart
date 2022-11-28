import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/core/utils/permission_handler.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/printer/bluetooth_printer_handler.dart';
import 'package:klikit/printer/presentation/device_list_bottom_sheet.dart';
import 'package:klikit/printer/presentation/docket_design.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image/image.dart' as im;

import '../modules/orders/domain/entities/order.dart';

class PrintingHandler {
  final AppPreferences _preferences;
  final BluetoothPrinterHandler _bluetoothPrinterHandler;
  final _screenshotController = ScreenshotController();

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
      onConnect: (device) async {
        final isConnected = await _bluetoothPrinterHandler.connect(device);
        if (isConnected) {
          showSuccessSnackBar(
              RoutesGenerator.navigatorKey.currentState!.context,
              'Successfully Connected');
        } else {
          showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context,
              'Can not connect to this device');
        }
      },
      devices: devices,
    );
  }

  void printDocket(Order order) async{
    // Navigator.push(RoutesGenerator.navigatorKey.currentState!.context,
    //     MaterialPageRoute(builder: (context) => DocketDesign(order: order)));

    Uint8List? bytes = await _capturePng(order);
    List<int>? rawBytes = await _ticket(bytes!);
    _bluetoothPrinterHandler.printDocket(Uint8List.fromList(rawBytes!));
  }

  Future<Uint8List?> _capturePng(Order order) async {
    try {
      Uint8List pngBytes = await _screenshotController.captureFromWidget(DocketDesign(order: order));
      return pngBytes;
    } catch (e) {
      print('========================$e');
    }
    return null;
  }

  Future<List<int>?> _ticket(Uint8List headerBytes) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    final im.Image? headerImg = im.decodeImage(headerBytes);
    bytes += generator.image(headerImg!);
    return bytes;
  }
}
