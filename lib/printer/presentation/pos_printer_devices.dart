import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/printer/data/printer_setting.dart';
import 'package:klikit/printer/presentation/device_item_view.dart';
import 'package:klikit/printer/printer_handler.dart';
import 'package:klikit/printer/printer_local_data_manager.dart';

import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';

class PosPrinterDevicesView extends StatelessWidget {
  final PrinterHandler handler;

  const PosPrinterDevicesView({
    Key? key,
    required this.handler,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PrinterDevice>>(
      future: handler.getDevices<PrinterDevice>(),
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
            : StatefulBuilder(
                builder: (ct, setState) {
                  final localPrinter = LocalPrinterDataManager().localPrinter();
                  return ListView.builder(
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      final device = devices[index];
                      return PrinterDeviceItemView(
                        icon: handler.icon(),
                        name: device.name,
                        willDisconnect: _willDisconnect(localPrinter, device),
                        onConnect: () async {
                          await handler.connect(
                            localPrinter: _createLocalPrinter(device),
                            isFromBackground: false,
                            showMessage: true,
                          );
                          setState(() {});
                        },
                        onDisconnect: () async {
                          await handler.disconnect(_createLocalPrinter(device), false);
                          setState(() {});
                        },
                      );
                    },
                  );
                },
              );
      },
    );
  }

  bool _willDisconnect(LocalPrinter? localPrinter, PrinterDevice device) {
    if (localPrinter == null) {
      return false;
    } else if (localPrinter.deviceType == CType.BLE && localPrinter.deviceAddress == device.address) {
      return true;
    } else if (localPrinter.deviceType == CType.USB && localPrinter.vendorId == device.vendorId && localPrinter.productId == device.productId) {
      return true;
    } else {
      return false;
    }
  }

  LocalPrinter _createLocalPrinter(PrinterDevice device) => LocalPrinter(
        deviceType: handler.type(),
        deviceAddress: device.address ?? '',
        deviceName: device.name,
        productId: device.productId ?? '',
        vendorId: device.vendorId ?? '',
      );
}
