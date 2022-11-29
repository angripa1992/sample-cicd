import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

class UsbPrinterHandler {
  final _printerManager = PrinterManager.instance;
  bool _connected = false;

  bool isConnected() => _connected;

  Future<List<UsbDevice>> getDevices() async {
    final results = await _printerManager.discovery(type: PrinterType.usb).toList();
    final devices = <UsbDevice>[];
    for (var device in results) {
      devices.add(
        UsbDevice(
          vendorId: device.vendorId ?? '',
          productId: device.productId ?? '',
          name: device.name,
        ),
      );
    }
    return devices;
  }

  Future<bool> connect(UsbDevice device) async {
    bool? returned = false;
    try {
      returned = await _printerManager.connect(
        type: PrinterType.usb,
        model: UsbPrinterInput(
          name: device.name,
          vendorId: device.vendorId,
          productId: device.productId,
        ),
      );
    } on PlatformException {
      //ignored
    }
    if (returned!) {
      _connected = true;
    }
    return returned;
  }

  void print(List<int> data) async {
    try {
      await _printerManager.send(type: PrinterType.usb, bytes: data);
    } on PlatformException {
      //ignored
    }
  }
}

class UsbDevice {
  final String vendorId;
  final String productId;
  final String name;

  UsbDevice(
      {required this.vendorId, required this.productId, required this.name});
}
