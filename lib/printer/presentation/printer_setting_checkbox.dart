import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../resources/colors.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';

class PrinterSettingCheckbox extends StatelessWidget {
  final String name;
  final bool enabled;
  final Function(bool) onChanged;

  const PrinterSettingCheckbox(
      {Key? key,
      required this.name,
      required this.enabled,
      required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      title: Text(
        name,
        style: getRegularTextStyle(
          color: AppColors.blueViolet,
          fontSize: AppSize.s16.rSp,
        ),
      ),
      value: enabled,
      onChanged: (bool? value) => onChanged(value!),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: AppColors.purpleBlue,
    );
  }
}
