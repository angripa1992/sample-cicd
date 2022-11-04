import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
        BlocProvider<MenuBrandsCubit>(
            create: (_) => getIt.get<MenuBrandsCubit>()),
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
