import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/add_order/presentation/cubit/fetch_sub_section_cubit.dart';

import '../../../../app/di.dart';
import '../../../menu/presentation/cubit/menu_brands_cubit.dart';
import 'add_order_body.dart';

class AddOrderScreen extends StatelessWidget {
  const AddOrderScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MenuBrandsCubit>(create: (_) => getIt.get()),
        BlocProvider<FetchSubSectionCubit>(create: (_) => getIt.get()),
      ],
      child: Scaffold(
        appBar: AppBar(),
        body: const AddOrderBody(),
      ),
    );
  }
}
