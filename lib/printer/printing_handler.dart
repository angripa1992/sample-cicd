import 'dart:typed_data';

import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as im;
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/core/utils/permission_handler.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/printer/bluetooth_printer_handler.dart';
import 'package:klikit/printer/presentation/device_list_bottom_sheet.dart';
import 'package:klikit/printer/presentation/docket_design.dart';
import 'package:klikit/printer/usb_printer_handler.dart';
import 'package:screenshot/screenshot.dart';

import '../modules/orders/domain/entities/order.dart';

class PrintingHandler {
  final AppPreferences _preferences;
  final BluetoothPrinterHandler _bluetoothPrinterHandler;
  final UsbPrinterHandler _usbPrinterHandler;
  final _screenshotController = ScreenshotController();

  PrintingHandler(this._preferences, this._bluetoothPrinterHandler,
      this._usbPrinterHandler);

  Future<bool> _isPermissionGranted() async {
    if (await PermissionHandler().isLocationPermissionGranted()) {
      return true;
    } else {
      return await PermissionHandler().requestLocationPermission();
    }
  }

  void verifyConnection({Order? order}) async {
    if (_preferences.connectionType() == ConnectionType.BLUETOOTH) {
      _verifyBleConnection(order: order);
    } else {
      _verifyUsbConnection(order: order);
    }
  }

  void _verifyBleConnection({Order? order}) async {
    if (await _isPermissionGranted()) {
      if (await _bluetoothPrinterHandler.isBluetoothOn()) {
        if (!await _bluetoothPrinterHandler.isConnected()) {
          showBleDevices(order: order);
        }else if (order != null){
          printDocket(order);
        }
      } else {
        showErrorSnackBar(
          RoutesGenerator.navigatorKey.currentState!.context,
          'Please switch On your bluetooth',
        );
      }
    }
  }

  void showBleDevices({Order? order}) async {
    final devices = await _bluetoothPrinterHandler.getDevices();
    showBleDeviceListView(
      devices: devices,
      onConnect: (device) async {
        final isConnected = await _bluetoothPrinterHandler.connect(device);
        if (isConnected) {
          showSuccessSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            'Bluetooth Successfully Connected',
          );
          if(order != null){
            printDocket(order);
          }
        } else {
          showErrorSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            'Can not connect to this device',
          );
        }
      },
    );
  }

  void _verifyUsbConnection({Order? order}) {
    if (!_usbPrinterHandler.isConnected()) {
      showUsbDevices(order: order);
    }else if (order != null){
      printDocket(order);
    }
  }

  void showUsbDevices({Order? order}) async {
    final devices = await _usbPrinterHandler.getDevices();
    showUsbDeviceListView(
      devices: devices,
      onConnect: (device) async {
        final isSuccessfullyConnected = await _usbPrinterHandler.connect(device);
        if (isSuccessfullyConnected) {
          showSuccessSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            'USB Successfully Connected',
          );
          if(order != null){
            printDocket(order);
          }
        } else {
          showErrorSnackBar(
            RoutesGenerator.navigatorKey.currentState!.context,
            'Can not connect to this device',
          );
        }
      },
    );
  }

  void printDocket(Order order) async {
    // Navigator.push(RoutesGenerator.navigatorKey.currentState!.context,
    //     MaterialPageRoute(builder: (context) => DocketDesign(order: order)));

    Uint8List? bytes = await _capturePng(order);
    List<int>? rawBytes = await _ticket(bytes!);
    if (_preferences.connectionType() == ConnectionType.BLUETOOTH) {
      if (await _bluetoothPrinterHandler.isConnected()) {
        _bluetoothPrinterHandler.printDocket(Uint8List.fromList(rawBytes!));
      } else {
        // showNoDeviceConnectedDialog(
        //   connectionType: ConnectionType.BLUETOOTH,
        //   onOK: () {},
        // );
        showBleDevices(order: order);
      }
    } else {
      if (_usbPrinterHandler.isConnected()) {
        _usbPrinterHandler.print(rawBytes!);
      } else {
        // showNoDeviceConnectedDialog(
        //   connectionType: ConnectionType.USB,
        //   onOK: () {},
        // );
        showUsbDevices(order: order);
      }
    }
  }

  Future<Uint8List?> _capturePng(Order order) async {
    try {
      Uint8List pngBytes = await _screenshotController.captureFromWidget(
        DocketDesign(order: order),
        pixelRatio: 2.0,
      );
      return pngBytes;
    } catch (e) {
      //ignored
    }
    return null;
  }

  Future<List<int>?> _ticket(Uint8List headerBytes) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm80, profile);
    List<int> bytes = [];
    final im.Image? headerImg = im.decodeImage(headerBytes);
    bytes += generator.image(headerImg!);
    bytes += generator.feed(2);
    bytes += generator.cut();
    return bytes;
  }
}
