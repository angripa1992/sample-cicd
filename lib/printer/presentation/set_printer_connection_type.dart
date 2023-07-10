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
  final bool willUsbEnabled;
  final Function(int) onChanged;

  const SetPrinterConnectionType(
      {Key? key, required this.onChanged, required this.initType, required this.willUsbEnabled})
      : super(key: key);

  @override
  State<SetPrinterConnectionType> createState() =>
      _SetPrinterConnectionTypeState();
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
    return Card(
      child: Padding(
        padding: EdgeInsets.only(
          right: AppSize.s12.rw,
          left: AppSize.s12.rw,
          top: AppSize.s8.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.set_printer_connection_type.tr(),
              style: mediumTextStyle(
                color: AppColors.bluewood,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
            PrinterSettingRadioItem(
              value: ConnectionType.BLUETOOTH,
              groupValue: _connectionType!,
              onChanged: _changePrinterConnectionType,
              name: AppStrings.bluetooth.tr(),
            ),
            PrinterSettingRadioItem(
              value: ConnectionType.USB,
              groupValue: _connectionType!,
              onChanged: _changePrinterConnectionType,
              name: widget.willUsbEnabled ? AppStrings.usb.tr() : AppStrings.disable.tr(),
            ),
          ],
        ),
      ),
    );
  }
}
