import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
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

class DeviceListBottomSheetManager {
  static final _instance = DeviceListBottomSheetManager._internal();

  factory DeviceListBottomSheetManager() => _instance;

  DeviceListBottomSheetManager._internal();

  bool _isAlreadyShowing = false;

  void showBottomSheet({
    required int type,
    required Function(PrinterDevice) onConnect,
    required Stream<PrinterDevice> devicesStream,
  }) {
    if (!_isAlreadyShowing) {
      _isAlreadyShowing = true;
      _showDeviceListBottomSheet(
        type: type,
        onConnect: onConnect,
        devicesStream: devicesStream,
      );
    }
  }

  void _showDeviceListBottomSheet({
    required int type,
    required Function(PrinterDevice) onConnect,
    required Stream<PrinterDevice> devicesStream,
  }) {
    final items = <PrinterDevice>[];
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
        initialChildSize: 0.5,
        minChildSize: 0.5,
        maxChildSize: 0.5,
        expand: false,
        builder: (_, controller) => StreamBuilder<PrinterDevice>(
          stream: devicesStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (!items.contains(snapshot.data)) {
                items.add(snapshot.data!);
              }
            }
            return Column(
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
                            type == ConnectionType.USB
                                ? ((snapshot.connectionState ==
                                            ConnectionState.done &&
                                        items.isEmpty)
                                    ? AppStrings.no_usb_devices.tr()
                                    : AppStrings.usb_devices.tr())
                                : ((snapshot.connectionState ==
                                            ConnectionState.done &&
                                        items.isEmpty)
                                    ? AppStrings.no_bluetooth_devices.tr()
                                    : AppStrings.bluetooth_devices.tr()),
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
                if (snapshot.hasData) ...[
                  Expanded(
                    child: ListView.builder(
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
                    ),
                  ),
                ] else if (snapshot.connectionState ==
                    ConnectionState.waiting) ...[
                  Expanded(
                    child: Center(
                      child: Text(
                        AppStrings.looking_for_devices.tr(),
                        style: getRegularTextStyle(
                          color: AppColors.black,
                          fontSize: AppFontSize.s18.rSp,
                        ),
                      ),
                    ),
                  ),
                ] else if (snapshot.connectionState ==
                    ConnectionState.done) ...[
                  Expanded(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          type == ConnectionType.BLUETOOTH
                              ? AppStrings.no_bluetooth_devices_message.tr()
                              : AppStrings.no_usb_devices_message.tr(),
                          textAlign: TextAlign.center,
                          style: getRegularTextStyle(
                            color: AppColors.black,
                            fontSize: AppFontSize.s16.rSp,
                          ),
                        ),
                      ),
                    ),
                  )
                ]
              ],
            );
          },
        ),
      ),
    ).then((value) => _isAlreadyShowing = false);
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
                textColor: AppColors.purpleBlue,
                onTap: () {
                  Navigator.pop(
                      RoutesGenerator.navigatorKey.currentState!.context);
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
