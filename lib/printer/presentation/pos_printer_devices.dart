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
    return FutureBuilder<List<PrinterDevice>>(
      future: type == CType.BLE
          ? BluetoothPrinterHandler().getDevices()
          : UsbPrinterHandler().getDevices(),
      builder: (context, snapshot) {
        final devices = <PrinterDevice>[];
        if (snapshot.hasData) {
          devices.addAll(snapshot.data ?? []);
        }
        return devices.isEmpty
            ? Center(
                child: Text(
                  AppStrings.looking_for_devices.tr(),
                  style: regularTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: devices.length,
                itemBuilder: (context, index) {
                  return DeviceItemView(
                    icon: type == CType.BLE
                        ? Icons.bluetooth
                        : Icons.usb,
                    name: devices[index].name,
                    onConnect: () {
                      onConnect(devices[index]);
                    },
                  );
                },
              );
      },
    );
  }
}
