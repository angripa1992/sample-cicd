import 'package:docket_design_template/docket_design_template.dart';
import 'package:docket_design_template/model/font_size.dart';
import 'package:docket_design_template/model/order.dart';
import 'package:docket_design_template/utils/printer_configuration.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/printer/bluetooth_printer_handler.dart';
import 'package:klikit/printer/data/printer_data_provider.dart';
import 'package:klikit/printer/presentation/capture_image_preview.dart';
import 'package:klikit/printer/presentation/device_list_bottom_sheet.dart';
import 'package:klikit/printer/presentation/select_docket_type_dialog.dart';
import 'package:klikit/printer/sticker_docket_generator.dart';
import 'package:klikit/printer/sticker_printer_handler.dart';
import 'package:klikit/printer/usb_printer_handler.dart';
import 'package:klikit/resources/strings.dart';

import '../core/utils/permission_handler.dart';
import '../modules/orders/domain/entities/cart.dart';
import '../modules/orders/domain/entities/order.dart';
import '../modules/orders/provider/order_information_provider.dart';

class PrintingHandler {
  final AppPreferences _preferences;
  final OrderInformationProvider _infoProvider;

  PrintingHandler(
    this._preferences,
    this._infoProvider,
  );

  Future<bool> _isPermissionGranted() async {
    if (await PermissionHandler().isLocationPermissionGranted()) {
      return true;
    } else {
      return await PermissionHandler().requestLocationPermission();
    }
  }

  void showDevices({
    Order? order,
    required int initialIndex,
  }) async {
    final type = _preferences.printerSetting().connectionType;
    final permissionGranted = await _isPermissionGranted();
    if (permissionGranted) {
      DeviceListBottomSheetManager().showBottomSheet(
        initialIndex: initialIndex,
        type: type == ConnectionType.BLUETOOTH
            ? ConnectionType.BLUETOOTH
            : ConnectionType.USB,
        onPOSConnect: (device) async {
          final isSuccessfullyConnected = type == ConnectionType.BLUETOOTH
              ? await BluetoothPrinterHandler().connect(device)
              : await UsbPrinterHandler().connect(device);
          if (isSuccessfullyConnected) {
            showSuccessSnackBar(
              RoutesGenerator.navigatorKey.currentState!.context,
              type == ConnectionType.BLUETOOTH
                  ? AppStrings.bluetooth_successfully_connected.tr()
                  : AppStrings.usb_successfully_connected.tr(),
            );
            if (order != null) {
              printDocket(order: order, willPrintSticker: false);
            }
          } else {
            showErrorSnackBar(
              RoutesGenerator.navigatorKey.currentState!.context,
              AppStrings.can_not_connect_device.tr(),
            );
          }
        },
        onStickerConnect: (stickerDevice) async {
          final isConnected =
              await StickerPrinterHandler().connect(stickerDevice);
          if (isConnected) {
            showSuccessSnackBar(
              RoutesGenerator.navigatorKey.currentState!.context,
              "Sticker Printer Successfully Connected",
            );
          } else {
            showErrorSnackBar(
              RoutesGenerator.navigatorKey.currentState!.context,
              AppStrings.can_not_connect_device.tr(),
            );
          }
        },
      );
    }
  }

  void printDocket({
    required Order order,
    bool isAutoPrint = false,
    bool willPrintSticker = true,
  }) async {
    //_doManualPrint(order);
    final permissionGranted = await _isPermissionGranted();
    if (permissionGranted) {
      if (_preferences.printerSetting().connectionType == ConnectionType.BLUETOOTH) {
        if (BluetoothPrinterHandler().isConnected()) {
          if (isAutoPrint) {
            _doAutoPrint(order);
          } else {
            _doManualPrint(order);
          }
        } else {
          showErrorSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            AppStrings.bluetooth_not_connected.tr(),
          );
        }
      } else {
        if (UsbPrinterHandler().isConnected()) {
          if (isAutoPrint) {
            _doAutoPrint(order);
          } else {
            _doManualPrint(order);
          }
        } else {
          showErrorSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            AppStrings.usb_not_connected.tr(),
          );
        }
      }
    }
  }

  void printSticker(Order order, CartV2 item) async {
    //final command = StickerDocketGenerator().generateDocket(order, item);
    if (await StickerPrinterHandler().isConnected()) {
      final command = StickerDocketGenerator().generateDocket(order, item);
      StickerPrinterHandler().print(command);
    } else {
      showErrorSnackBar(
        RoutesGenerator.navigatorKey.currentState!.context,
        'Sticker printer not connected',
      );
    }
  }

  void _doManualPrint(Order order) {
    showSelectDocketTypeDialog(
      onSelect: (type) async {
        //_showPreview(order: order, docketType: type);
        final printingData = await _generatePrintingData(order: order, docketType: type);
        if (printingData != null) {
          if (_preferences.printerSetting().connectionType ==
              ConnectionType.BLUETOOTH) {
            await BluetoothPrinterHandler().printDocket(printingData);
          } else {
            await UsbPrinterHandler().printDocket(printingData);
          }
        }
      },
    );
  }

  void _doAutoPrint(Order order) async {
    final printerSetting = _preferences.printerSetting();
    final customerCopy = await _generatePrintingData(
        order: order, docketType: DocketType.customer);
    final kitchenCopy = await _generatePrintingData(
        order: order, docketType: DocketType.kitchen);
    if (printerSetting.connectionType == ConnectionType.BLUETOOTH) {
      if (printerSetting.customerCopyEnabled) {
        if (customerCopy != null) {
          for (int i = 0; i < printerSetting.customerCopyCount; i++) {
            await BluetoothPrinterHandler().printDocket(customerCopy);
          }
        }
      }
      if (printerSetting.kitchenCopyEnabled &&
          printerSetting.kitchenCopyCount > ZERO) {
        if (kitchenCopy != null) {
          for (int i = 0; i < printerSetting.kitchenCopyCount; i++) {
            await BluetoothPrinterHandler().printDocket(kitchenCopy);
          }
        }
      }
    } else {
      if (printerSetting.customerCopyEnabled) {
        if (customerCopy != null) {
          for (int i = 0; i < printerSetting.customerCopyCount; i++) {
            await UsbPrinterHandler().printDocket(customerCopy);
          }
        }
      }
      if (printerSetting.kitchenCopyEnabled &&
          printerSetting.kitchenCopyCount > ZERO) {
        if (kitchenCopy != null) {
          for (int i = 0; i < printerSetting.kitchenCopyCount; i++) {
            await UsbPrinterHandler().printDocket(kitchenCopy);
          }
        }
      }
    }
  }

  PrinterFonts _printerFonts() {
    final font = _preferences.printerSetting().fonts!;
    return PrinterFonts(
      smallFontSize: font.smallFontSize.toDouble(),
      regularFontSize: font.regularFontSize.toDouble(),
      mediumFontSize: font.mediumFontSize.toDouble(),
      largeFontSize: font.largeFontSize.toDouble(),
      extraLargeFontSize: font.extraLargeFontSize.toDouble(),
    );
  }

  Future<List<int>?> _generatePrintingData({
    required Order order,
    required int docketType,
  }) async {
    final rollSize = _preferences.printerSetting().paperSize.toRollSize();
    final templateOrder = await _generateTemplateOrder(order);
    List<int>? rawBytes = await DocketDesignTemplate().generateTicket(
      templateOrder,
      PrinterConfiguration(
        docket: docketType == DocketType.customer
            ? Docket.customer
            : Docket.kitchen,
        roll: rollSize,
        fontSize: _printerFonts(),
      ),
    );
    return rawBytes;
  }

  void _showPreview({
    required Order order,
    required int docketType,
  }) async {
    final rollSize = _preferences.printerSetting().paperSize.toRollSize();
    final templateOrder = await _generateTemplateOrder(order);
    final pdfImage = await DocketDesignTemplate().generatePdfImage(
      templateOrder,
      PrinterConfiguration(
        docket: docketType == DocketType.customer
            ? Docket.customer
            : Docket.kitchen,
        roll: rollSize,
        fontSize: _printerFonts(),
      ),
    );

    Navigator.push(
      RoutesGenerator.navigatorKey.currentState!.context,
      MaterialPageRoute(
        builder: (context) => CaptureImagePrivew(
          capturedImage: pdfImage,
        ),
      ),
    );
  }

  Future<TemplateOrder> _generateTemplateOrder(Order order) async {
    Brand? brand;
    if (order.brands.length == 1) {
      brand = await _infoProvider.findBrandById(order.brands.first.id);
    }
    return PrinterDataProvider().createTemplateOrderData(
      brand: brand,
      order: order,
    );
  }
}
