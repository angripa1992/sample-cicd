import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/tab_item.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';
import 'package:klikit/resources/values.dart';

import '../../../../resources/colors.dart';

class MenuTab extends StatelessWidget {
  final TabItem tabItem;
  final bool isSelected;
  final Function(TabItem) onTabChanged;
  final BorderRadius borderRadius;

  const MenuTab({
    Key? key,
    required this.tabItem,
    required this.isSelected,
    required this.onTabChanged,
    required this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          onTabChanged(tabItem);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: isSelected ? BoxDecoration(borderRadius: borderRadius, color: AppColors.white) : null,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s10.rh),
            child: Center(
              child: Text(
                tabItem.tabName,
                style: mediumTextStyle(
                  color: isSelected ? AppColors.neutralB700 : AppColors.neutralB300,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
