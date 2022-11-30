import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/presentation/cubit/modifier_groups_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/modifier_groups_list_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../resources/values.dart';
import '../../../domain/entities/modifiers_group.dart';

class ModifierScreen extends StatelessWidget {
  final int brandId;

  const ModifierScreen({Key? key, required this.brandId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ModifierGroupsCubit>().fetchModifierGroups(brandId);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: AppSize.s8.rh),
            child: Text(
              'MODIFIER GROUPS',
              style: getRegularTextStyle(
                color: AppColors.black,
                fontSize: AppFontSize.s16.rSp,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(AppSize.s4.rSp)),
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.s8.rh,
                horizontal: AppSize.s12.rw,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Title',
                    style: getRegularTextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.s16.rSp,
                    ),
                  ),
                  Text(
                    'Action',
                    style: getRegularTextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.s16.rSp,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<ModifierGroupsCubit, ResponseState>(
              builder: (context, state) {
                if (state is Success<List<ModifiersGroup>>) {
                  if (state.data.isEmpty) {
                    return const Center(
                      child: Text('No modifier group found!'),
                    );
                  }
                  return ModifierGroupsListView(
                    modifierGroups: state.data,
                    brandId: brandId,
                  );
                } else if (state is Failed) {
                  return Center(
                    child: Text(state.failure.message),
                  );
                }
                return Center(
                  child: CircularProgressIndicator(
                    color: AppColors.purpleBlue,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}