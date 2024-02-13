import 'dart:typed_data';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/strings.dart';

class StickerPrinterHandler {
  static final StickerPrinterHandler _instance = StickerPrinterHandler._internal();
  static final _bluetooth = FlutterBluePlus.instance;
  static BluetoothDevice? _connectedDevice;

  factory StickerPrinterHandler() => _instance;

  StickerPrinterHandler._internal();

  BluetoothDevice? connectedDevice() => _connectedDevice;

  void _setConnectedDevice(BluetoothDevice? device) => _connectedDevice = device;

  Future<List<ScanResult>> scanDevices() async {
    final finalScanResults = <ScanResult>[];
    try {
      _bluetooth.startScan(timeout: const Duration(seconds: 4));
      final subscriptions = _bluetooth.scanResults.listen((event) {
        finalScanResults.clear();
        finalScanResults.addAll(event);
      });
      return await Future.delayed(const Duration(seconds: 4), () async {
        _bluetooth.stopScan();
        subscriptions.cancel();
        return finalScanResults;
      });
    } catch (e) {
      return <ScanResult>[];
    }
  }

  Future<void> disconnect(BluetoothDevice device) async {
    final connectedDevices = await _bluetooth.connectedDevices;
    final connectedDeviceOrNull = connectedDevices.firstWhereOrNull((element) => element.id.id == device.id.id);
    await connectedDeviceOrNull?.disconnect();
    _setConnectedDevice(null);
  }

  Future<bool> connect(BluetoothDevice device, bool showMessage) async {
    try {
      await disconnect(device);
      await device.connect(shouldClearGattCache: true, autoConnect: true);
      _setConnectedDevice(device);
      if (showMessage) {
        showSuccessSnackBar(RoutesGenerator.navigatorKey.currentState!.context, "Sticker Printer Successfully Connected");
      }
      return true;
    } catch (e) {
      showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context, AppStrings.can_not_connect_device.tr());
      return false;
    }
  }

  Future<void> print(Uint8List command) async {
    if (await connect(_connectedDevice!, false)) {
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
        showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context, AppStrings.defaultError.tr());
      }
    }
  }
}
