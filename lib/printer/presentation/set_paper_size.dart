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

class SetPaperSize extends StatefulWidget {
  final int initSize;
  final Function(int) onChanged;

  const SetPaperSize({Key? key, required this.initSize, required this.onChanged}) : super(key: key);

  @override
  State<SetPaperSize> createState() => _SetPaperSizeState();
}

class _SetPaperSizeState extends State<SetPaperSize> {
  int? _paperSize;

  @override
  void initState() {
    _paperSize = widget.initSize;
    super.initState();
  }

  void _changePrinterPaperSize(int paperSize) {
    setState(() {
      _paperSize = paperSize;
      widget.onChanged(_paperSize!);
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
            AppStrings.set_paper_size.tr(),
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          PrinterSettingRadioItem(
            value: RollId.mm58,
            groupValue: _paperSize!,
            onChanged: _changePrinterPaperSize,
            name: '58mm',
          ),
          PrinterSettingRadioItem(
            value: RollId.mm80,
            groupValue: _paperSize!,
            onChanged: _changePrinterPaperSize,
            name: '80mm',
          ),
        ],
      ),
    );
  }
}
