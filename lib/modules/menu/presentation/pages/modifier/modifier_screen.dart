import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/modules/menu/presentation/cubit/fetch_modifier_groups_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/modifier/modifier_groups_list_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../domain/entities/modifier/modifier_group.dart';

class ModifierScreen extends StatefulWidget {
  final int brand;
  final int branch;
  final List<int> providers;

  const ModifierScreen({
    Key? key,
    required this.brand,
    required this.providers,
    required this.branch,
  }) : super(key: key);

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

  void _fetchModifier() {
    context.read<FetchModifierGroupsCubit>().fetchModifierGroups(
          branchID: widget.branch,
          brandId: widget.brand,
          providers: widget.providers,
        );
  }

  @override
  Widget build(BuildContext context) {
    _fetchModifier();
    return Expanded(
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw, vertical: AppSize.s12.rh),
        child: BlocBuilder<FetchModifierGroupsCubit, ResponseState>(
          builder: (context, state) {
            if (state is Success<List<ModifierGroup>>) {
              if (state.data.isEmpty) {
                return Center(child: Text(AppStrings.no_modifiers_group_found.tr()));
              }
              return ModifierGroupsListView(
                modifierGroups: state.data,
                brandId: widget.brand,
                branchId: widget.branch,
              );
            } else if (state is Failed) {
              return Center(child: Text(state.failure.message));
            }
            return Center(child: CircularProgress(primaryColor: AppColors.primary));
          },
        ),
      ),
    );
  }
}
