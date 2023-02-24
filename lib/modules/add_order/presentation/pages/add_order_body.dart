import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/add_order/domain/entities/sub_section_list_item.dart';
import 'package:klikit/modules/add_order/presentation/cubit/fetch_sub_section_cubit.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';

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
            //_brandNotifier.value = brand;
            context.read<FetchSubSectionCubit>().fetchSubsection(brand.id);
          },
        ),
        // ValueListenableBuilder<MenuBrand?>(
        //   builder: (_, menu, child) {
        //     if(menu == null){
        //       return const Text('Null');
        //     }
        //     return BlocBuilder(builder: builder)
        //   },
        //   valueListenable: _brandNotifier,
        // ),
        BlocBuilder<FetchSubSectionCubit, ResponseState>(
          builder: (context, state) {
            if (state is Loading) {
              return CircularProgressIndicator();
            } else if (state is Success<List<SubSectionListItem>>) {
              return _subSectionList(state.data);
            }
            return Text('Nothing found');
          },
        ),
      ],
    );
  }

  Widget _subSectionList(List<SubSectionListItem> items) {
    return Expanded(
      child: ScrollableListTabScroller(
        itemCount: items.length,
        headerContainerBuilder: (context,widget){
          return Padding(padding: const EdgeInsets.all(8.0),child: widget,);
        },
        tabBuilder: (BuildContext context, int index, bool active) {
          return SizedBox(
            child: Container(
              color: active ? Colors.deepOrange : Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  items[index].subSections.title,
                  style: !active
                      ? null
                      : TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.green),
                ),
              ),
            ),
          );
        },
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              Text(
                items[index].subSections.title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              ...items[index]
                  .subSections
                  .items
                  .asMap()
                  .map(
                    (index, value) => MapEntry(
                      index,
                      ListTile(
                        leading: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                              shape: BoxShape.circle, color: Colors.grey),
                          alignment: Alignment.center,
                          child: Text(index.toString()),
                        ),
                        title: Text(value.title),
                      ),
                    ),
                  )
                  .values
            ],
          );
        },
      ),
    );
  }
}
