import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/menu/domain/entities/menues.dart';
import 'package:klikit/modules/menu/presentation/cubit/menus_cubit.dart';
import 'package:klikit/modules/menu/presentation/pages/menu/menu_list_view.dart';

class MenuScreen extends StatelessWidget {
  final int brandID;

  const MenuScreen({Key? key, required this.brandID}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<MenusCubit>().fetchMenu(brandID);
    return Expanded(
      child: BlocBuilder<MenusCubit, ResponseState>(
        builder: (context, state) {
          if (state is Success<MenusData>) {
            if (state.data.sections.isEmpty) {
              return const Center(child: Text('No menus found!'),);
            }
            return MenuListView(
              sections: state.data.sections,
              brandID: brandID,
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
