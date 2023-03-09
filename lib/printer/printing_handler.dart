import 'package:docket_design_template/docket_design_template.dart';
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
import 'package:klikit/printer/usb_printer_handler.dart';
import 'package:klikit/resources/strings.dart';

import '../modules/orders/domain/entities/order.dart';
import '../modules/orders/provider/order_information_provider.dart';

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

  void showDevices({Order? order}) async {
    final type = _preferences.printerSetting().connectionType;
    DeviceListBottomSheetManager().showBottomSheet(
      type: type == ConnectionType.BLUETOOTH
          ? ConnectionType.BLUETOOTH
          : ConnectionType.USB,
      devicesStream: type == ConnectionType.BLUETOOTH
          ? _bluetoothPrinterHandler.getDevices()
          : _usbPrinterHandler.getDevices(),
      onConnect: (device) async {
        final isSuccessfullyConnected = type == ConnectionType.BLUETOOTH
            ? await _bluetoothPrinterHandler.connect(device)
            : await _usbPrinterHandler.connect(device);
        if (isSuccessfullyConnected) {
          showSuccessSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            type == ConnectionType.BLUETOOTH
                ? AppStrings.bluetooth_successfully_connected.tr()
                : AppStrings.usb_successfully_connected.tr(),
          );
          if (order != null) {
            printDocket(order: order);
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

  void printDocket({required Order order, bool isAutoPrint = false}) async {
    if (_preferences.printerSetting().connectionType ==
        ConnectionType.BLUETOOTH) {
      if (_bluetoothPrinterHandler.isConnected()) {
        //_doAutoPrint(order);
        // if(isAutoPrint){
        //   _doAutoPrint(order);
        // }else{
        //   _doManualPrint(order);
        // }
      } else if (isAutoPrint) {
        showErrorSnackBar(
          RoutesGenerator.navigatorKey.currentState!.context,
          AppStrings.bluetooth_not_connected.tr(),
        );
      } else {
        showDevices(order: order);
      }
    } else {
      if (_usbPrinterHandler.isConnected()) {
        if(isAutoPrint){
          _doAutoPrint(order);
        }else{
          _doManualPrint(order);
        }
      } else if (isAutoPrint) {
        showErrorSnackBar(
          RoutesGenerator.navigatorKey.currentState!.context,
          AppStrings.usb_not_connected.tr(),
        );
      } else {
        showDevices(order: order);
      }
    }
  }

  void _doManualPrint(Order order) {
    showSelectDocketTypeDialog(
      onSelect: (type) async {
       // _showPreview(order: order, docketType: type);
        final printingData = await _generatePrintingData(order: order, docketType: type);
        if (printingData != null){
          if (_preferences.printerSetting().connectionType == ConnectionType.BLUETOOTH){
            _bluetoothPrinterHandler.printDocket(printingData);
          }else{
            _usbPrinterHandler.printDocket(printingData);
          }
        }
      },
    );
  }

  void _doAutoPrint(Order order) async{
    final printerSetting = _preferences.printerSetting();
    final customerCopy = await _generatePrintingData(order: order, docketType: DocketType.customer);
    final kitchenCopy = await _generatePrintingData(order: order, docketType: DocketType.kitchen);
    if (printerSetting.connectionType == ConnectionType.BLUETOOTH){
      if(printerSetting.customerCopyEnabled){
        if(customerCopy != null){
          for (int i=0; i< printerSetting.customerCopyCount; i++) {
            await _bluetoothPrinterHandler.printDocket(customerCopy);
          }
        }
      }
      if(printerSetting.kitchenCopyEnabled && printerSetting.kitchenCopyCount > ZERO){
        if(kitchenCopy != null){
          for (int i=0; i< printerSetting.kitchenCopyCount; i++){
            await _bluetoothPrinterHandler.printDocket(kitchenCopy);
          }
        }
      }
    }else{
      if(printerSetting.customerCopyEnabled){
        if(customerCopy != null){
          for (int i=0; i< printerSetting.customerCopyCount; i++) {
            await _usbPrinterHandler.printDocket(customerCopy);
          }
        }
      }
      if(printerSetting.kitchenCopyEnabled && printerSetting.kitchenCopyCount > ZERO){
        if(kitchenCopy != null){
          for (int i=0; i< printerSetting.kitchenCopyCount; i++) {
            await _usbPrinterHandler.printDocket(kitchenCopy);
          }
        }
      }
    }
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
