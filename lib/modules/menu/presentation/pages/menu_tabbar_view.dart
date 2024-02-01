import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/menu_tab.dart';
import 'package:klikit/modules/menu/presentation/pages/tab_item.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

class MenuTabBarView extends StatelessWidget {
  final int selectedIndex;
  final List<TabItem> tabItems;
  final Function(int) onChanged;

  const MenuTabBarView({
    Key? key,
    required this.onChanged,
    required this.selectedIndex,
    required this.tabItems,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rh, vertical: AppSize.s12.rh),
      child: Container(
        padding: EdgeInsets.all(AppSize.s4.rSp),
        decoration: BoxDecoration(
          color: AppColors.greyLight,
          borderRadius: BorderRadius.circular(AppSize.s12.rSp),
        ),
        child: Row(
          children: tabItems
              .map(
                (e) => MenuTab(
                  tabItem: e,
                  isSelected: e.tabIndex == selectedIndex,
                  onTabChanged: (tabItem) {
                    onChanged(tabItem.tabIndex);
                  },
                  borderRadius: BorderRadius.circular(AppSize.s8.rSp),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
