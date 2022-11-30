import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/cubit/tab_selection_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu_tab.dart';

import '../../../../resources/values.dart';

class MenuTabBarView extends StatefulWidget {
  const MenuTabBarView({Key? key}) : super(key: key);

  @override
  State<MenuTabBarView> createState() => _MenuTabBarViewState();
}

class _MenuTabBarViewState extends State<MenuTabBarView> {
  int selectedTab = MenuTabIndex.MENU;

  void changeIndex(int index) =>
    context.read<TabSelectionCubit>().changeTab(index);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MenuTab(
          name: 'MENU',
          isSelected: selectedTab == MenuTabIndex.MENU,
          onTabChanged: () {
            setState(() {
              selectedTab = MenuTabIndex.MENU;
              changeIndex(selectedTab);
            });
          },
        ),
        SizedBox(width: AppSize.s20.rw),
        MenuTab(
          name: 'MODIFIERS',
          isSelected: selectedTab == MenuTabIndex.MODIFIER,
          onTabChanged: () {
            setState(() {
              selectedTab = MenuTabIndex.MODIFIER;
              changeIndex(selectedTab);
            });
          },
        ),
      ],
    );
  }
}