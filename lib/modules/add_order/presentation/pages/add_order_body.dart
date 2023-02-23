import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/response_state.dart';
import '../../../menu/domain/entities/brand.dart';
import '../../../menu/presentation/cubit/menu_brands_cubit.dart';
import '../../../menu/presentation/pages/filter_by_brands_view.dart';

class AddOrderBody extends StatefulWidget {
  const AddOrderBody({Key? key}) : super(key: key);

  @override
  State<AddOrderBody> createState() => _AddOrderBodyState();
}

class _AddOrderBodyState extends State<AddOrderBody> {
  final _brandNotifier = ValueNotifier<MenuBrand?>(null);

  @override
  void initState() {
    super.initState();
    context.read<MenuBrandsCubit>().fetchMenuBrands();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuBrandsCubit, ResponseState>(
      builder: (context, state) {
        if (state is Success<List<MenuBrand>>) {
          return _body(state.data);
        } else if (state is Failed) {
          return Center(child: Text(state.failure.message));
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _body(List<MenuBrand> brands) {
    return Column(
      children: [
        FilterByBrandsView(
          brands: brands,
          onChanged: (brand) {
            _brandNotifier.value = brand;
          },
        ),
        ValueListenableBuilder<MenuBrand?>(
          builder: (_, menu, child) {
            return Text(menu?.title ?? 'Null');
          },
          valueListenable: _brandNotifier,
        ),
      ],
    );
  }
}
