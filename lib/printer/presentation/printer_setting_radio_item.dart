import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../resources/colors.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';

class PrinterSettingRadioItem extends StatelessWidget {
  final String name;
  final int value;
  final int groupValue;
  final Function(int) onChanged;

  const PrinterSettingRadioItem({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      contentPadding: EdgeInsets.zero,
      activeColor: AppColors.purpleBlue,
      title: Text(
        name,
        style: getRegularTextStyle(
          color: AppColors.blueViolet,
          fontSize: AppSize.s16.rSp,
        ),
      ),
      // leading: Container(
      //   padding: EdgeInsets.zero,
      //   child: Radio(
      //     fillColor: MaterialStateColor.resolveWith(
      //         (states) => AppColors.purpleBlue),
      //     value: value,
      //     groupValue: groupValue,
      //     onChanged: (int? type) => onChanged(type!),
      //     visualDensity: const VisualDensity(
      //       horizontal: -4,
      //       vertical: -4,
      //     ),
      //   ),
      // ),
      dense: true,
      value: value,
      groupValue: groupValue,
      onChanged: (int? type) => onChanged(type!),
    );
  }
}
