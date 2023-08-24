import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

class UsbPrinterHandler {
  static final UsbPrinterHandler _instance = UsbPrinterHandler._internal();

  factory UsbPrinterHandler() => _instance;

  UsbPrinterHandler._internal();

  bool isConnected() =>
      PrinterManager.instance.currentStatusUSB == USBStatus.connected;

  Future<List<PrinterDevice>> getDevices() async {
    final scanResults = <PrinterDevice>[];
    final subscription =
        PrinterManager.instance.discovery(type: PrinterType.bluetooth).listen(
      (event) {
        scanResults.add(event);
      },
    );
    return await Future.delayed(const Duration(seconds: 1), () {
      subscription.cancel();
      return scanResults;
    });
  }

  Future<bool> connect(PrinterDevice device) async {
    if (PrinterManager.instance.currentStatusUSB == USBStatus.connected) {
      await PrinterManager.instance.disconnect(type: PrinterType.usb);
    }
    try {
      await PrinterManager.instance.connect(
        type: PrinterType.usb,
        model: UsbPrinterInput(
          name: device.name,
          vendorId: device.vendorId,
          productId: device.productId,
        ),
      );
      return true;
    } on PlatformException {
      //ignored
      return false;
    }
  }

  Future<void> printDocket(List<int> data) async {
    try {
      await PrinterManager.instance.send(type: PrinterType.usb, bytes: data);
    } on PlatformException {
      //ignored
    }
  }
}
