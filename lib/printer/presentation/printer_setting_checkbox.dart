import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../resources/colors.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';

class PrinterSettingCheckbox extends StatelessWidget {
  final String name;
  final bool enabled;
  final Function(bool) onChanged;
  final bool willAlwaysChecked;
  final Color activeColor;

  const PrinterSettingCheckbox({
    Key? key,
    required this.name,
    required this.enabled,
    required this.onChanged,
    required this.willAlwaysChecked,
    required this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        name,
        style: regularTextStyle(
          color: AppColors.black,
          fontSize: AppSize.s16.rSp,
        ),
      ),
      value: willAlwaysChecked ? true : enabled,
      onChanged: (bool? value) => willAlwaysChecked ? null : onChanged(value!),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: activeColor,
    );
  }
}
