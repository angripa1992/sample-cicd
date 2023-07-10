import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/presentation/cubit/modifier_groups_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/modifier_groups_list_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

import '../../../../../resources/values.dart';
import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../domain/entities/brand.dart';
import '../../../domain/entities/modifiers_group.dart';

class ModifierScreen extends StatefulWidget {
  final MenuBrand? brand;
  final int? providerId;

  const ModifierScreen({Key? key, required this.brand, this.providerId})
      : super(key: key);

  @override
  State<ModifierScreen> createState() => _ModifierScreenState();
}

class _ModifierScreenState extends State<ModifierScreen> {
  @override
  void initState() {
    SegmentManager().screen(
      event: SegmentEvents.MODIFIER_SCREEN,
      name: 'Modifier Screen',
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.brand != null) {
      context
          .read<ModifierGroupsCubit>()
          .fetchModifierGroups(widget.brand!.id, widget.providerId);
    }
    return Expanded(
      child: widget.brand == null
          ? Center(
              child: Text(
                AppStrings.please_select_a_brand.tr(),
                style: regularTextStyle(
                  color: AppColors.black,
                  fontSize: AppFontSize.s16.rSp,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: AppSize.s4.rh,
                    horizontal: AppSize.s4.rw,
                  ),
                  child: Text(
                    AppStrings.modifiers_group.tr().toUpperCase(),
                    style: regularTextStyle(
                      color: AppColors.black,
                      fontSize: AppFontSize.s16.rSp,
                    ),
                  ),
                ),
                Expanded(
                  child: BlocBuilder<ModifierGroupsCubit, ResponseState>(
                    builder: (context, state) {
                      if (state is Success<List<ModifiersGroup>>) {
                        if (state.data.isEmpty) {
                          return Center(
                            child: Text(
                              AppStrings.no_modifiers_group_found.tr(),
                            ),
                          );
                        }
                        return ModifierGroupsListView(
                          modifierGroups: state.data,
                          brandId: widget.brand!.id,
                          providerId: widget.providerId.orZero(),
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
