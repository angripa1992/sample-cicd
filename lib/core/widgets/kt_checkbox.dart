import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../resources/colors.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';

class KTCheckbox extends StatelessWidget {
  final String name;
  final bool enabled;
  final bool checked;
  final Color primaryColor;
  final Color? secondaryColor;
  final Function(bool) onChanged;

  const KTCheckbox({
    Key? key,
    required this.name,
    this.enabled = true,
    this.checked = false,
    required this.primaryColor,
    this.secondaryColor,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        primaryColor: primaryColor,
        unselectedWidgetColor: AppColors.primaryLighter,
        checkboxTheme: CheckboxThemeData(
          side: MaterialStateBorderSide.resolveWith(
            (states) => BorderSide(
              width: AppSize.s2.rSp,
              color: states.contains(MaterialState.selected) ? AppColors.primary : AppColors.spanishGrey,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          fillColor: MaterialStateProperty.all(Colors.white),
        ),
      ),
      child: CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        enabled: enabled,
        title: Text(
          name,
          style: regularTextStyle(
            color: enabled ? AppColors.black : AppColors.spanishGrey,
            fontSize: AppSize.s16.rSp,
          ),
        ),
        value: checked ? true : enabled,
        onChanged: (bool? value) => checked ? null : onChanged(value!),
        controlAffinity: ListTileControlAffinity.leading,
        checkColor: AppColors.primary,
      ),
    );
  }
}
