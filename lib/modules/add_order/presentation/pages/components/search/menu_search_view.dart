import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/menu/domain/entities/items.dart';
import 'package:klikit/modules/menu/domain/entities/sub_section.dart';

import '../../../../../../resources/values.dart';
import '../../../../domain/entities/sub_section_list_item.dart';
import '../../../../utils/available_time_provider.dart';
import '../menu_item_view.dart';

class MenuSearchView extends StatefulWidget {
  final List<SubSectionListItem> items;

  const MenuSearchView({Key? key, required this.items}) : super(key: key);

  @override
  State<MenuSearchView> createState() => _MenuSearchViewState();
}

class _MenuSearchViewState extends State<MenuSearchView> {
  final _sectionNotifier = ValueNotifier<List<SubSections>>([]);
  final _itemNotifier = ValueNotifier<List<MenuItems>>([]);
  final _sections = <SubSections>[];
  final _items = <MenuItems>[];

  @override
  void initState() {
    for (var element in widget.items) {
      _sections.add(element.subSections);
      _items.addAll(element.subSections.items);
    }
    _sectionNotifier.value = _sections;
    _itemNotifier.value = _items;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.s8.rh,
              horizontal: AppSize.s8.rw,
            ),
            child: ValueListenableBuilder<List<MenuItems>>(
              valueListenable: _itemNotifier,
              builder: (_, items, __) {
                return GridView.builder(
                  shrinkWrap: true,
                  //physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: AppSize.s10.rh,
                    childAspectRatio: ScreenSizes.isTablet ? 0.90 : 0.63,
                  ),
                  itemCount: items.length,
                  itemBuilder: (BuildContext context, int index) {
                    return MenuItemView(
                      menuItem: items[index],
                      dayInfo: AvailableTimeProvider()
                          .todayInfo(items[index].availableTimes!),
                      onAddItem: () {},
                    );
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
