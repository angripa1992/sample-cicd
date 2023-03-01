import 'package:docket_design_template/docket_design_template.dart';
import 'package:docket_design_template/model/order.dart';
import 'package:docket_design_template/utils/printer_configuration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/core/utils/permission_handler.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/printer/bluetooth_printer_handler.dart';
import 'package:klikit/printer/presentation/capture_image_preview.dart';
import 'package:klikit/printer/presentation/device_list_bottom_sheet.dart';
import 'package:klikit/printer/usb_printer_handler.dart';
import 'package:klikit/resources/strings.dart';

import '../core/provider/order_information_provider.dart';
import '../modules/orders/domain/entities/order.dart';

class PrintingHandler {
  final AppPreferences _preferences;
  final BluetoothPrinterHandler _bluetoothPrinterHandler;
  final UsbPrinterHandler _usbPrinterHandler;
  final OrderInformationProvider _infoProvider;

  PrintingHandler(
    this._preferences,
    this._bluetoothPrinterHandler,
    this._usbPrinterHandler,
    this._infoProvider,
  );

  Future<bool> _isPermissionGranted() async {
    if (await PermissionHandler().isLocationPermissionGranted()) {
      return true;
    } else {
      return await PermissionHandler().requestLocationPermission();
    }
  }

  void verifyConnection({required bool fromNotification, Order? order}) async {
    if (_preferences.printerSetting().connectionType ==
        ConnectionType.BLUETOOTH) {
      _verifyBleConnection(fromNotification: fromNotification, order: order);
    } else {
      _verifyUsbConnection(fromNotification: fromNotification, order: order);
    }
  }

  void _verifyBleConnection(
      {required bool fromNotification, Order? order}) async {
    if (await _isPermissionGranted()) {
      if (!_bluetoothPrinterHandler.isConnected()) {
        if (fromNotification) {
          showErrorSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            AppStrings.bluetooth_not_connected.tr(),
          );
        } else {
          showBleDevices(order: order);
        }
      } else if (order != null) {
        printDocket(order);
      }
    }
  }

  void _verifyUsbConnection({required bool fromNotification, Order? order}) {
    if (!_usbPrinterHandler.isConnected()) {
      if (fromNotification) {
        showErrorSnackBar(
          RoutesGenerator.navigatorKey.currentState!.context,
          AppStrings.usb_not_connected.tr(),
        );
      } else {
        showUsbDevices(order: order);
      }
    } else if (order != null) {
      printDocket(order);
    }
  }

  void showBleDevices({Order? order}) async {
    final devices = _bluetoothPrinterHandler.getDevices();
    DeviceListBottomSheetManager().showBottomSheet(
      type: ConnectionType.BLUETOOTH,
      devicesStream: devices,
      onConnect: (device) async {
        final isConnected = await _bluetoothPrinterHandler.connect(device);
        if (isConnected) {
          showSuccessSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            AppStrings.bluetooth_successfully_connected.tr(),
          );
          if (order != null) {
            printDocket(order);
          }
        } else {
          showErrorSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            AppStrings.can_not_connect_device.tr(),
          );
        }
      },
    );
  }

  void showUsbDevices({Order? order}) async {
    final devices = _usbPrinterHandler.getDevices();
    DeviceListBottomSheetManager().showBottomSheet(
      type: ConnectionType.USB,
      devicesStream: devices,
      onConnect: (device) async {
        final isSuccessfullyConnected =
            await _usbPrinterHandler.connect(device);
        if (isSuccessfullyConnected) {
          showSuccessSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            AppStrings.usb_successfully_connected.tr(),
          );
          if (order != null) {
            printDocket(order);
          }
        } else {
          showErrorSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            AppStrings.can_not_connect_device.tr(),
          );
        }
      },
    );
  }

  void printDocket(Order order) async {
    if (_preferences.printerSetting().connectionType ==
        ConnectionType.BLUETOOTH) {
      if (_bluetoothPrinterHandler.isConnected()) {
        // _showPreview(order);
        final printingData = await _generatePrintingData(order);
        if (printingData == null) return;
        _bluetoothPrinterHandler.printDocket(printingData);
      } else {
        showBleDevices(order: order);
      }
    } else {
      if (_usbPrinterHandler.isConnected()) {
        final printingData = await _generatePrintingData(order);
        if (printingData == null) return;
        _usbPrinterHandler.printDocket(printingData);
      } else {
        showUsbDevices(order: order);
      }
    }
  }

  Future<List<int>?> _generatePrintingData(Order order) async {
    final rollSize = _preferences.printerSetting().paperSize.toRollSize();
    // final docketType = _preferences.printerSetting().docketType == DocketType.customer
    //         ? Docket.customer
    //         : Docket.kitchen;
    final templateOrder = await _generateTemplateOrder(order);
    List<int>? rawBytes = await DocketDesignTemplate().generateTicket(
      templateOrder,
      PrinterConfiguration(
        docket: Docket.customer,
        roll: rollSize,
      ),
    );
    return rawBytes;
  }

  void _showPreview(Order order) async {
    final rollSize = _preferences.printerSetting().paperSize.toRollSize();
    final docketType =
        _preferences.printerSetting().docketType == DocketType.customer
            ? Docket.customer
            : Docket.kitchen;
    final templateOrder = await _generateTemplateOrder(order);
    final pdfImage = await DocketDesignTemplate().generatePdfImage(
      templateOrder,
      PrinterConfiguration(
        docket: docketType,
        roll: rollSize,
      ),
    );
    Navigator.push(
        RoutesGenerator.navigatorKey.currentState!.context,
        MaterialPageRoute(
            builder: (context) => CaptureImagePrivew(
                  capturedImage: pdfImage,
                )));
  }

  Future<TemplateOrder> _generateTemplateOrder(Order order) async {
    Brand? brand;
    if (order.brands.length == 1) {
      brand = await _infoProvider.findBrandById(order.brands.first.id);
    }
    String placedOn = EMPTY;
    if (order.source > 0) {
      final source = await _infoProvider.findSourceById(order.source);
      placedOn = source.name;
    } else {
      final provider = await _infoProvider.findProviderById(order.providerId);
      placedOn = provider.title;
    }
    return order.toTemplateOrder(
      placedOn: placedOn,
      qrInfo: brand?.toQrInfo(),
    );
  }
}
