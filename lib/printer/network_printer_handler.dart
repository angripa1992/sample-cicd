import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/notification/local_notification_service.dart';
import 'package:klikit/printer/data/printer_setting.dart';
import 'package:klikit/printer/printer_handler.dart';
import 'package:klikit/printer/printer_local_data_manager.dart';
import 'package:klikit/resources/strings.dart';

class NetworkPrinterHandler extends PrinterHandler {
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
        type: PrinterType.network,
        model: TcpPrinterInput(ipAddress: localPrinter.deviceAddress),
      );
      if (connected) {
        LocalPrinterDataManager().saveLocalPrinter(localPrinter).then((value) {
          _showMessage(isFromBackground, false, 'Wi-Fi printer successfully connected', showMessage);
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
    await PrinterManager.instance.disconnect(type: PrinterType.network);
    await LocalPrinterDataManager().clearLocalPrinter();
    _showMessage(isFromBackground, true, 'Printer connection disconnected', true);
    return true;
  }

  @override
  Future<List<T>> getDevices<T>() async {
    return [];
  }

  @override
  Future<bool> print({
    required List<int> data,
    required LocalPrinter? localPrinter,
    required bool isFromBackground,
  }) async {
    final connected = await connect(localPrinter: localPrinter, isFromBackground: isFromBackground, showMessage: false);
    if (connected) {
      try {
        await PrinterManager.instance.send(type: PrinterType.network, bytes: data);
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
      } else if (willShowMessage) {
        showSuccessSnackBar(context, message);
      }
    } else if (isFromBackground && isError) {
      LocalNotificationService().showPrinterNotFoundNotification();
    }
  }

  @override
  String title() {
    return 'Wi-Fi';
  }

  @override
  IconData icon() {
    return Icons.wifi;
  }

  @override
  int type() {
    return CType.WIFI;
  }
}
