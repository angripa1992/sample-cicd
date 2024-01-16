import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/menu/presentation/cubit/brand_selection_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/tab_selection_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/filter_by_brands_view.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/modifier_screen.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/values.dart';

import '../../../../app/di.dart';
import '../../../common/entities/brand.dart';
import '../../../common/entities/provider.dart';
import '../cubit/aggregator_selection_cubit.dart';
import 'filter_by_aggregator_view.dart';
import 'menu/menu_screen.dart';
import 'menu_tabbar_view.dart';

class MenuMgtBody extends StatelessWidget {
  final List<Brand> brands;
  final _informationProvider = getIt.get<BusinessInformationProvider>();

  MenuMgtBody({Key? key, required this.brands}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: AppColors.white,
          padding: EdgeInsets.only(left: AppSize.s16.rw, right: AppSize.s16.rw, top: AppSize.s12.rh, bottom: AppSize.s16.rh),
          child: FilterByBrandsView(
            brands: brands,
            onChanged: (brand) {
              context.read<BrandSelectionCubit>().changeBrand(brand);
              context.read<AggregatorSelectionCubit>().changeAggregator(null);
            },
          ),
        ),
        AppSize.s8.verticalSpacer(),
        const MenuTabBarView(),
        BlocBuilder<BrandSelectionCubit, Brand?>(
          builder: (context, brandState) {
            if (brandState == null) {
              return const SizedBox();
            }
            return FutureBuilder<List<Provider>>(
              future: _informationProvider.fetchProviders(),
              builder: (_, snapshot) {
                if (snapshot.hasData) {
                  return FilterByAggregatorView(
                    providers: snapshot.data!,
                    onChanged: (provider) {
                      context.read<AggregatorSelectionCubit>().changeAggregator(provider?.id);
                    },
                  );
                }
                return const SizedBox();
              },
            );
          },
        ),
        BlocBuilder<BrandSelectionCubit, Brand?>(
          builder: (context, brandState) {
            return BlocBuilder<AggregatorSelectionCubit, int?>(
              builder: (context, aggregatorState) {
                return BlocBuilder<TabSelectionCubit, int>(
                  builder: (context, tabState) {
                    if (tabState == MenuTabIndex.MODIFIER) {
                      return ModifierScreen(
                        brand: brandState,
                        providerId: aggregatorState,
                      );
                    } else {
                      return MenuScreen(
                        brand: brandState,
                        providerId: aggregatorState,
                      );
                    }
                  },
                );
              },
            );
          },
        ),
      ],
    );
  }
}
