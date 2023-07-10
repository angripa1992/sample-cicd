import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';
import '../data/dockets_fonts.dart';

const List<int> fonts = <int>[
  PrinterFontSize.small,
  PrinterFontSize.normal,
  PrinterFontSize.large,
  PrinterFontSize.huge
];

class SetFontSizeDropDown extends StatefulWidget {
  final int initFont;
  final Function(int) onChanged;

  const SetFontSizeDropDown(
      {Key? key, required this.initFont, required this.onChanged})
      : super(key: key);

  @override
  State<SetFontSizeDropDown> createState() => _SetFontSizeDropDownState();
}

class _SetFontSizeDropDownState extends State<SetFontSizeDropDown> {
  int? _currentFont;

  @override
  void initState() {
    _currentFont = widget.initFont;
    super.initState();
  }

  String _label(int fontId) {
    switch (fontId) {
      case PrinterFontSize.small:
        return AppStrings.small.tr();
      case PrinterFontSize.normal:
        return AppStrings.normal.tr();
      case PrinterFontSize.large:
        return AppStrings.large.tr();
      default:
        return AppStrings.huge.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: AppSize.s12.rw,
          vertical: AppSize.s8.rh,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              AppStrings.set_font_size.tr(),
              style: mediumTextStyle(
                color: AppColors.bluewood,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
            SizedBox(height: AppSize.s8.rh),
            Container(
              padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.frenchGrey,
                  width: AppSize.s1.rSp,
                ),
                borderRadius: BorderRadius.circular(AppSize.s8.rSp),
              ),
              child: DropdownButton<int>(
                value: _currentFont,
                isExpanded: true,
                underline: const SizedBox(),
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.darkGrey,
                ),
                elevation: 16,
                style: TextStyle(color: AppColors.darkGrey),
                onChanged: (int? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    _currentFont = value!;
                    widget.onChanged(_currentFont!);
                  });
                },
                items: fonts.map<DropdownMenuItem<int>>((value) {
                  return DropdownMenuItem<int>(
                    value: value,
                    child: Text(
                      _label(value),
                      style: mediumTextStyle(
                        color: AppColors.bluewood,
                        fontSize: AppFontSize.s14.rSp,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
