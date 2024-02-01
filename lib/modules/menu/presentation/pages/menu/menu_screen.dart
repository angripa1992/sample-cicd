import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/modules/menu/presentation/cubit/menus_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_list_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

import '../../../../../segments/event_manager.dart';
import '../../../../../segments/segemnt_data_provider.dart';
import '../../../domain/entities/menu/menu_data.dart';

class MenuScreen extends StatefulWidget {
  final int brand;
  final int branch;
  final List<int> providers;

  const MenuScreen({
    Key? key,
    required this.brand,
    required this.branch,
    required this.providers,
  }) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  @override
  void initState() {
    SegmentManager().screen(event: SegmentEvents.MENU_SCREEN, name: 'Menu Screen');
    super.initState();
  }

  void _fetchMenu() {
    context.read<MenusCubit>().fetchMenu(branchID: widget.branch, brandId: widget.brand, providers: widget.providers);
  }

  @override
  Widget build(BuildContext context) {
    _fetchMenu();
    return Expanded(
      child: Container(
        color: AppColors.white,
        padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw, vertical: AppSize.s12.rh),
        child: BlocBuilder<MenusCubit, ResponseState>(
          builder: (context, state) {
            if (state is Success<MenuData>) {
              if (state.data.sections.isEmpty) {
                return Center(child: Text(AppStrings.no_menus_found.tr()));
              }
              return MenuListView(
                sections: state.data.sections,
                brandID: widget.brand,
                branchID: widget.branch,
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
