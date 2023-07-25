import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/printer/presentation/pos_printer_devices.dart';
import 'package:klikit/printer/presentation/sticker_printer_devices.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

class DeviceListBottomSheetManager {
  static final _instance = DeviceListBottomSheetManager._internal();

  factory DeviceListBottomSheetManager() => _instance;

  DeviceListBottomSheetManager._internal();

  bool _isAlreadyShowing = false;

  void showBottomSheet({
    required int type,
    required int initialIndex,
    required Function(PrinterDevice) onPOSConnect,
    required Function(BluetoothDevice) onStickerConnect,
  }) {
    if (!_isAlreadyShowing) {
      _isAlreadyShowing = true;
      _showDeviceListBottomSheet(
        type: type,
        initialIndex: initialIndex,
        onPOSConnect: onPOSConnect,
        onStickerConnect: onStickerConnect,
      );
    }
  }

  void _showDeviceListBottomSheet({
    required int type,
    required int initialIndex,
    required Function(PrinterDevice) onPOSConnect,
    required Function(BluetoothDevice) onStickerConnect,
  }) {
    showModalBottomSheet<void>(
      context: RoutesGenerator.navigatorKey.currentState!.context,
      isDismissible: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppSize.s16),
        ),
      ),
      builder: (context) => DefaultTabController(
        length: 2,
        initialIndex: initialIndex,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          extendBody: false,
          appBar: AppBar(
            backgroundColor: AppColors.whiteSmoke,
            centerTitle: true,
            leading: const SizedBox(),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppSize.s16),
              ),
            ),
            bottom: TabBar(
              indicatorColor: AppColors.purpleBlue,
              unselectedLabelColor: AppColors.darkGrey,
              labelColor: AppColors.purpleBlue,
              labelStyle: TextStyle(
                fontSize: AppFontSize.s14.rSp,
              ),
              tabs: const [
                Tab(icon: Text('Docket')),
                Tab(icon: Text('Sticker')),
              ],
            ),
            title: Text(
              type == ConnectionType.BLUETOOTH
                  ? AppStrings.bluetooth_devices.tr()
                  : AppStrings.usb_devices.tr(),
              style: mediumTextStyle(
                color: AppColors.darkGrey,
                fontSize: AppSize.s18.rSp,
              ),
            ),
          ),
          body: Container(
            color: AppColors.whiteSmoke,
            child: TabBarView(
              children: [
                PosPrinterDevicesView(
                  type: type,
                  onConnect: onPOSConnect,
                ),
                StickerPrinterDevices(
                  onConnect: onStickerConnect,
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((value) => _isAlreadyShowing = false);
  }
}
