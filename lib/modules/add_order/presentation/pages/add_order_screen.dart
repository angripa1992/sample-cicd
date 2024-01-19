import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/add_order/presentation/cubit/fetch_menu_items_cubit.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import 'package:klikit/app/di.dart';
import 'package:klikit/modules/menu/presentation/cubit/menu_brands_cubit.dart';
import 'package:klikit/resources/colors.dart';
import 'add_order_body.dart';

class AddOrderScreen extends StatelessWidget {
  const AddOrderScreen({
    Key? key,
  }) : super(key: key);

  void _pop(BuildContext context) {
    if (CartManager().willUpdateOrder) {
      CartManager().clear();
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _pop(context);
        return false;
      },
      child: MultiBlocProvider(
        providers: [
          BlocProvider<MenuBrandsCubit>(create: (_) => getIt.get()),
          BlocProvider<FetchAddOrderMenuItemsCubit>(create: (_) => getIt.get()),
        ],
        child: SafeArea(
          child: Scaffold(
            backgroundColor: AppColors.white,
            body: AddOrderBody(
              onBack: () {
                _pop(context);
              },
            ),
          ),
        ),
      ),
    );
  }
}
