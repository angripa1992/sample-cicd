import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/core/widgets/filter/filter_icon_view.dart';
import 'package:klikit/core/widgets/filter/menu_filter_screen.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_screen.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/resource_resolver.dart';
import 'package:klikit/resources/styles.dart';

import 'menu_tabbar_view.dart';
import 'modifier/modifier_screen.dart';

class MenuManagementBody extends StatefulWidget {
  const MenuManagementBody({Key? key}) : super(key: key);

  @override
  State<MenuManagementBody> createState() => _MenuManagementBodyState();
}

class _MenuManagementBodyState extends State<MenuManagementBody> {
  final _tabChangeListener = ValueNotifier(MenuTabIndex.MENU);
  final _filterDataChangeListener = ValueNotifier<MenuFilteredData?>(null);

  @override
  void dispose() {
    _tabChangeListener.dispose();
    _filterDataChangeListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MenuTabBarView(
          onChanged: (index) {
            _tabChangeListener.value = index;
          },
        ),
        Container(
          color: AppColors.white,
          padding: EdgeInsets.symmetric(vertical: 8.rh, horizontal: 16.rw),
          child: Row(
            children: [
              Expanded(
                child: ValueListenableBuilder<int>(
                  valueListenable: _tabChangeListener,
                  builder: (_, index, __) {
                    return Text(
                      index == MenuTabIndex.MODIFIER ? 'Modifier List' : 'Menu List',
                      style: semiBoldTextStyle(
                        color: AppColors.black,
                        fontSize: 16.rSp,
                      ),
                    );
                  },
                ),
              ),
              ValueListenableBuilder<MenuFilteredData?>(
                valueListenable: _filterDataChangeListener,
                builder: (_, data, __) {
                  return FilterIconView(
                    applied: data != null,
                    openFilterScreen: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MenuFilterScreen(
                            initData: data,
                            onApplyFilterCallback: (filteredData) {
                              _filterDataChangeListener.value = filteredData;
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
        Divider(thickness: 0.5, height: 0, color: AppColors.neutralB40),
        ValueListenableBuilder<int>(
          valueListenable: _tabChangeListener,
          builder: (_, index, __) {
            return ValueListenableBuilder<MenuFilteredData?>(
              valueListenable: _filterDataChangeListener,
              builder: (_, data, __) {
                return _body(index, data);
              },
            );
          },
        ),
      ],
    );
  }

  Widget _body(int index, MenuFilteredData? data) {
    final branchID = UserPermissionManager().isBizOwner() ? data?.branch?.id : SessionManager().branchId();
    final brandID = data?.brand?.id;
    final selected = (data != null && brandID != null && branchID != null);
    final providers = data?.providers?.map((e) => e.id).toList() ?? [];
    if (selected && index == MenuTabIndex.MENU) {
      return MenuScreen(branch: branchID, brand: brandID, providers: providers);
    } else if (selected && index == MenuTabIndex.MODIFIER) {
      return ModifierScreen(branch: branchID, brand: brandID, providers: providers);
    } else {
      return _emptyView();
    }
  }

  Widget _emptyView() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ImageResourceResolver.emptyMenuPNG.getImageWidget(width: 131.rSp, height: 131.rSp),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.rw),
            child: Text(
              'Select a brand and branch to seamlessly manage menus and modifiers',
              textAlign: TextAlign.center,
              style: mediumTextStyle(
                color: AppColors.neutralB600,
                fontSize: 14.rSp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
