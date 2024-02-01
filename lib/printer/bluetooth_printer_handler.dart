import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:klikit/app/app_config.dart';

class BluetoothPrinterHandler {
  static final BluetoothPrinterHandler _instance =
  BluetoothPrinterHandler._internal();

  factory BluetoothPrinterHandler() => _instance;

  BluetoothPrinterHandler._internal();

  bool isConnected() =>
      PrinterManager.instance.currentStatusBT == BTStatus.connected;

  Future<List<PrinterDevice>> getDevices() async {
    final scanResults = <PrinterDevice>[];
    final subscription =
    PrinterManager.instance.discovery(type: PrinterType.bluetooth).listen(
          (event) {
        scanResults.add(event);
      },
    );
    return await Future.delayed(const Duration(seconds: 4), () {
      subscription.cancel();
      return scanResults;
    });
  }

  Future<bool> connect(PrinterDevice device) async {
    if (isConnected()) {
      await PrinterManager.instance.disconnect(type: PrinterType.bluetooth);
      AppConfig.connectedDeviceAddress = '';
    }
    try {
      await PrinterManager.instance.connect(
        type: PrinterType.bluetooth,
        model: BluetoothPrinterInput(address: device.address!),
      );
      AppConfig.connectedDeviceAddress = device.address ?? '';
      return true;
    } catch (e) {
      debugPrint('BL connection error $e');
      AppConfig.connectedDeviceAddress = '';
      return false;
    }
  }

  Future<void> printDocket(List<int> data) async {
    try {
      await PrinterManager.instance.send(type: PrinterType.bluetooth, bytes: data);
    } on PlatformException {
      //ignored
    }

  }

  Future<void> print(List<int> data, Map printerAddress) async {
    try {

      if (isConnected()) {
        await PrinterManager.instance.disconnect(type: PrinterType.bluetooth);
      }

      await connect(PrinterDevice(name: printerAddress['name'], address: printerAddress['address']));

      await PrinterManager.instance
          .send(type: PrinterType.bluetooth, bytes: data);
    } on PlatformException {
      //ignored
    }

  }
}
