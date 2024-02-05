import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';

import '../app/app_preferences.dart';
import '../app/di.dart';
import 'data/printer_setting.dart';

class UsbPrinterHandler {
  static final UsbPrinterHandler _instance = UsbPrinterHandler._internal();

  final _appPreferences = getIt.get<AppPreferences>();

  factory UsbPrinterHandler() => _instance;

  UsbPrinterHandler._internal();

  bool isConnected() => PrinterManager.instance.currentStatusUSB == USBStatus.connected;

  Future<List<PrinterDevice>> getDevices() async {
    final scanResults = <PrinterDevice>[];
    final subscription = PrinterManager.instance.discovery(type: PrinterType.usb).listen(
      (event) {
        scanResults.add(event);
      },
    );
    return await Future.delayed(const Duration(seconds: 1), () {
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
      PrinterSetting printerSetting = _createPrinterSettingFromLocalVariables();
      printerSetting.deviceNane = device.name;
      printerSetting.productId = device.productId;
      printerSetting.vendorId = device.vendorId;

      await _appPreferences.savePrinterSettings(
        printerSetting: printerSetting,
      );
      return true;
    } on PlatformException {
      //ignored
      return false;
    }
  }

  Future<bool> autoConnectDevice() async {
    if (isConnected()) {
      return true;
    }
    try {
      PrinterSetting printerSetting = _createPrinterSettingFromLocalVariables();
      await PrinterManager.instance.connect(
        type: PrinterType.usb,
        model: UsbPrinterInput(
          name: printerSetting.deviceNane,
          vendorId: printerSetting.vendorId,
          productId: printerSetting.productId,
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
