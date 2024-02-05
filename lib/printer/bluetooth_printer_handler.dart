import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

import '../app/app_preferences.dart';
import '../app/di.dart';
import 'data/printer_setting.dart';

class BluetoothPrinterHandler {
  final _appPreferences = getIt.get<AppPreferences>();

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

  PrinterSetting _createPrinterSettingFromLocalVariables() {
    final printerSetting = _appPreferences.printerSetting();
    return PrinterSetting(
      branchId: printerSetting.branchId,
      type: printerSetting.type,
      paperSize: printerSetting.paperSize,
      customerCopyEnabled: printerSetting.customerCopyEnabled,
      kitchenCopyEnabled: printerSetting.kitchenCopyEnabled,
      customerCopyCount: printerSetting.customerCopyCount,
      kitchenCopyCount: printerSetting.kitchenCopyCount,
      fonts: PrinterFonts.fromId(printerSetting.fontId),
      fontId: printerSetting.fontId,
      stickerPrinterEnabled: printerSetting.stickerPrinterEnabled,
      deviceId: printerSetting.deviceId,
      deviceNane: printerSetting.deviceNane,
      productId: printerSetting.productId,
      vendorId: printerSetting.vendorId,
    );
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

      PrinterSetting printerSetting = _createPrinterSettingFromLocalVariables();
      printerSetting.deviceId = device.address!;
      printerSetting.deviceNane = device.name;

      await _appPreferences.savePrinterSettings(
        printerSetting: printerSetting,
      );

      return true;
    } catch (e) {
      //ignored
      return false;
    }
  }

  Future<bool> autoConnectDevice() async {
    PrinterSetting printerSetting = _createPrinterSettingFromLocalVariables();
    if (isConnected()) {
      return true;
    }
    try {
      await PrinterManager.instance.connect(
        type: PrinterType.bluetooth,
        model: BluetoothPrinterInput(address: printerSetting.deviceId!),
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

  Future<void> print(List<int> data, Map printerAddress) async {
    try {

      if (isConnected()) {
        await PrinterManager.instance.disconnect(type: PrinterType.bluetooth);
      }

      await connect(PrinterDevice(name: printerAddress['name'], address: printerAddress['address']));

      await PrinterManager.instance
          .send(type: PrinterType.bluetooth, bytes: data);
    } on PlatformException {
      //ignored
    }

  }
}
