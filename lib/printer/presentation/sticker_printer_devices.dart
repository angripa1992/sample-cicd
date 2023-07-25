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
  final Function(BluetoothDevice) onConnect;

  const StickerPrinterDevices({Key? key, required this.onConnect})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      style: regularTextStyle(
                        color: AppColors.black,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                  ),
                )
              : ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return DeviceItemView(
                      icon: Icons.bluetooth,
                      name: data[index].device.name,
                      onConnect: () {
                        onConnect(data[index].device);
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
