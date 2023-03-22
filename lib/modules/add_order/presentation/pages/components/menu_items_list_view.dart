import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/sub_section_list_item.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/subsection_info_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/tab_item_view.dart';
import 'package:klikit/modules/add_order/utils/available_time_provider.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';
import 'dropdown/select_categories_dropdown.dart';
import 'menu_item_view.dart';

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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSize.s16.rw),
          child: CategoriesDropDown(
            items: widget.items,
            onChanged: (index) {
              _itemScrollController.jumpTo(index: index);
            },
          ),
        ),
        Expanded(
          child: ScrollableListTabScroller(
            itemScrollController: _itemScrollController,
            itemCount: widget.items.length,
            headerContainerBuilder: (context, widget) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: AppSize.s16.rh,
                  left: AppSize.s8.rw,
                  right: AppSize.s8.rw,
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
              final listItem = widget.items[index];
              return Container(
                color: AppColors.pearl,
                child: Column(
                  children: [
                    SubsectionInfoView(
                      index: index,
                      item: listItem,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: AppSize.s8.rh,
                        horizontal: AppSize.s8.rw,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: AppSize.s10.rh,
                          childAspectRatio: 0.6,
                        ),
                        itemCount: listItem.subSections.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MenuItemView(
                            menuItem: listItem.subSections.items[index],
                            dayInfo: AvailableTimeProvider()
                                .todayInfo(listItem.availableTimes),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
