import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/add_order/presentation/cubit/fetch_menu_items_cubit.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../app/di.dart';
import '../../../menu/presentation/cubit/menu_brands_cubit.dart';
import 'add_order_body.dart';

class AddOrderScreen extends StatelessWidget {
  const AddOrderScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MenuBrandsCubit>(create: (_) => getIt.get()),
        BlocProvider<FetchAddOrderMenuItemsCubit>(create: (_) => getIt.get()),
      ],
      child: SafeArea(
        child: Scaffold(
          body: AddOrderBody(
            onBack: () {
              if (CartManager().willUpdateOrder) {
                CartManager().clear();
              }
              Navigator.pop(context);
            },
          ),
        ),
      ),
    );
  }
}
