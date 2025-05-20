 import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/icon_data.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/notification/local_notification_service.dart';
import 'package:klikit/printer/printer_handler.dart';
import 'package:klikit/printer/printer_local_data_manager.dart';
import 'package:klikit/resources/strings.dart';

import 'data/printer_setting.dart';

class UsbPrinterHandler extends PrinterHandler {
  static const MethodChannel _channel = MethodChannel('escpos_usb_printer');

  @override
  Future<List<PrinterDevice>> getDevices<PrinterDevice>() async {
    final List<PrinterDevice> scanResults = [];
    final subscription = PrinterManager.instance.discovery(type: PrinterType.usb).listen(
      (event) {
        scanResults.add(event as PrinterDevice);
      },
    );
    return await Future.delayed(const Duration(seconds: 1), () {
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
      await PrinterManager.instance.connect(
        type: PrinterType.usb,
        model: UsbPrinterInput(
          name: localPrinter.deviceName,
          vendorId: localPrinter.vendorId,
          productId: localPrinter.productId,
        ),
      );
      await LocalPrinterDataManager().saveLocalPrinter(localPrinter).then((value) {
        _showMessage(isFromBackground, false, AppStrings.usb_successfully_connected.tr(), showMessage);
      });
      return true;
    } on PlatformException {
      _showMessage(isFromBackground, false, AppStrings.can_not_connect_device.tr(), showMessage);
      return false;
    }
  }

  @override
  Future<bool> disconnect(LocalPrinter? localPrinter, bool isFromBackground) async {
    await PrinterManager.instance.disconnect(type: PrinterType.usb);
    await LocalPrinterDataManager().clearLocalPrinter();
    _showMessage(isFromBackground, true, 'Printer connection disconnected', true);
    return true;
  }

  @override
  Future<bool> print({
    required List<int> data,
    required LocalPrinter? localPrinter,
    required bool isFromBackground,
  }) async {
    debugPrint("debug device printer");
    debugPrint(LocalPrinterDataManager().localPrinter()?.deviceName);
    final result = await _channel.invokeMethod('print', {
      'bytes': [
        0x1B, 0x40, // ESC @ -> Initialize
        0x48, 0x65, 0x6C, 0x6C, 0x6F, // Hello
        0x0A, // Line feed
        0x1D, 0x56, 0x01, // Cut
      ],
      'printer': LocalPrinterDataManager().localPrinter()?.deviceName,
    });
    debugPrint("print result $result");
    return result;
    // final connected = await connect(localPrinter: localPrinter, showMessage: false, isFromBackground: isFromBackground);
    // if (connected) {
    //   try {
    //     await PrinterManager.instance.send(type: PrinterType.usb, bytes: data);
    //   } on PlatformException {
    //     _showMessage(isFromBackground, true, AppStrings.defaultError.tr(), true);
    //     return false;
    //   }
    // } else {
    //   return false;
    // }

    return true;
  }

  void _showMessage(bool isFromBackground, bool isError, String message, bool willShowMessage) {
    if (!isFromBackground) {
      final context = RoutesGenerator.navigatorKey.currentState!.context;
      if (isError) {
        showErrorSnackBar(context, message);
      } else if (willShowMessage) {
        showSuccessSnackBar(context, message);
      }
    } else if (isFromBackground && isError) {
      LocalNotificationService().showPrinterNotFoundNotification();
    }
  }

  @override
  String title() {
    return 'USB';
  }

  @override
  IconData icon() {
    return Icons.usb;
  }

  @override
  int type() {
    return CType.USB;
  }
}
