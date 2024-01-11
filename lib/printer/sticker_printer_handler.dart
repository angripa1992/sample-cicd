import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class StickerPrinterHandler {
  static final StickerPrinterHandler _instance = StickerPrinterHandler._internal();
  BluetoothDevice? _connectedDevice;

  factory StickerPrinterHandler() => _instance;

  StickerPrinterHandler._internal();

  Future<List<ScanResult>> scanDevices() async {
    final finalScanResults = <ScanResult>[];
    try {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));
      final subscriptions = FlutterBluePlus.scanResults.listen((event) {
        finalScanResults.clear();
        finalScanResults.addAll(event);
      });
      return await Future.delayed(const Duration(seconds: 4), () async {
        FlutterBluePlus.stopScan();
        subscriptions.cancel();
        return finalScanResults;
      });
    } catch (e) {
      return <ScanResult>[];
    }
  }

  Future<bool> isConnected() async {
    final connectedDevices = FlutterBluePlus.connectedDevices;
    return _connectedDevice != null && connectedDevices.isNotEmpty;
  }

  Future<bool> connect(BluetoothDevice device) async {
    try {
      final connectedDevices = FlutterBluePlus.connectedDevices;
      for (var connectedDevice in connectedDevices) {
        if (connectedDevice.remoteId.str == device.remoteId.str) {
          await device.disconnect();
        }
      }
      await device.connect();
      _connectedDevice = device;
      return true;
    } catch (e) {
      return false;
    }
  }

  Future print(Uint8List command) async {
    if (await isConnected()) {
      try {
        BluetoothCharacteristic? writeCharacteristic;
        List<BluetoothService> services = await _connectedDevice!.discoverServices();
        for (var service in services) {
          for (var characteristic in service.characteristics) {
            if (characteristic.properties.write) {
              writeCharacteristic = characteristic;
            }
          }
        }
        if (writeCharacteristic != null) {
          await writeCharacteristic.write(command);
        }
      } catch (e) {
        //ignore
      }
    }
  }
}
