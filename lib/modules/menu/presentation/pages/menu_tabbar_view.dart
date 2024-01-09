import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/pages/menu_tab.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';

class MenuTabBarView extends StatefulWidget {
  final Function(int) onChanged;

  const MenuTabBarView({Key? key, required this.onChanged}) : super(key: key);

  @override
  State<MenuTabBarView> createState() => _MenuTabBarViewState();
}

class _MenuTabBarViewState extends State<MenuTabBarView> {
  int selectedTab = MenuTabIndex.MENU;

  void changeIndex(int index) => widget.onChanged(index);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.rh, horizontal: 8.rw),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.rSp),
        color: AppColors.neutralB20,
      ),
      child: Row(
        children: [
          MenuTab(
            name: AppStrings.menu.tr().toUpperCase(),
            isSelected: selectedTab == MenuTabIndex.MENU,
            onTabChanged: () {
              setState(() {
                selectedTab = MenuTabIndex.MENU;
                changeIndex(selectedTab);
              });
            },
          ),
          MenuTab(
            name: AppStrings.modifiers.tr().toUpperCase(),
            isSelected: selectedTab == MenuTabIndex.MODIFIER,
            onTabChanged: () {
              setState(() {
                selectedTab = MenuTabIndex.MODIFIER;
                changeIndex(selectedTab);
              });
            },
          ),
        ],
      ),
    );
  }
}
