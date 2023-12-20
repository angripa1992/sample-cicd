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
        primaryColor: enabled ? primaryColor : primaryColor.withOpacity(0.5),
        unselectedWidgetColor: enabled ? (secondaryColor ?? AppColors.primaryLight) : (secondaryColor?.withOpacity(0.5) ?? AppColors.primaryLight.withOpacity(0.5)),
        checkboxTheme: CheckboxThemeData(
          side: MaterialStateBorderSide.resolveWith(
            (states) => BorderSide(
              width: AppSize.s2.rSp,
              color: states.contains(MaterialState.selected)
                  ? enabled
                      ? primaryColor
                      : primaryColor.withOpacity(0.5)
                  : AppColors.spanishGrey,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.rSp),
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
        value: checked,
        onChanged: (bool? value) {
          if (value != null) {
            onChanged(value);
          }
        },
        controlAffinity: ListTileControlAffinity.leading,
        checkColor: enabled ? primaryColor : primaryColor.withOpacity(0.5),
      ),
    );
  }
}
