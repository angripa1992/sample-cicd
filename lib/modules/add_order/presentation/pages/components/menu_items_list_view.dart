import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/sub_section_list_item.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/subsection_info_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/tab_item_view.dart';
import 'package:klikit/modules/add_order/utils/available_time_provider.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:intl/intl.dart';

import '../../../../../resources/values.dart';
import 'dropdown/select_categories_dropdown.dart';

class MenuItemsListView extends StatefulWidget {
  final List<SubSectionListItem> items;

  const MenuItemsListView({Key? key, required this.items}) : super(key: key);

  @override
  State<MenuItemsListView> createState() => _MenuItemsListViewState();
}

class _MenuItemsListViewState extends State<MenuItemsListView> {
  late ItemScrollController _itemScrollController;

  @override
  void initState() {
    _itemScrollController = ItemScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print((1/100).floor());
    print(int.tryParse(DateFormat('HH:mm').format(DateTime.now()).replaceAll(":", ""),radix: 10));

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppSize.s12.rw),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CategoriesDropDown(
            items: widget.items,
            onChanged: (index) {
              _itemScrollController.jumpTo(index: index);
            },
          ),
          Expanded(
            child: ScrollableListTabScroller(
              itemScrollController: _itemScrollController,
              itemCount: widget.items.length,
              headerContainerBuilder: (context, widget) {
                return Padding(
                  padding: EdgeInsets.only(
                    top: AppSize.s8.rh,
                    bottom: AppSize.s24.rh,
                  ),
                  child: widget,
                );
              },
              tabBuilder: (BuildContext context, int index, bool active) {
                return TabItemView(
                  title: widget.items[index].subSections.title,
                  index: index,
                  active: active,
                );
              },
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  children: [
                    SubsectionInfoView(
                      index: index,
                      item: widget.items[index],
                    ),
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: widget.items[index].subSections.items.length,
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
