import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/presentation/cubit/brand_selection_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/tab_selection_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/filter_by_brands_view.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/modifier_screen.dart';
import 'package:klikit/resources/values.dart';

import '../../domain/entities/brand.dart';
import 'menu/menu_screen.dart';
import 'menu_tabbar_view.dart';

class MenuMgtBody extends StatelessWidget {
  final List<MenuBrand> brands;

  const MenuMgtBody({Key? key, required this.brands}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppSize.s20.rw,
        right: AppSize.s20.rw,
        top: AppSize.s20.rh,
      ),
      child: Column(
        children: [
          FilterByBrandsView(
            brands: brands,
            onChanged: (brand) {
              context.read<BrandSelectionCubit>().changeBrand(brand);
            },
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s20.rh),
            child: const MenuTabBarView(),
          ),
          BlocBuilder<BrandSelectionCubit, MenuBrand?>(
            builder: (context, brandState) {
              return BlocBuilder<TabSelectionCubit, int>(
                builder: (context, state) {
                  if(state == MenuTabIndex.MODIFIER){
                    return ModifierScreen(brand: brandState);
                  }else{
                    return MenuScreen(brand: brandState);
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
