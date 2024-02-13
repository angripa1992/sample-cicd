import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

import '../sticker_printer_handler.dart';
import 'device_item_view.dart';

class StickerPrinterDevices extends StatelessWidget {
  final Function(BluetoothDevice) onStickerPrinterConnected;

  const StickerPrinterDevices({Key? key, required this.onStickerPrinterConnected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ScanResult>>(
      future: StickerPrinterHandler().scanDevices(),
      builder: (context, snapshot) {
        if (snapshot.hasData && snapshot.data != null) {
          final devices = snapshot.data!;
          devices.removeWhere((element) => element.device.name.isEmpty);
          return devices.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      AppStrings.no_bluetooth_devices_message.tr(),
                      textAlign: TextAlign.center,
                      style: regularTextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                  ),
                )
              : StatefulBuilder(
                  builder: (ct, setState) {
                    return ListView.builder(
                      itemCount: devices.length,
                      itemBuilder: (context, index) {
                        final device = devices[index];
                        return PrinterDeviceItemView(
                          willDisconnect: devices[index].device.id.id == StickerPrinterHandler().connectedDevice()?.id.id,
                          icon: Icons.bluetooth,
                          name: device.device.name,
                          onConnect: () async {
                            final connected = await StickerPrinterHandler().connect(device.device, true);
                            if (connected) {
                              onStickerPrinterConnected(device.device);
                              setState(() {});
                            }
                          },
                          onDisconnect: () async {
                            await StickerPrinterHandler().disconnect(device.device);
                            setState(() {});
                          },
                        );
                      },
                    );
                  },
                );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text(
              AppStrings.looking_for_devices.tr(),
              style: regularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          );
        }
        return Center(
          child: Text(
            AppStrings.no_bluetooth_devices.tr(),
            style: regularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
        );
      },
    );
  }
}
