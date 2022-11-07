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
      padding: EdgeInsets.symmetric(
        horizontal: AppSize.s20.rw,
        vertical: AppSize.s20.rh,
      ),
      child: Column(
        children: [
          FilterByBrandsView(
            brands: brands,
            onChanged: (brand) {
              context.read<BrandSelectionCubit>().changeBrand(brand);
            },
          ),
          BlocBuilder<BrandSelectionCubit, MenuBrand?>(
            builder: (context, state) {
              if (state != null) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSize.s20.rh),
                  child: const MenuTabBarView(),
                );
              }
              return const SizedBox();
            },
          ),
          BlocBuilder<BrandSelectionCubit, MenuBrand?>(
            builder: (context, brandState) {
              if (brandState != null) {
                return BlocBuilder<TabSelectionCubit, int>(
                  builder: (context, state) {
                    if(state == MenuTabIndex.MODIFIER){
                      return const ModifierScreen();
                    }else{
                      return MenuScreen(brandID: brandState.id);
                    }
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
