import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

class BluetoothPrinterHandler {
  final _printerManager = PrinterManager.instance;
  bool _isConnected = false;
  PrinterDevice? _currentConnectedDevice;

  BluetoothPrinterHandler() {
    _initListener();
  }

  bool isConnected() => _isConnected;

  void _initListener() {
    _printerManager.stateBluetooth.listen((status) {
      switch (status) {
        case BTStatus.connected:
          _isConnected = true;
          break;
        default:
          _isConnected = false;
          break;
      }
    });
  }

  Stream<PrinterDevice> getDevices() =>
      _printerManager.discovery(type: PrinterType.bluetooth);

  Future<bool> connect(PrinterDevice device) async {
    if (_currentConnectedDevice != null) {
      if (device.address != _currentConnectedDevice!.address) {
        await PrinterManager.instance.disconnect(type: PrinterType.bluetooth);
      }
    }
    try {
      await _printerManager.connect(
        type: PrinterType.bluetooth,
        model: BluetoothPrinterInput(address: device.address!),
      );
      _currentConnectedDevice = device;
      _isConnected = true;
    } on Exception {
      //ignored
      _isConnected = false;
    }
    return _isConnected;
  }

  Future<void> printDocket(List<int> data) async {
    try {
      await _printerManager.send(type: PrinterType.bluetooth, bytes: data);
    } on PlatformException {
      //ignored
    }
  }
}
