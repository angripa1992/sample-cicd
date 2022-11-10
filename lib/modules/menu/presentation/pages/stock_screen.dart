import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/menu/domain/usecase/update_menu.dart';
import 'package:klikit/modules/menu/presentation/cubit/brand_selection_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/menus_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/modifier_groups_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/tab_selection_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_item_cubit.dart';
import 'package:klikit/modules/menu/presentation/cubit/update_menu_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu_mgt_screen.dart';

import '../../../../app/di.dart';
import '../../../../resources/styles.dart';
import '../cubit/menu_brands_cubit.dart';

class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MenuBrandsCubit>(create: (_) => getIt.get()),
        BlocProvider<BrandSelectionCubit>(create: (_) => getIt.get()),
        BlocProvider<TabSelectionCubit>(create: (_) => getIt.get()),
        BlocProvider<MenusCubit>(create: (_) => getIt.get()),
        BlocProvider<UpdateItemCubit>(create: (_) => getIt.get()),
        BlocProvider<UpdateMenuCubit>(create: (_) => getIt.get()),
        BlocProvider<ModifierGroupsCubit>(create: (_) => getIt.get()),
      ],
      child: Scaffold(
        appBar: AppBar(
          leading: const SizedBox(),
          title: Text('Manage Menus'),
          titleTextStyle: getAppBarTextStyle(),
          centerTitle: true,
          flexibleSpace: getAppBarBackground(),
        ),
        body: const MenuMgtScreen(),
      ),
    );
  }
}
