import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

class BluetoothPrinterHandler {
  final _printerManager = PrinterManager.instance;
  bool _isConnected = false;
  BluetoothDevice? _currentConnectedDevice;

  BluetoothPrinterHandler() {
    _initListener();
  }

  bool isConnected() => _isConnected;

  void _initListener() {
    _printerManager.stateBluetooth.listen((status) {
      debugPrint(
          '*****************************BLE STATE $status***********************');
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

  Future<List<BluetoothDevice>> getDevices() async {
    final results =
        await _printerManager.discovery(type: PrinterType.bluetooth).toList();
    final devices = <BluetoothDevice>[];
    for (var device in results) {
      devices.add(
        BluetoothDevice(
          deviceName: device.name,
          address: device.address,
        ),
      );
    }
    return devices;
  }

  Future<bool> connect(BluetoothDevice device) async {
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

  void printDocket(List<int> data) async {
    try {
      await _printerManager.send(type: PrinterType.bluetooth, bytes: data);
    } on PlatformException {
      //ignored
    }
  }
}

class BluetoothDevice {
  String? deviceName;
  String? address;

  BluetoothDevice({
    this.deviceName,
    this.address,
  });
}
