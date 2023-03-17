import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/modules/add_order/domain/entities/sub_section_list_item.dart';
import 'package:klikit/modules/add_order/presentation/cubit/fetch_sub_section_cubit.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';



import '../../../../core/utils/response_state.dart';
import '../../../menu/domain/entities/brand.dart';
import '../../../menu/presentation/cubit/menu_brands_cubit.dart';
import 'components/brand_selector_app_bar.dart';

class AddOrderBody extends StatefulWidget {
  const AddOrderBody({Key? key}) : super(key: key);

  @override
  State<AddOrderBody> createState() => _AddOrderBodyState();
}

class _AddOrderBodyState extends State<AddOrderBody> {

  late ItemScrollController _itemScrollController;

  @override
  void initState() {
    _itemScrollController = ItemScrollController();
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
        ),
        BlocBuilder<FetchSubSectionCubit, ResponseState>(
          builder: (context, state) {
            if (state is Loading) {
              return const CircularProgressIndicator();
            } else if (state is Success<List<SubSectionListItem>>) {
              return _subSectionList(state.data);
            }
            return const Text('Nothing found');
          },
        ),
      ],
    );
  }

  Widget _subSectionList(List<SubSectionListItem> items) {
    return Expanded(
      child: Column(
        children: [
          ElevatedButton(onPressed: (){
            _itemScrollController.jumpTo(index: 3);
          }, child: Text('click')),
          Expanded(
            child: ScrollableListTabScroller(
              itemScrollController: _itemScrollController,
              itemCount: items.length,
              headerContainerBuilder: (context, widget) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: widget,
                );
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
                    GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: items[index].subSections.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            color: Colors.amber,
                            child: Center(child: Text('$index')),
                          );
                        }),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
