import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/fonts.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';

class SelectAllView extends StatefulWidget {
  final Function(bool) onSelectChange;
  final bool isAllSelected;

  const SelectAllView(
      {Key? key, required this.onSelectChange, required this.isAllSelected})
      : super(key: key);

  @override
  State<SelectAllView> createState() => _SelectAllViewState();
}

class _SelectAllViewState extends State<SelectAllView> {
  bool? _isSelected;

  @override
  void initState() {
    _isSelected = widget.isAllSelected;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s8.rw,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: AppSize.s8.rw),
                child: Text(
                  AppStrings.select_all.tr(),
                  style: getRegularTextStyle(
                    color: AppColors.black,
                    fontSize: AppFontSize.s14.rSp,
                  ),
                ),
              ),
              Checkbox(
                checkColor: AppColors.white,
                fillColor: MaterialStateProperty.resolveWith(getCheckboxColor),
                value: _isSelected,
                onChanged: (bool? value) {
                  setState(() {
                    _isSelected = value;
                    widget.onSelectChange(_isSelected!);
                  });
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
