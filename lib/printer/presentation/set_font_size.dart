import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../resources/colors.dart';
import '../../resources/fonts.dart';
import '../../resources/strings.dart';
import '../../resources/styles.dart';
import '../../resources/values.dart';
import '../data/dockets_fonts.dart';
import 'printer_setting_radio_item.dart';

const List<int> fonts = <int>[
  PrinterFontSize.small,
  PrinterFontSize.normal,
  PrinterFontSize.large,
  PrinterFontSize.huge,
];

class SetFontSize extends StatefulWidget {
  final int initFont;
  final Function(int) onChanged;

  const SetFontSize({
    Key? key,
    required this.initFont,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<SetFontSize> createState() => _SetFontSizeState();
}

class _SetFontSizeState extends State<SetFontSize> {
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
            AppStrings.set_font_size.tr(),
            style: mediumTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          SizedBox(height: AppSize.s8.rh),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: fonts.map(
              (selected) {
                return PrinterSettingRadioItem(
                  value: selected,
                  groupValue: _currentFont!,
                  onChanged: (value) {
                    setState(() {
                      _currentFont = value;
                      widget.onChanged(_currentFont!);
                    });
                  },
                  name: _label(selected),
                );
              },
            ).toList(),
          ),
        ],
      ),
    );
  }
}
