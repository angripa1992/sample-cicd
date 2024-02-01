import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/search/search_appbar.dart';
import 'package:klikit/resources/fonts.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/menu/menu_categories.dart';
import '../../../../../menu/domain/entities/menu/menu_item.dart';
import '../../../../utils/available_time_provider.dart';
import '../go_to_cart_button.dart';
import '../menu_category_item_view.dart';
import '../tab_item_view.dart';

class MenuSearchView extends StatefulWidget {
  final VoidCallback onBack;
  final VoidCallback goToCart;
  final List<MenuCategory> categories;
  final Function(int) onCategorySelected;
  final Function(MenuCategoryItem) onAddNonModifierItem;
  final Function(MenuCategoryItem) onAddModifierItem;
  final Function(MenuCategoryItem) onRemoveNonModifierItem;
  final Function(MenuCategoryItem) onShowDetails;

  const MenuSearchView({
    Key? key,
    required this.categories,
    required this.onBack,
    required this.onCategorySelected,
    required this.goToCart,
    required this.onAddModifierItem,
    required this.onAddNonModifierItem,
    required this.onRemoveNonModifierItem,
    required this.onShowDetails,
  }) : super(key: key);

  @override
  State<MenuSearchView> createState() => _MenuSearchViewState();
}

class _MenuSearchViewState extends State<MenuSearchView> {
  final _categoriesNotifier = ValueNotifier<List<MenuCategory>>([]);
  final _itemNotifier = ValueNotifier<List<MenuCategoryItem>>([]);
  final _categories = <MenuCategory>[];
  final _items = <MenuCategoryItem>[];

  @override
  void initState() {
    _categories.addAll(widget.categories);
    for (var category in _categories) {
      _items.addAll(category.items);
    }
    _categoriesNotifier.value = _categories;
    _itemNotifier.value = _items;
    super.initState();
  }

  void _applySearchQuery(String query) {
    if (query.isEmpty) {
      _categoriesNotifier.value = _categories;
      _itemNotifier.value = _items;
      return;
    }
    final filteredSection = <MenuCategory>[];
    final filteredItems = <MenuCategoryItem>[];
    for (var category in _categories) {
      if (category.title.toLowerCase().contains(query)) {
        filteredSection.add(category);
      }
    }
    _categoriesNotifier.value = filteredSection;
    for (var element in _items) {
      if (element.title.toLowerCase().contains(query)) {
        filteredItems.add(element);
      }
    }
    _itemNotifier.value = filteredItems;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
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
                style: mediumTextStyle(
                  color: AppColors.greyDarker,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSize.s16.rh,
                horizontal: AppSize.s12.rw,
              ),
              child: ValueListenableBuilder<List<MenuCategory>>(
                valueListenable: _categoriesNotifier,
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
                style: mediumTextStyle(
                  color: AppColors.greyDarker,
                  fontSize: AppFontSize.s14.rSp,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppSize.s12.rw,
                ),
                child: ValueListenableBuilder<List<MenuCategoryItem>>(
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
                        return MenuCategoryItemView(
                          menuItem: items[index],
                          dayInfo: MenuAvailableTimeProvider().findCurrentDay(items[index].availableTimes),
                          onAddNonModifierItem: () {
                            widget.onAddNonModifierItem(items[index]);
                          },
                          onAddModifierItem: () {
                            widget.onAddModifierItem(items[index]);
                          },
                          onRemoveNonModifierItem: () {
                            widget.onRemoveNonModifierItem(items[index]);
                          },
                          onShowDetails: () {
                            widget.onShowDetails(items[index]);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              color: AppColors.greyLight,
              child: GoToCartButton(
                onGotoCart: widget.goToCart,
              ),
            )
          ],
        ),
      ),
    );
  }
}
