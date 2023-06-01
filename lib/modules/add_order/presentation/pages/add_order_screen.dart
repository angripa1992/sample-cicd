import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/add_order/presentation/cubit/fetch_sub_section_cubit.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../app/di.dart';
import '../../../../resources/styles.dart';
import '../../../menu/presentation/cubit/menu_brands_cubit.dart';
import '../../domain/entities/add_to_cart_item.dart';
import 'add_order_body.dart';

class AddOrderScreen extends StatelessWidget {
  final bool willOpenCart;
  final bool willUpdateCart;
  const AddOrderScreen({Key? key, required this.willOpenCart, required this.willUpdateCart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MenuBrandsCubit>(create: (_) => getIt.get()),
        BlocProvider<FetchSubSectionCubit>(create: (_) => getIt.get()),
      ],
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 0,
          flexibleSpace: getAppBarBackground(),
        ),
        body: AddOrderBody(
          onBack: () {
            if(willUpdateCart){
              CartManager().clear();
            }
            Navigator.pop(context);
          },
          willOpenCart: willOpenCart,
        ),
      ),
    );
  }
}
