import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

class UsbPrinterHandler {
  bool isConnected() =>
      PrinterManager.instance.currentStatusUSB == USBStatus.connected;

  Stream<PrinterDevice> getDevices() =>
      PrinterManager.instance.discovery(type: PrinterType.usb);

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
