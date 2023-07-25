import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:klikit/app/size_config.dart';

import '../../app/constants.dart';
import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';
import '../bluetooth_printer_handler.dart';
import '../usb_printer_handler.dart';
import 'device_item_view.dart';

class PosPrinterDevicesView extends StatelessWidget {
  final int type;
  final Function(PrinterDevice) onConnect;

  const PosPrinterDevicesView({
    Key? key,
    required this.type,
    required this.onConnect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              style: regularTextStyle(
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
                    style: regularTextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.s14.rSp,
                    ),
                  ),
                ),
              )
            : ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return DeviceItemView(
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
}
