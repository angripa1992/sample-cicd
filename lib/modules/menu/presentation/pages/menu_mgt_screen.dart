import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/entities/brand.dart';
import 'package:klikit/modules/menu/presentation/cubit/menu_brands_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu_mgt_body.dart';

class MenuMgtScreen extends StatefulWidget {
  const MenuMgtScreen({Key? key}) : super(key: key);

  @override
  State<MenuMgtScreen> createState() => _MenuMgtScreenState();
}

class _MenuMgtScreenState extends State<MenuMgtScreen> {
  @override
  void initState() {
    context.read<MenuBrandsCubit>().fetchMenuBrands();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBrandsCubit, ResponseState>(
      builder: (context, state) {
        if (state is Success<List<MenuBrand>>) {
          return MenuMgtBody(brands: state.data);
        } else if (state is Failed) {
          return Center(child: Text(state.failure.message));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
