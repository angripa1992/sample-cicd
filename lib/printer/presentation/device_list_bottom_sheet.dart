import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/widgets/loading_button.dart';
import 'package:klikit/printer/usb_printer_handler.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

void showBleDeviceListView({
  required Function(BluetoothDevice) onConnect,
  required List<BluetoothDevice> devices,
}) {
  showDeviceListBottomSheet(
    title: 'Bluetooth Devices',
    deviceList: Expanded(
      child: devices.isEmpty
          ? Center(
              child: Text(
                AppStrings.no_bluetooth_devices_message.tr(),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return deviceItemView(
                  icon: Icons.bluetooth,
                  name: devices[index].name ?? 'Unknown Device',
                  onConnect: () {
                    onConnect(devices[index]);
                  },
                );
              },
            ),
    ),
  );
}

void showUsbDeviceListView({
  required Function(UsbDevice) onConnect,
  required List<UsbDevice> devices,
}) {
  showDeviceListBottomSheet(
    title: 'USB Devices',
    deviceList: Expanded(
      child: devices.isEmpty
          ? Center(
              child: Text(
                AppStrings.no_usb_devices_message.tr(),
                textAlign: TextAlign.center,
              ),
            )
          : ListView.builder(
              itemCount: devices.length,
              itemBuilder: (context, index) {
                return deviceItemView(
                  icon: Icons.usb,
                  name: devices[index].name,
                  onConnect: () {
                    onConnect(devices[index]);
                  },
                );
              },
            ),
    ),
  );
}

void showDeviceListBottomSheet(
    {required String title, required Widget deviceList}) {
  showModalBottomSheet<void>(
    context: RoutesGenerator.navigatorKey.currentState!.context,
    isScrollControlled: true,
    isDismissible: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(AppSize.s16),
      ),
    ),
    builder: (context) => DraggableScrollableSheet(
      initialChildSize: 0.65,
      minChildSize: 0.65,
      maxChildSize: 0.65,
      expand: false,
      builder: (_, controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            decoration: BoxDecoration(
              color: AppColors.purpleBlue,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(AppSize.s16),
                topRight: Radius.circular(AppSize.s16),
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.remove,
                    color: AppColors.lightGrey,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: AppSize.s12.rh, top: AppSize.s4.rh),
                    child: Text(
                      title,
                      style: getBoldTextStyle(
                        color: AppColors.white,
                        fontSize: AppSize.s18.rSp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          deviceList,
        ],
      ),
    ),
  );
}

Widget deviceItemView({
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
              textColor: AppColors.purpleBlue,
              onTap: () {
                Navigator.pop(
                    RoutesGenerator.navigatorKey.currentState!.context);
                onConnect();
              },
              text: 'Connect',
            ),
          ],
        ),
      ),
      const Divider(),
    ],
  );
}

void showNoDeviceConnectedDialog({
  required int connectionType,
  required VoidCallback onOK,
}) {
  showDialog(
    context: RoutesGenerator.navigatorKey.currentState!.context,
    barrierDismissible: false,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppSize.s16.rSp))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              connectionType == ConnectionType.BLUETOOTH
                  ? 'No Bluetooth Devices'
                  : 'No USB Devices',
              style: getMediumTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s18.rSp,
              ),
            ),
            SizedBox(
              height: AppSize.s16.rh,
            ),
            Text(
              connectionType == ConnectionType.BLUETOOTH
                  ? AppStrings.no_bluetooth_devices_message.tr()
                  : AppStrings.no_usb_devices_message.tr(),
              textAlign: TextAlign.center,
              style: getRegularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
            SizedBox(
              height: AppSize.s16.rh,
            ),
            const Divider(),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onOK();
              },
              child: Center(
                child: Text(
                  AppStrings.ok.tr(),
                  style: getRegularTextStyle(
                    color: AppColors.purpleBlue,
                    fontSize: AppFontSize.s16.rSp,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
