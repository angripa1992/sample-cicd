import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/add_order/domain/entities/sub_section_list_item.dart';
import 'package:klikit/modules/add_order/presentation/cubit/fetch_sub_section_cubit.dart';

import '../../../../core/utils/response_state.dart';
import '../../../menu/domain/entities/brand.dart';
import '../../../menu/presentation/cubit/menu_brands_cubit.dart';
import 'components/brand_selector_app_bar.dart';
import 'components/empty_brand_view.dart';
import 'components/menu_items_list_view.dart';

class AddOrderBody extends StatefulWidget {
  final VoidCallback onBack;

  const AddOrderBody({Key? key, required this.onBack}) : super(key: key);

  @override
  State<AddOrderBody> createState() => _AddOrderBodyState();
}

class _AddOrderBodyState extends State<AddOrderBody> {
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
        BrandSelectorAppBar(
          brands: brands,
          onChanged: (brand) {
            context.read<FetchSubSectionCubit>().fetchSubsection(brand.id);
          },
          onBack: widget.onBack,
        ),
        Expanded(
          child: BlocBuilder<FetchSubSectionCubit, ResponseState>(
            builder: (context, state) {
              if (state is Loading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is Success<List<SubSectionListItem>>) {
                return MenuItemsListView(items: state.data);
              }
              return const EmptyBrandView();
            },
          ),
        ),
      ],
    );
  }
}
