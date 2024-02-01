import 'dart:convert';

import 'package:docket_design_template/common_design_template.dart';
import 'package:docket_design_template/common_zreport_template.dart';
import 'package:docket_design_template/docket_design_template.dart';
import 'package:docket_design_template/model/font_size.dart';
import 'package:docket_design_template/model/order.dart';
import 'package:docket_design_template/sunmi_design_template.dart';
import 'package:docket_design_template/sunmi_zreport_design_template.dart';
import 'package:docket_design_template/utils/printer_configuration.dart';
import 'package:docket_design_template/zreport_design_template.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/modules/home/data/model/z_report_data_model.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/printer/bluetooth_printer_handler.dart';
import 'package:klikit/printer/data/printer_data_provider.dart';
import 'package:klikit/printer/data/sticker_docket_generator.dart';
import 'package:klikit/printer/presentation/device_list_bottom_sheet.dart';
import 'package:klikit/printer/presentation/select_docket_type_dialog.dart';
import 'package:klikit/printer/sticker_printer_handler.dart';
import 'package:klikit/printer/usb_printer_handler.dart';
import 'package:klikit/resources/strings.dart';

import '../core/utils/permission_handler.dart';
import '../modules/common/business_information_provider.dart';
import '../modules/orders/domain/entities/cart.dart';
import '../modules/orders/domain/entities/order.dart';
import 'data/z_report_data_mapper.dart';

class PrintingHandler {
  final AppPreferences _preferences;
  final BusinessInformationProvider _infoProvider;

  PrintingHandler(this._preferences, this._infoProvider);

  Future<bool> _isPermissionGranted() async {
    return await PermissionHandler().isLocationPermissionGranted();
  }

  void showDevices({Order? order, required int initialIndex}) async {
    final type = _preferences.printerSetting().type;
    if (await _isPermissionGranted()) {
      DeviceListBottomSheetManager().showBottomSheet(
        initialIndex: initialIndex,
        type: type,
        onPOSConnect: (device) async {
          final isSuccessfullyConnected = type == CType.BLE ? await BluetoothPrinterHandler().connect(device) : await UsbPrinterHandler().connect(device);
          if (isSuccessfullyConnected) {
            showSuccessSnackBar(RoutesGenerator.navigatorKey.currentState!.context, type == CType.BLE ? AppStrings.bluetooth_successfully_connected.tr() : AppStrings.usb_successfully_connected.tr());
            if (order != null) {
              printDocket(order: order, willPrintSticker: false);
            }
          } else {
            showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context, AppStrings.can_not_connect_device.tr());
          }
        },
        onStickerConnect: (stickerDevice) async {
          final isConnected = await StickerPrinterHandler().connect(stickerDevice);
          if (isConnected) {
            showSuccessSnackBar(RoutesGenerator.navigatorKey.currentState!.context, "Sticker Printer Successfully Connected");
          } else {
            showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context, AppStrings.can_not_connect_device.tr());
          }
        },
      );
    }
  }

  void printDocket({required Order order, bool isAutoPrint = false, bool willPrintSticker = true}) async {
    if (await _isPermissionGranted()) {
      if (SessionManager().isSunmiDevice()) {
        if (isAutoPrint) {
          await _sunmiAutoPrint(order);
        } else {
          _doManualPrint(order);
        }
      }
      else if (SessionManager().getActiveDevice() == Device.imin) {
        if (isAutoPrint) {
          await _iminAutoPrint(order);
        } else {
          _doManualPrint(order);
        }
      }
      else if (_preferences.printerSetting().type == CType.BLE) {
        if (BluetoothPrinterHandler().isConnected()) {
          if (isAutoPrint) {
            _bluetoothAutoPrint(order);
          } else {
            _doManualPrint(order);
          }
        } else {
          showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context, AppStrings.bluetooth_not_connected.tr());
        }
      } else {
        if (UsbPrinterHandler().isConnected()) {
          if (isAutoPrint) {
            _usbAutoPrint(order);
          } else {
            _doManualPrint(order);
          }
        } else {
          showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context, AppStrings.usb_not_connected.tr());
        }
      }
    }
  }

  void _doManualPrint(Order order) {
    showSelectDocketTypeDialog(
      onSelect: (type) async {
        final templateOrder = await _generateTemplateOrder(order);

        if (SessionManager().isSunmiDevice()) {
          final rollSize = _preferences.printerSetting().paperSize.toRollSize();
          final templateOrder = await _generateTemplateOrder(order);
          await SunmiDesignTemplate().printSunmi(
            order: templateOrder,
            isCustomerCopy: type == DocketType.customer,
            roll: rollSize,
            printingType: PrintingType.manual,
          );
        }else if(SessionManager().getActiveDevice() == Device.imin){
          final rollSize = _preferences.printerSetting().paperSize.toRollSize();
          var printerAddress = _preferences.getPrinterAddress();
          final printingData = await CommonDesignTemplate().generateTicket(order: templateOrder,
            roll: rollSize,
            printingType: PrintingType.manual,
            isConsumerCopy: type == DocketType.customer);
          await BluetoothPrinterHandler().print(printingData!,printerAddress);
        } else {
          final printingData = await _generateDocketTicket(
            order: order,
            docketType: type,
            printingType: PrintingType.manual,
          );
          if (printingData != null) {
            if (_preferences.printerSetting().type == CType.BLE) {
              await BluetoothPrinterHandler().printDocket(printingData);
            } else {
              await UsbPrinterHandler().printDocket(printingData);
            }
          }
        }
      },
    );
  }

  void _bluetoothAutoPrint(Order order) async {
    final printerSetting = _preferences.printerSetting();
    final customerCopy = await _generateDocketTicket(
      order: order,
      docketType: DocketType.customer,
      printingType: PrintingType.auto,
    );
    final kitchenCopy = await _generateDocketTicket(
      order: order,
      docketType: DocketType.kitchen,
      printingType: PrintingType.auto,
    );
    if (printerSetting.customerCopyEnabled) {
      if (customerCopy != null) {
        for (int i = 0; i < printerSetting.customerCopyCount; i++) {
          await BluetoothPrinterHandler().printDocket(customerCopy);
        }
      }
    }
    if (printerSetting.kitchenCopyEnabled && printerSetting.kitchenCopyCount > ZERO) {
      if (kitchenCopy != null) {
        for (int i = 0; i < printerSetting.kitchenCopyCount; i++) {
          await BluetoothPrinterHandler().printDocket(kitchenCopy);
        }
      }
    }
  }

  void _usbAutoPrint(Order order) async {
    final printerSetting = _preferences.printerSetting();
    final customerCopy = await _generateDocketTicket(
      order: order,
      docketType: DocketType.customer,
      printingType: PrintingType.auto,
    );
    final kitchenCopy = await _generateDocketTicket(
      order: order,
      docketType: DocketType.kitchen,
      printingType: PrintingType.auto,
    );
    if (printerSetting.customerCopyEnabled) {
      if (customerCopy != null) {
        for (int i = 0; i < printerSetting.customerCopyCount; i++) {
          await UsbPrinterHandler().printDocket(customerCopy);
        }
      }
    }
    if (printerSetting.kitchenCopyEnabled && printerSetting.kitchenCopyCount > ZERO) {
      if (kitchenCopy != null) {
        for (int i = 0; i < printerSetting.kitchenCopyCount; i++) {
          await UsbPrinterHandler().printDocket(kitchenCopy);
        }
      }
    }
  }

  Future<void> _sunmiAutoPrint(Order order) async {
    final printerSetting = _preferences.printerSetting();
    final templateOrder = await _generateTemplateOrder(order);
    final rollSize = _preferences.printerSetting().paperSize.toRollSize();
    if (printerSetting.customerCopyEnabled) {
      for (int i = 0; i < printerSetting.customerCopyCount; i++) {
        await SunmiDesignTemplate().printSunmi(
          order: templateOrder,
          isCustomerCopy: true,
          roll: rollSize,
          printingType: PrintingType.auto,
        );
      }
    }
    if (printerSetting.kitchenCopyEnabled && printerSetting.kitchenCopyCount > ZERO) {
      await SunmiDesignTemplate().printSunmi(
        order: templateOrder,
        isCustomerCopy: false,
        roll: rollSize,
        printingType: PrintingType.auto,
      );
    }
  }

  Future<void> _iminAutoPrint(Order order) async {
    final printerSetting = _preferences.printerSetting();
    final printerAddress = _preferences.getPrinterAddress();
    final templateOrder = await _generateTemplateOrder(order);
    final rollSize = _preferences.printerSetting().paperSize.toRollSize();
    if (printerSetting.customerCopyEnabled) {
      for (int i = 0; i < printerSetting.customerCopyCount; i++) {
        final rollSize = _preferences.printerSetting().paperSize.toRollSize();
        // final rollSize = _preferences.printerSetting().paperSize.toRollSize();

        final printingData = await CommonDesignTemplate().generateTicket(order: templateOrder,
          roll: rollSize,
          printingType: PrintingType.auto,
          isConsumerCopy: true,);
        await BluetoothPrinterHandler().print(printingData!,printerAddress);
      }
    }
    if (printerSetting.kitchenCopyEnabled && printerSetting.kitchenCopyCount > ZERO) {
      final printingData = await CommonDesignTemplate().generateTicket(order: templateOrder,
        roll: rollSize,
        printingType: PrintingType.auto,
        isConsumerCopy: false,);
      await BluetoothPrinterHandler().print(printingData!,printerAddress);
    }
  }

  void printSticker(Order order, CartV2 item) async {
    if (await StickerPrinterHandler().isConnected()) {
      final command = StickerDocketGenerator().generateDocket(order, item);
      StickerPrinterHandler().print(command);
    } else {
      showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context, 'Sticker printer not connected');
    }
  }

  void printZReport(ZReportData model, DateTime reportDate) async {
    if (SessionManager().getActiveDevice() == Device.imin) {
      final rollSize = _preferences.printerSetting().paperSize.toRollSize();
      final printerAddress = _preferences.getPrinterAddress();
      final data = await ZReportDataProvider().generateTemplateData(model, reportDate);
      var printingData = await CommonZReportTemplate().generateZTicket( data: data,roll:rollSize );
      await BluetoothPrinterHandler().print(printingData,printerAddress);
    }
    else if (SessionManager().isSunmiDevice()) {
      final rollSize = _preferences.printerSetting().paperSize.toRollSize();
      final data = await ZReportDataProvider().generateTemplateData(model, reportDate);
      await SunmiZReportPrinter().printZReport(data, rollSize);
    }
    else if (await _isPermissionGranted()) {
      if (_preferences.printerSetting().type == CType.BLE) {
        if (BluetoothPrinterHandler().isConnected()) {
          final printingData = await _generateZReportTicket(model, reportDate);
          if (printingData != null) {
            await BluetoothPrinterHandler().printDocket(printingData);
          }
        } else {
          showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context, AppStrings.bluetooth_not_connected.tr());
        }
      } else {
        if (UsbPrinterHandler().isConnected()) {
          final printingData = await _generateZReportTicket(model, reportDate);
          if (printingData != null) {
            await UsbPrinterHandler().printDocket(printingData);
          }
        } else {
          showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context, AppStrings.usb_not_connected.tr());
        }
      }
    }
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

  Future<List<int>?> _generateDocketTicket({
    required Order order,
    required int docketType,
    required PrintingType printingType,
  }) async {
    final rollSize = _preferences.printerSetting().paperSize.toRollSize();
    final templateOrder = await _generateTemplateOrder(order);
    List<int>? rawBytes = await DocketDesignTemplate().generateTicket(
      templateOrder,
      PrinterConfiguration(
        docket: docketType == DocketType.customer ? Docket.customer : Docket.kitchen,
        roll: rollSize,
        fontSize: _printerFonts(),
        printingType: printingType,
      ),
    );
    return rawBytes;
  }

  Future<List<int>?> _generateZReportTicket(
    ZReportData dataModel,
    DateTime reportTime,
  ) async {
    final data = await ZReportDataProvider().generateTemplateData(dataModel, reportTime);
    final rollSize = _preferences.printerSetting().paperSize.toRollSize();
    final printingData = await ZReportDesignTemplate().generateTicket(
      data,
      PrinterConfiguration(
        docket: Docket.customer,
        roll: rollSize,
        fontSize: _printerFonts(),
        printingType: PrintingType.manual,
      ),
    );
    return printingData;
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
}
