import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/search/search_appbar.dart';
import 'package:klikit/modules/menu/domain/entities/items.dart';
import 'package:klikit/modules/menu/domain/entities/sub_section.dart';
import 'package:klikit/resources/fonts.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../domain/entities/sub_section_list_item.dart';
import '../../../../utils/available_time_provider.dart';
import '../go_to_cart_button.dart';
import '../menu_item_view.dart';
import '../tab_item_view.dart';

class MenuSearchView extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback goToCart;
  final List<SubSectionListItem> items;
  final Function(int) onCategorySelected;
  final Function(MenuItems) onItemSelected;

  const MenuSearchView({
    Key? key,
    required this.items,
    required this.onBack,
    required this.onCategorySelected,
    required this.goToCart,
    required this.onItemSelected,
  }) : super(key: key);

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

  void _applySearchQuery(String query) {
    if (query.isEmpty) {
      _sectionNotifier.value = _sections;
      _itemNotifier.value = _items;
      return;
    }
    final filteredSection = <SubSections>[];
    final filteredItems = <MenuItems>[];
    for (var element in _sections) {
      if (element.title.toLowerCase().contains(query)) {
        filteredSection.add(element);
      }
    }
    _sectionNotifier.value = filteredSection;
    for (var element in _items) {
      if (element.title.toLowerCase().contains(query)) {
        filteredItems.add(element);
      }
    }
    _itemNotifier.value = filteredItems;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteSmoke,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SearchAppBar(
            onBack: widget.onBack,
            onTextChanged: _applySearchQuery,
          ),
          Padding(
            padding: EdgeInsets.only(
              left: AppSize.s12.rw,
              top: AppSize.s16.rh,
            ),
            child: Text(
              AppStrings.categories.tr(),
              style: getMediumTextStyle(
                color: AppColors.dustyGreay,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: AppSize.s16.rh,
              horizontal: AppSize.s12.rw,
            ),
            child: ValueListenableBuilder<List<SubSections>>(
              valueListenable: _sectionNotifier,
              builder: (_, sections, __) {
                if (sections.isEmpty) {
                  return Center(
                    child: Text(AppStrings.no_categories_found.tr()),
                  );
                }
                return Wrap(
                  alignment: WrapAlignment.start,
                  spacing: AppSize.s8.rw,
                  runSpacing: AppSize.s8.rh,
                  children: List.generate(
                    sections.length > 4 ? 4 : sections.length,
                    (index) {
                      return InkWell(
                        onTap: () {
                          widget.onCategorySelected(sections[index].id);
                        },
                        child: TabItemView(
                          index: index,
                          title: sections[index].title,
                          active: false,
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: AppSize.s12.rw,
              bottom: AppSize.s12.rh,
            ),
            child: Text(
              AppStrings.Items.tr(),
              style: getMediumTextStyle(
                color: AppColors.dustyGreay,
                fontSize: AppFontSize.s14.rSp,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSize.s12.rw,
              ),
              child: ValueListenableBuilder<List<MenuItems>>(
                valueListenable: _itemNotifier,
                builder: (_, items, __) {
                  if (items.isEmpty) {
                    return Center(
                        child: Text(
                      AppStrings.no_item_found.tr(),
                    ));
                  }
                  return GridView.builder(
                    shrinkWrap: true,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: AppSize.s10.rh,
                      childAspectRatio: ScreenSizes.isTablet ? 0.85 : 0.63,
                    ),
                    itemCount: items.length,
                    itemBuilder: (BuildContext context, int index) {
                      return MenuItemView(
                        menuItem: items[index],
                        dayInfo: AvailableTimeProvider()
                            .todayInfo(items[index].availableTimes!),
                        onAddItem: () {
                          widget.onItemSelected(items[index]);
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ),
          Container(
            color: AppColors.pearl,
            child: GoToCartButton(
              onGotoCart: widget.goToCart,
            ),
          )
        ],
      ),
    );
  }
}
