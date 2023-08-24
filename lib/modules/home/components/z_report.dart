import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';

import '../../../resources/colors.dart';
import '../../../resources/fonts.dart';
import '../../../resources/styles.dart';
import '../../../resources/values.dart';

class ZReportView extends StatelessWidget {
  const ZReportView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: AppSize.s12.rh,
        horizontal: AppSize.s16.rw,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Z-Report',
            style: boldTextStyle(
              color: AppColors.black,
              fontSize: AppFontSize.s16.rSp,
            ),
          ),
          SizedBox(height: AppSize.s8.rh),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.s12.rh,
              horizontal: AppSize.s16.rw,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
              color: AppColors.white,
            ),
            child: const ZReportSelector(),
          ),
        ],
      ),
    );
  }
}

class ZReportSelector extends StatefulWidget {
  const ZReportSelector({Key? key}) : super(key: key);

  @override
  State<ZReportSelector> createState() => _ZReportSelectorState();
}

class _ZReportSelectorState extends State<ZReportSelector> {
  int _selectedValue = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedValue = 1;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                color: _selectedValue == 1
                    ? AppColors.primary
                    : AppColors.greyLight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                child: Center(
                  child: Text(
                    'Today',
                    style: regularTextStyle(
                      color: _selectedValue == 1
                          ? AppColors.white
                          : AppColors.black,
                      fontSize: AppFontSize.s15.rSp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedValue = 2;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                color: _selectedValue == 2
                    ? AppColors.primary
                    : AppColors.greyLight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
                child: Center(
                  child: Text(
                    'Yesterday',
                    style: regularTextStyle(
                      color: _selectedValue == 2
                          ? AppColors.white
                          : AppColors.black,
                      fontSize: AppFontSize.s15.rSp,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: AppSize.s8.rw),
        Expanded(
          child: InkWell(
            onTap: () {
              setState(() {
                _selectedValue = 3;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                color: _selectedValue == 3
                    ? AppColors.primary
                    : AppColors.greyLight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: AppSize.s8.rh,
                  horizontal: AppSize.s8.rw,
                ),
                child: Center(
                  child: Row(
                    children: [
                      Icon(
                        Icons.date_range,
                        color: _selectedValue == 3
                            ? AppColors.white
                            : AppColors.black,
                      ),
                      SizedBox(width: AppSize.s4.rw),
                      Expanded(
                        child: Text(
                          'Custom',
                          style: regularTextStyle(
                            color: _selectedValue == 3
                                ? AppColors.white
                                : AppColors.black,
                            fontSize: AppFontSize.s15.rSp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
