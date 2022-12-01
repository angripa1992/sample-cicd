import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

class UsbPrinterHandler {
  final _printerManager = PrinterManager.instance;
  bool _isConnected = false;
  UsbDevice? _currentConnectedDevice;

  UsbPrinterHandler() {
    _initListener();
  }

  void _initListener() {
    _printerManager.stateUSB.listen((status) {
      switch (status) {
        case USBStatus.connected:
          _isConnected = true;
          break;
        default:
          _isConnected = false;
          break;
      }
    });
  }

  bool isConnected() => _isConnected;

  Future<List<UsbDevice>> getDevices() async {
    final results =
        await _printerManager.discovery(type: PrinterType.usb).toList();
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
    if (_currentConnectedDevice != null) {
      if (device.vendorId != _currentConnectedDevice!.vendorId) {
        await PrinterManager.instance.disconnect(type: PrinterType.usb);
      }
    }
    try {
      await _printerManager.connect(
        type: PrinterType.usb,
        model: UsbPrinterInput(
          name: device.name,
          vendorId: device.vendorId,
          productId: device.productId,
        ),
      );
      _isConnected = true;
      _currentConnectedDevice = device;
    } on PlatformException {
      //ignored
      _isConnected = false;
    }
    return _isConnected;
  }

  void printDocket(List<int> data) async {
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
