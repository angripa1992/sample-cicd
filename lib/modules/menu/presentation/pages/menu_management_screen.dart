import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/base/common_dashboard_app_bar.dart';
import 'package:klikit/modules/menu/presentation/cubit/brand_selection_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/check_affected_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/fetch_modifier_groups_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/menus_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/tab_selection_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_item_snooze_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_menu_enabled_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu_mgt_screen.dart';
import 'package:klikit/resources/values.dart';

import '../../../../app/di.dart';
import '../../../../resources/strings.dart';
import '../../../../segments/event_manager.dart';
import '../../../../segments/segemnt_data_provider.dart';
import '../cubit/aggregator_selection_cubit.dart';
import '../cubit/menu_brands_cubit.dart';

class MenuManagementScreen extends StatefulWidget {
  const MenuManagementScreen({Key? key}) : super(key: key);

  @override
  State<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends State<MenuManagementScreen> {
  @override
  void initState() {
    SegmentManager().screen(event: SegmentEvents.MENU_TAB, name: 'Menu Tab');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MenuBrandsCubit>(create: (_) => getIt.get()),
        BlocProvider<BrandSelectionCubit>(create: (_) => getIt.get()),
        BlocProvider<TabSelectionCubit>(create: (_) => getIt.get()),
        BlocProvider<MenusCubit>(create: (_) => getIt.get()),
        BlocProvider<UpdateItemSnoozeCubit>(create: (_) => getIt.get()),
        BlocProvider<UpdateMenuEnabledCubit>(create: (_) => getIt.get()),
        BlocProvider<FetchModifierGroupsCubit>(create: (_) => getIt.get()),
        BlocProvider<CheckAffectedCubit>(create: (_) => getIt.get()),
        BlocProvider<AggregatorSelectionCubit>(create: (_) => getIt.get()),
      ],
      child: Scaffold(
        body: Column(
          children: [
            CommonDashboardAppBar(title: AppStrings.menu.tr()),
            AppSize.s1.verticalSpacer(),
            const Expanded(child: MenuMgtScreen()),
          ],
        ),
      ),
    );
  }
}
