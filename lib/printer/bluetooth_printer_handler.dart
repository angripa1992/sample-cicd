import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
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
      if(!isConnected()){

      }
      await PrinterManager.instance
          .send(type: PrinterType.bluetooth, bytes: data);
    } on PlatformException catch (e){
      debugPrint(e.stacktrace);
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
    } on PlatformException catch (e){
      debugPrint(e.stacktrace);
      //ignored
    }

  }


}
