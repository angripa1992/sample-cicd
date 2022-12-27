import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/entities/menues.dart';
import 'package:klikit/modules/menu/presentation/cubit/menus_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_list_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

import '../../../domain/entities/brand.dart';

class MenuScreen extends StatelessWidget {
  final MenuBrand? brand;
  final int? providerId;

  const MenuScreen({Key? key, required this.brand, this.providerId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (brand != null) {
      context.read<MenusCubit>().fetchMenu(brand!.id, providerId);
    }
    return Expanded(
      child: brand == null
          ? Center(
              child: Text(
                AppStrings.please_select_a_brand.tr(),
                style: getRegularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
            )
          : BlocBuilder<MenusCubit, ResponseState>(
              builder: (context, state) {
                if (state is Success<MenusData>) {
                  if (state.data.sections.isEmpty) {
                    return Center(
                      child: Text(AppStrings.no_menus_found.tr()),
                    );
                  }
                  return MenuListView(
                    sections: state.data.sections,
                    brandID: brand!.id,
                  );
                } else if (state is Failed) {
                  return Center(child: Text(state.failure.message));
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
    );
  }
}
