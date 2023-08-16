import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

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
    }
    try {
      await PrinterManager.instance.connect(
        type: PrinterType.bluetooth,
        model: BluetoothPrinterInput(address: device.address!),
      );
      return true;
    } catch (e) {
      //ignored
      return false;
    }
  }

  Future<void> printDocket(List<int> data) async {
    try {
      await PrinterManager.instance
          .send(type: PrinterType.bluetooth, bytes: data);
    } on PlatformException {
      //ignored
    }
  }
}
