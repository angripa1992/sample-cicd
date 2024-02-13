import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/notification/local_notification_service.dart';
import 'package:klikit/printer/printer_handler.dart';
import 'package:klikit/printer/printer_local_data_manager.dart';
import 'package:klikit/resources/strings.dart';

import 'data/printer_setting.dart';

class BluetoothPrinterHandler extends PrinterHandler {
  @override
  Future<List<PrinterDevice>> getDevices<PrinterDevice>() async {
    final scanResults = <PrinterDevice>[];
    final subscription = PrinterManager.instance.discovery(type: PrinterType.bluetooth).listen(
      (event) {
        scanResults.add(event as PrinterDevice);
      },
    );
    return await Future.delayed(const Duration(seconds: 4), () {
      subscription.cancel();
      return scanResults;
    });
  }

  @override
  Future<bool> connect({
    LocalPrinter? localPrinter,
    required bool isFromBackground,
    required bool showMessage,
  }) async {
    if (localPrinter == null) {
      _showMessage(isFromBackground, true, AppStrings.can_not_connect_device.tr(), showMessage);
      return false;
    }
    try {
      final connected = await PrinterManager.instance.connect(
        type: PrinterType.bluetooth,
        model: BluetoothPrinterInput(address: localPrinter.deviceAddress),
      );
      if (connected) {
        LocalPrinterDataManager().saveLocalPrinter(localPrinter).then((value) {
          _showMessage(isFromBackground, false, AppStrings.bluetooth_successfully_connected.tr(), showMessage);
        });
      }
      return connected;
    } catch (e) {
      _showMessage(isFromBackground, true, AppStrings.can_not_connect_device.tr(), showMessage);
      return false;
    }
  }

  @override
  Future<bool> disconnect(LocalPrinter? localPrinter, bool isFromBackground) async {
    await PrinterManager.instance.disconnect(type: PrinterType.bluetooth);
    await LocalPrinterDataManager().clearLocalPrinter();
    _showMessage(isFromBackground, true, 'Printer connection disconnected', true);
    return true;
  }

  @override
  Future<bool> print({
    required List<int> data,
    required LocalPrinter? localPrinter,
    required isFromBackground,
  }) async {
    final connected = await connect(localPrinter: localPrinter, isFromBackground: isFromBackground, showMessage: false);
    if (connected) {
      try {
        await PrinterManager.instance.send(type: PrinterType.bluetooth, bytes: data);
      } on PlatformException {
        _showMessage(isFromBackground, true, AppStrings.defaultError.tr(), true);
        return false;
      }
    } else {
      return false;
    }
    return true;
  }

  void _showMessage(bool isFromBackground, bool isError, String message, bool willShowMessage) {
    if (!isFromBackground) {
      final context = RoutesGenerator.navigatorKey.currentState!.context;
      if (isError) {
        showErrorSnackBar(context, message);
      } else if(willShowMessage) {
        showSuccessSnackBar(context, message);
      }
    } else if (isFromBackground && isError) {
      LocalNotificationService().showPrinterNotFoundNotification();
    }
  }

  @override
  String title() {
    return 'Bluetooth';
  }

  @override
  IconData icon() {
    return Icons.bluetooth;
  }

  @override
  int type() {
    return CType.BLE;
  }
}
