import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/printer/presentation/printer_setting_radio_item.dart';

import '../../app/constants.dart';
import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';

class SetPrinterConnectionType extends StatefulWidget {
  final int initType;
  final int device;
  final bool isDocket;
  final Function(int) onChanged;

  const SetPrinterConnectionType({
    Key? key,
    required this.onChanged,
    required this.initType,
    required this.device,
    required this.isDocket,
  }) : super(key: key);

  @override
  State<SetPrinterConnectionType> createState() => _SetPrinterConnectionTypeState();
}

class _SetPrinterConnectionTypeState extends State<SetPrinterConnectionType> {
  int? _connectionType;

  @override
  void initState() {
    _connectionType = widget.initType;
    super.initState();
  }

  void _changePrinterConnectionType(int connectionType) {
    setState(() {
      _connectionType = connectionType;
      widget.onChanged(_connectionType!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s16.rw,
        vertical: AppSize.s12.rh,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            AppStrings.set_printer_connection_type.tr(),
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          PrinterSettingRadioItem(
            value: CType.BLE,
            groupValue: _connectionType!,
            onChanged: _changePrinterConnectionType,
            name: AppStrings.bluetooth.tr(),
          ),
          if (!widget.isDocket)
            PrinterSettingRadioItem(
              value: CType.DISABLED,
              groupValue: _connectionType!,
              onChanged: _changePrinterConnectionType,
              name: AppStrings.disable.tr(),
            ),
          if (widget.isDocket && widget.device != Device.imin)
            PrinterSettingRadioItem(
              value: CType.USB,
              groupValue: _connectionType!,
              onChanged: _changePrinterConnectionType,
              name: AppStrings.usb.tr(),
            ),
          if (widget.isDocket && widget.device != Device.imin)
            PrinterSettingRadioItem(
              value: CType.WIFI,
              groupValue: _connectionType!,
              onChanged: _changePrinterConnectionType,
              name: 'Wifi',
            ),
        ],
      ),
    );
  }
}
