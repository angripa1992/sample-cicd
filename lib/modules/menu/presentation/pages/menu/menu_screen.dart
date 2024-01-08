import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/modules/menu/presentation/cubit/menus_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_list_view.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/fonts.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/styles.dart';

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
    _fetchMenu();
    SegmentManager().screen(event: SegmentEvents.MENU_SCREEN, name: 'Menu Screen');
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MenuScreen oldWidget) {
    _fetchMenu();
    super.didUpdateWidget(oldWidget);
  }

  void _fetchMenu() {
    context.read<MenusCubit>().fetchMenu(
          branchID: widget.branch,
          brandId: widget.brand,
          providers: widget.providers,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child:BlocBuilder<MenusCubit, ResponseState>(
              builder: (context, state) {
                if (state is Success<MenuData>) {
                  if (state.data.sections.isEmpty) {
                    return Center(
                      child: Text(AppStrings.no_menus_found.tr()),
                    );
                  }
                  return MenuListView(
                    sections: state.data.sections,
                    brandID: widget.brand!.id,
                    providerID: widget.providerId.orZero(),
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
