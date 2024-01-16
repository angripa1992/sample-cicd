import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/cubit/tab_selection_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu_tab.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';

import '../../../../resources/values.dart';

class MenuTabBarView extends StatefulWidget {
  const MenuTabBarView({Key? key}) : super(key: key);

  @override
  State<MenuTabBarView> createState() => _MenuTabBarViewState();
}

class _MenuTabBarViewState extends State<MenuTabBarView> {
  int selectedTab = MenuTabIndex.MENU;

  void changeIndex(int index) => context.read<TabSelectionCubit>().changeTab(index);

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
          children: [
            MenuTab(
              name: AppStrings.menu.tr(),
              isSelected: selectedTab == MenuTabIndex.MENU,
              onTabChanged: () {
                setState(() {
                  selectedTab = MenuTabIndex.MENU;
                  changeIndex(selectedTab);
                });
              },
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            ),
            MenuTab(
              name: AppStrings.modifiers.tr(),
              isSelected: selectedTab == MenuTabIndex.MODIFIER,
              onTabChanged: () {
                setState(() {
                  selectedTab = MenuTabIndex.MODIFIER;
                  changeIndex(selectedTab);
                });
              },
              borderRadius: BorderRadius.circular(AppSize.s8.rSp),
            ),
          ],
        ),
      ),
    );
  }
}
