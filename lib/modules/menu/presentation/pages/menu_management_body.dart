import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/core/widgets/filter/filter_icon_view.dart';
import 'package:klikit/core/widgets/filter/menu_filter_screen.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/modules/menu/presentation/cubit/menu_brands_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_screen.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../resources/values.dart';
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
  void initState() {
    context.read<MenuBrandsCubit>().fetchMenuBrands();
    super.initState();
  }

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
        Padding(
          padding: EdgeInsets.only(
            top: 12.rh,
            bottom: 8.rh,
            left: 12.rw,
            right: 12.rw,
          ),
          child: MenuTabBarView(
            onChanged: (index) {
              _tabChangeListener.value = index;
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.rh, horizontal: 12.rw),
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
        Divider(color: AppColors.neutralB40),
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
    final selected = (data != null && data.brand != null && data.branch != null);
    final providers = data?.providers?.map((e) => e.id).toList() ?? [];
    if (selected && index == MenuTabIndex.MENU) {
      return MenuScreen(
        branch: data.branch!.id,
        brand: data.brand!.id,
        providers: providers,
      );
    } else if (selected && index == MenuTabIndex.MODIFIER) {
      return ModifierScreen(brand: null, providerId: null);
    } else {
      return Text('Select brand and branch');
    }
  }
}
