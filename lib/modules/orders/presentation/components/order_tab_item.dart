import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/kt_chip.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../resources/colors.dart';
import '../../../../resources/values.dart';

class OrderTabItem extends StatelessWidget {
  final String title;
  final int count;
  final ValueNotifier<int> tabIndexChangeListener;
  final int tabIndex;

  const OrderTabItem({
    Key? key,
    required this.title,
    required this.count,
    required this.tabIndexChangeListener,
    required this.tabIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<int>(
      valueListenable: tabIndexChangeListener,
      builder: (_, currentTabIndex, __) {
        bool isSelected = currentTabIndex == tabIndex;

        return KTChip(
          text: title,
          textHelperTrailingWidget:
              count > 0 ? Text(count.toString(), textAlign: TextAlign.center, style: regularTextStyle(fontSize: AppSize.s10.rSp, color: isSelected ? AppColors.white : AppColors.neutralB500)) : null,
          textStyle: isSelected ? semiBoldTextStyle(fontSize: AppSize.s14.rSp, color: AppColors.white) : regularTextStyle(fontSize: AppSize.s14.rSp, color: AppColors.neutralB500),
          strokeColor: isSelected ? AppColors.primaryP300 : AppColors.neutralB20,
          backgroundColor: isSelected ? AppColors.primaryP300 : AppColors.neutralB20,
          padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw, vertical: AppSize.s6.rh),
        );
      },
    );
  }
}
