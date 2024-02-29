import 'dart:typed_data';
import 'dart:ui';

import 'package:docket_design_template/common_design_template.dart';
import 'package:docket_design_template/common_zreport_template.dart';
import 'package:docket_design_template/docket_design_template.dart';
import 'package:docket_design_template/model/font_size.dart';
import 'package:docket_design_template/model/order.dart';
import 'package:docket_design_template/sunmi_design_template.dart';
import 'package:docket_design_template/sunmi_zreport_design_template.dart';
import 'package:docket_design_template/utils/printer_configuration.dart';
import 'package:docket_design_template/zreport_design_template.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/language/language_manager.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/modules/home/data/model/z_report_data_model.dart';
import 'package:klikit/printer/bluetooth_printer_handler.dart';
import 'package:klikit/printer/data/printer_data_provider.dart';
import 'package:klikit/printer/data/sticker_docket_generator.dart';
import 'package:klikit/printer/network_printer_handler.dart';
import 'package:klikit/printer/presentation/device_list_bottom_sheet.dart';
import 'package:klikit/printer/presentation/select_docket_type_dialog.dart';
import 'package:klikit/printer/printer_handler.dart';
import 'package:klikit/printer/printer_local_data_manager.dart';
import 'package:klikit/printer/sticker_printer_handler.dart';
import 'package:klikit/printer/usb_printer_handler.dart';

import '../core/utils/permission_handler.dart';
import '../modules/common/business_information_provider.dart';
import '../modules/orders/domain/entities/cart.dart';
import '../modules/orders/domain/entities/order.dart';
import 'data/z_report_data_mapper.dart';

class PrinterManager {
  final AppPreferences _preferences;
  final BusinessInformationProvider _infoProvider;

  PrinterManager(this._preferences, this._infoProvider);

  Future<bool> _isPermissionGranted() async {
    return await PermissionHandler().isLocationPermissionGranted();
  }

  PrinterHandler printerHandler() {
    switch (LocalPrinterDataManager().cType()) {
      case CType.USB:
        return UsbPrinterHandler();
      case CType.WIFI:
        return NetworkPrinterHandler();
      default:
        return BluetoothPrinterHandler();
    }
  }

  void showPrinterDevicesForConnect({required int initialIndex, Uint8List? stickerPrintingData}) async {
    if (await _isPermissionGranted()) {
      final handler = printerHandler();
      DeviceListBottomSheetManager().showDeviceListBottomSheet(
        initialIndex: initialIndex,
        handler: handler,
        onStickerPrinterConnected: (device) async {
          if (initialIndex == PrinterTab.STICKER && stickerPrintingData != null) {
            await StickerPrinterHandler().print(stickerPrintingData);
          }
        },
      );
    }
  }

  void doForegroundManualDocketPrinting(Order order) async {
    if (await _isPermissionGranted()) {
      showSelectDocketTypeDialog(
        onSelect: (type) async {
          final deviceType = LocalPrinterDataManager().activeDevice();
          final locale = getIt<LanguageManager>().getCurrentLocale();
          List<int>? printingData;
          if (deviceType == Device.android) {
            printingData = await _generateDocketTicket(order: order, docketType: type, printingType: PrintingType.manual, locale: locale);
          } else if (deviceType == Device.imin) {
            final templateOrder = await _generateTemplateOrder(order);
            final rollSize = _preferences.printerSetting().paperSize.toRollSize();
            printingData = await CommonDesignTemplate().generateTicket(
              order: templateOrder,
              roll: rollSize,
              printingType: PrintingType.manual,
              isConsumerCopy: type == DocketType.customer,
              locale: locale,
            );
          }
          await _doPrinting(
            order: order,
            printingType: PrintingType.manual,
            type: type,
            iminPrinterHandler: BluetoothPrinterHandler(),
            androidPrinterHandler: printerHandler(),
            isFromBackground: false,
            printingData: printingData,
          );
        },
      );
    }
  }

  Future<void> doAutoDocketPrinting({
    required Order order,
    required bool isFromBackground,
  }) async {
    final printerSetting = _preferences.printerSetting();
    final iminPrinterHandler = BluetoothPrinterHandler();
    final androidPrinterHandler = printerHandler();
    final deviceType = LocalPrinterDataManager().activeDevice();
    final locale = getIt<LanguageManager>().getCurrentLocale();
    List<int>? customerPrintingData;
    List<int>? kitchenPrintingData;
    if (deviceType == Device.android) {
      customerPrintingData = await _generateDocketTicket(order: order, docketType: DocketType.customer, printingType: PrintingType.auto, locale: locale);
      kitchenPrintingData = await _generateDocketTicket(order: order, docketType: DocketType.kitchen, printingType: PrintingType.auto, locale: locale);
    } else if (deviceType == Device.imin) {
      final templateOrder = await _generateTemplateOrder(order);
      final rollSize = _preferences.printerSetting().paperSize.toRollSize();
      customerPrintingData = await CommonDesignTemplate().generateTicket(
        order: templateOrder,
        roll: rollSize,
        printingType: PrintingType.auto,
        isConsumerCopy: true,
        locale: locale,
      );
      kitchenPrintingData = await CommonDesignTemplate().generateTicket(
        order: templateOrder,
        roll: rollSize,
        printingType: PrintingType.auto,
        isConsumerCopy: false,
        locale: locale,
      );
    }
    if (printerSetting.customerCopyEnabled) {
      for (int i = 0; i < printerSetting.customerCopyCount; i++) {
        final succeed = await _doPrinting(
          order: order,
          printingType: PrintingType.auto,
          type: DocketType.customer,
          iminPrinterHandler: iminPrinterHandler,
          androidPrinterHandler: androidPrinterHandler,
          isFromBackground: isFromBackground,
          printingData: customerPrintingData,
        );
        if (!succeed) return;
        await Future.delayed(const Duration(milliseconds: 500));
      }
    }
    if (printerSetting.kitchenCopyEnabled && printerSetting.kitchenCopyCount > ZERO) {
      for (int i = 0; i < printerSetting.kitchenCopyCount; i++) {
        final succeed = await _doPrinting(
          order: order,
          printingType: PrintingType.auto,
          type: DocketType.kitchen,
          iminPrinterHandler: iminPrinterHandler,
          androidPrinterHandler: androidPrinterHandler,
          isFromBackground: isFromBackground,
          printingData: kitchenPrintingData,
        );
        if (!succeed) return;
      }
    }
  }

  Future<bool> _doPrinting({
    required Order order,
    required PrintingType printingType,
    required int type,
    required bool isFromBackground,
    required List<int>? printingData,
    PrinterHandler? androidPrinterHandler,
    PrinterHandler? iminPrinterHandler,
  }) async {
    final localPrinter = LocalPrinterDataManager().localPrinter();
    final deviceType = LocalPrinterDataManager().activeDevice();
    final locale = getIt<LanguageManager>().getCurrentLocale();
    if (deviceType == Device.sunmi) {
      final templateOrder = await _generateTemplateOrder(order);
      final rollSize = _preferences.printerSetting().paperSize.toRollSize();
      final fontId = _preferences.printerSetting().fontId;
      await SunmiDesignTemplate().printSunmi(
        order: templateOrder,
        printerConfiguration: PrinterConfiguration(
          docket: type == DocketType.customer ? Docket.customer : Docket.kitchen,
          roll: rollSize,
          fontSize: _printerFonts(),
          printingType: printingType,
        ),
        fontId: fontId,
        locale: locale,
      );
    } else if (deviceType == Device.imin) {
      if (localPrinter?.deviceType == CType.BLE && printingData != null) {
        await iminPrinterHandler?.print(data: printingData, localPrinter: localPrinter, isFromBackground: isFromBackground);
      }
    } else {
      if (printingData != null) {
        final isSucceed = await androidPrinterHandler?.print(data: printingData, localPrinter: localPrinter, isFromBackground: isFromBackground);
        return isSucceed ?? false;
      }
    }
    return true;
  }

  void printSticker(Order order, CartV2 item) async {
    final command = StickerDocketGenerator().generateDocket(order, item);
    if (StickerPrinterHandler().connectedDevice() != null) {
      StickerPrinterHandler().print(command);
    } else {
      showPrinterDevicesForConnect(initialIndex: PrinterTab.STICKER, stickerPrintingData: command);
    }
  }

  void printZReport(ZReportData model, DateTime reportDate, {DateTime? reportEndDate, required Locale locale}) async {
    final localPrinter = LocalPrinterDataManager().localPrinter();
    final deviceType = LocalPrinterDataManager().activeDevice();
    final rollSize = _preferences.printerSetting().paperSize.toRollSize();
    final cType = LocalPrinterDataManager().cType();
    final locale = getIt<LanguageManager>().getCurrentLocale();
    final data = await ZReportDataProvider().generateTemplateData(model, reportDate, reportEndTime: reportEndDate);
    if (deviceType == Device.sunmi) {
      await SunmiZReportPrinter().printZReport(data, rollSize, locale);
    } else if (deviceType == Device.imin) {
      var printingData = await CommonZReportTemplate().generateZTicket(data: data, roll: rollSize, locale: locale);
      if (localPrinter?.deviceType == CType.BLE) {
        await BluetoothPrinterHandler().print(data: printingData, localPrinter: localPrinter, isFromBackground: false);
      }
    } else {
      final printingData = await _generateZReportTicket(model, reportDate, reportEndDate: reportEndDate, locale: locale);
      if (localPrinter?.deviceType == cType && printingData != null) {
        await printerHandler().print(data: printingData, localPrinter: localPrinter, isFromBackground: false);
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
    required Locale locale,
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
      locale,
    );
    return rawBytes;
  }

  Future<List<int>?> _generateZReportTicket(
    ZReportData dataModel,
    DateTime reportTime, {
    DateTime? reportEndDate,
    required Locale locale,
  }) async {
    final data = await ZReportDataProvider().generateTemplateData(dataModel, reportTime, reportEndTime: reportEndDate);
    final rollSize = _preferences.printerSetting().paperSize.toRollSize();
    final printingData = await ZReportDesignTemplate().generateTicket(
      data,
      PrinterConfiguration(
        docket: Docket.customer,
        roll: rollSize,
        fontSize: _printerFonts(),
        printingType: PrintingType.manual,
      ),
      locale,
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
