import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../app/constants.dart';
import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';

class DiscountTypeSelector extends StatefulWidget {
  final int initValue;
  final Function(int) onChange;

  const DiscountTypeSelector({
    Key? key,
    required this.initValue,
    required this.onChange,
  }) : super(key: key);

  @override
  State<DiscountTypeSelector> createState() => _DiscountTypeSelector();
}

class _DiscountTypeSelector extends State<DiscountTypeSelector> {
  late int _type;

  @override
  void initState() {
    _type = widget.initValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RadioListTile<int>(
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.primary,
          title: Text(
            AppStrings.flat.tr(),
            style: regularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
          value: DiscountType.flat,
          groupValue: _type,
          onChanged: (value) {
            setState(() {
              _type = value!;
              widget.onChange(_type);
            });
          },
        ),
        RadioListTile<int>(
          contentPadding: EdgeInsets.zero,
          activeColor: AppColors.primary,
          title: Text(
            AppStrings.percentage.tr(),
            style: regularTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s14.rSp,
            ),
          ),
          value: DiscountType.percentage,
          groupValue: _type,
          onChanged: (value) {
            setState(() {
              _type = value!;
              widget.onChange(_type);
            });
          },
        ),
      ],
    );
  }
}
