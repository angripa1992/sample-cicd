import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../bluetooth_printer_handler.dart';
import '../sticker_printer_handler.dart';
import '../usb_printer_handler.dart';

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
                Tab(
                  icon: Text('Docket'),
                ),
                Tab(
                  icon: Text('Sticker'),
                ),
              ],
            ),
            title: Text(
              type == ConnectionType.BLUETOOTH
                  ? AppStrings.bluetooth_devices.tr()
                  : AppStrings.usb_devices.tr(),
              style: getMediumTextStyle(
                color: AppColors.darkGrey,
                fontSize: AppSize.s18.rSp,
              ),
            ),
          ),
          body: Container(
            color: AppColors.whiteSmoke,
            child: TabBarView(
              children: [
                _posPrinter(
                  type: type,
                  onConnect: onPOSConnect,
                ),
                _stickerPrinter(
                  onConnect: onStickerConnect,
                ),
              ],
            ),
          ),
        ),
      ),
    ).then((value) => _isAlreadyShowing = false);
  }

  Widget _posPrinter({
    required int type,
    required Function(PrinterDevice) onConnect,
  }) {
    final items = <PrinterDevice>[];
    return StreamBuilder<PrinterDevice>(
      stream: type == ConnectionType.BLUETOOTH
          ? BluetoothPrinterHandler().getDevices()
          : UsbPrinterHandler().getDevices(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (!items.contains(snapshot.data)) {
            items.add(snapshot.data!);
          }
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          Center(
            child: Text(
              AppStrings.looking_for_devices.tr(),
              style: getRegularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          );
        }
        return items.isEmpty
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    type == ConnectionType.BLUETOOTH
                        ? AppStrings.no_bluetooth_devices_message.tr()
                        : AppStrings.no_usb_devices_message.tr(),
                    textAlign: TextAlign.center,
                    style: getRegularTextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return _deviceItemView(
                    icon: type == ConnectionType.BLUETOOTH
                        ? Icons.bluetooth
                        : Icons.usb,
                    name: items[index].name,
                    onConnect: () {
                      onConnect(items[index]);
                    },
                  );
                },
              );
      },
    );
  }

  Widget _stickerPrinter({required Function(BluetoothDevice) onConnect}) {
    return StreamBuilder<List<ScanResult>>(
      stream: StickerPrinterHandler().scanDevices(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final data = snapshot.data!;
          data.removeWhere((element) => element.device.name.isEmpty);
          return data.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppStrings.no_bluetooth_devices_message.tr(),
                      textAlign: TextAlign.center,
                      style: getRegularTextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return _deviceItemView(
                      icon: Icons.bluetooth,
                      name: data[index].device.name,
                      onConnect: () {
                        onConnect(data[index].device);
                      },
                    );
                  },
                );
        }else if(snapshot.connectionState == ConnectionState.waiting){
          return Center(
            child: Text(
              AppStrings.looking_for_devices.tr(),
              style: getRegularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          );
        }
        return Center(
          child: Text(
            AppStrings.no_bluetooth_devices.tr(),
            style: getRegularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        );
      },
    );
  }

  Widget _deviceItemView({
    required IconData icon,
    required String name,
    required VoidCallback onConnect,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: AppSize.s12,
            horizontal: AppSize.s16,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: AppColors.black),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: AppSize.s8),
                  child: Text(
                    name,
                    style: getRegularTextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.s16.rSp,
                    ),
                  ),
                ),
              ),
              LoadingButton(
                isLoading: false,
                verticalPadding: AppSize.s8,
                bgColor: Colors.transparent,
                textSize: AppFontSize.s12.rSp,
                borderRadius: AppSize.s16,
                textColor: AppColors.darkGrey,
                borderColor: AppColors.darkGrey,
                onTap: () {
                  onConnect();
                },
                text: AppStrings.connect.tr(),
              ),
            ],
          ),
        ),
        const Divider(),
      ],
    );
  }
}
