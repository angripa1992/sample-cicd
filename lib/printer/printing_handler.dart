import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/core/utils/permission_handler.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/printer/bluetooth_printer_handler.dart';
import 'package:klikit/printer/presentation/capture_image_preview.dart';
import 'package:klikit/printer/presentation/device_list_bottom_sheet.dart';
import 'package:klikit/printer/presentation/docket_design_pdf.dart';
import 'package:klikit/printer/usb_printer_handler.dart';
import 'package:klikit/resources/strings.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';

import '../modules/orders/domain/entities/order.dart';

class PrintingHandler {
  final AppPreferences _preferences;
  final BluetoothPrinterHandler _bluetoothPrinterHandler;
  final UsbPrinterHandler _usbPrinterHandler;

  PrintingHandler(
    this._preferences,
    this._bluetoothPrinterHandler,
    this._usbPrinterHandler,
  );

  Future<bool> _isPermissionGranted() async {
    if (await PermissionHandler().isLocationPermissionGranted()) {
      return true;
    } else {
      return await PermissionHandler().requestLocationPermission();
    }
  }

  void verifyConnection({required bool fromNotification, Order? order}) async {
    if (_preferences.connectionType() == ConnectionType.BLUETOOTH) {
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
    List<int> rawBytes = await _ticket(order);
    // if (_preferences.connectionType() == ConnectionType.BLUETOOTH) {
    //   if (_bluetoothPrinterHandler.isConnected()) {
    //     _bluetoothPrinterHandler.printDocket(rawBytes);
    //   } else {
    //     showBleDevices(order: order);
    //   }
    // } else {
    //   if (_usbPrinterHandler.isConnected()) {
    //     _usbPrinterHandler.printDocket(rawBytes);
    //   } else {
    //     showUsbDevices(order: order);
    //   }
    // }
  }

  // Future<Uint8List?> _capturePng(Order order) async {
  //   try {
  //     Uint8List? pngBytes = await _screenshotController.captureFromWidget(
  //       DocketDesign(order: order),
  //       pixelRatio: 2.0,
  //     );
  //     return pngBytes;
  //   } catch (e) {
  //     //ignored
  //   }
  //   return null;
  // }

  // Future<List<int>?> _ticket(Uint8List headerBytes) async {
  //   final profile = await CapabilityProfile.load();
  //   final generator = Generator(PaperSize.mm80, profile);
  //   List<int> bytes = [];
  //   final im.Image? headerImg = im.decodeImage(headerBytes);
  //   bytes += generator.image(headerImg!);
  //   bytes += generator.feed(2);
  //   bytes += generator.cut();
  //   return bytes;
  // }

  Future<List<int>> _ticket(Order order) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];

    var epoch = DateTime.now().millisecondsSinceEpoch;

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/pos_$epoch.pdf');
    await file.writeAsBytes(await DocketDesignPdf().generateTicket(order));

    final document = await PdfDocument.openFile(file.path);

    var page = await document.getPage(1);

    final pageImage = await page.render(
      // rendered image width resolution, required
      width: page.width * 2,
      // rendered image height resolution, required
      height: page.height * 2,

      // Rendered image compression format, also can be PNG, WEBP*
      // Optional, default: PdfPageImageFormat.PNG
      // Web not supported
      format: PdfPageImageFormat.png,

      // Image background fill color for JPEG
      // Optional, default '#ffffff'
      // Web not supported
      backgroundColor: '#ffffff',

      // Crop rect in image for render
      // Optional, default null
      // Web not supported
    );

    var headerBytes = pageImage?.bytes;
    Navigator.push(
        RoutesGenerator.navigatorKey.currentState!.context,
        MaterialPageRoute(
            builder: (context) => CaptureImagePrivew(
              capturedImage: headerBytes,
            )));

    final im.Image? headerImg = im.decodeImage(headerBytes!);

    bytes += generator.image(headerImg!);
    bytes += generator.feed(2);
    bytes += generator.cut();

    await _deleteFile(file.path);

    return bytes;
  }

  Future _deleteFile(String filePath) async {
    try {
      File file = File(filePath);
      await file.delete();
    } catch (e) {
      //ignored
    }
  }
}
