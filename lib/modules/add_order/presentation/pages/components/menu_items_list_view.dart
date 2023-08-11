import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/menu_category_info_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/search/menu_search_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/search/search_button.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/tab_item_view.dart';
import 'package:klikit/modules/add_order/utils/available_time_provider.dart';
import 'package:klikit/modules/menu/domain/entities/brand.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';
import '../../../../menu/domain/entities/menu/menu_categories.dart';
import '../../../../menu/domain/entities/menu/menu_item.dart';
import '../../../../widgets/snackbars.dart';
import '../../../domain/entities/add_to_cart_item.dart';
import '../../../domain/entities/modifier/item_modifier_group.dart';
import '../../../utils/modifier_manager.dart';
import 'dropdown/select_categories_dropdown.dart';
import 'menu_category_item_view.dart';
import 'menu_item_description.dart';

class MenuCategoryItemsListView extends StatefulWidget {
  final MenuBrand? brand;
  final List<MenuCategory> categories;
  final VoidCallback onCartTap;
  final Function(AddToCartItem?) onAddToCart;
  final Function(List<AddOrderItemModifierGroup>, MenuCategoryItem, MenuBrand)
      onAddModifier;

  const MenuCategoryItemsListView({
    Key? key,
    required this.categories,
    required this.onCartTap,
    this.brand,
    required this.onAddToCart,
    required this.onAddModifier,
  }) : super(key: key);

  @override
  State<MenuCategoryItemsListView> createState() =>
      _MenuCategoryItemsListViewState();
}

class _MenuCategoryItemsListViewState extends State<MenuCategoryItemsListView> {
  late ValueNotifier<MenuCategory?> _categoriesNotifier;
  late ItemScrollController _itemScrollController;
  final _addOrderRepository = getIt.get<AddOrderRepository>();

  @override
  void initState() {
    _categoriesNotifier = ValueNotifier<MenuCategory?>(null);
    _itemScrollController = ItemScrollController();
    super.initState();
  }

  void _fetchModifier(MenuCategoryItem item) async {
    EasyLoading.show();
    final response = await _addOrderRepository.fetchModifiers(itemId: item.id);
    response.fold(
      (failure) {
        EasyLoading.dismiss();
        showErrorSnackBar(context, failure.message);
      },
      (data) {
        EasyLoading.dismiss();
        if (data.isNotEmpty) {
          ModifierManager().removeDisabledModifier(data);
          widget.onAddModifier(data, item, widget.brand!);
        } else {
          _showItemDetails(context, item);
        }
      },
    );
  }

  void _addNonModifierItem(
    MenuCategoryItem item,
    int quantity,
    String instruction,
  ) {
    widget.onAddToCart(
      AddToCartItem(
        modifiers: [],
        item: item,
        quantity: quantity,
        itemInstruction: instruction,
        modifiersPrice: 0,
        itemPrice: item.klikitPrice(),
        brand: widget.brand!,
        discountType: DiscountType.flat,
        discountValue: 0,
      ),
    );
  }

  void _showItemDetails(BuildContext context, MenuCategoryItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            margin: EdgeInsets.only(top: ScreenSizes.statusBarHeight),
            decoration: BoxDecoration(
              color: AppColors.whiteSmoke,
            ),
            child: MenuItemDescription(
              menuCategoryItem: item,
              addToCart: (quantity, instruction) {
                Navigator.pop(context);
                _addNonModifierItem(item, quantity, instruction);
              },
            ),
          ),
        );
      },
    );
  }

  void _search() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            margin: EdgeInsets.only(top: ScreenSizes.statusBarHeight),
            child: MenuSearchView(
              categories: widget.categories,
              onBack: () {
                Navigator.pop(context);
              },
              onCategorySelected: (selectedId) {
                Navigator.pop(context);
                _jumpToCategoryIndexById(selectedId);
              },
              goToCart: () {
                Navigator.pop(context);
                widget.onCartTap();
              },
              onItemSelected: (selectedMenuItem) {
                _fetchModifier(selectedMenuItem);
              },
            ),
          ),
        );
      },
    );
  }

  void _jumpToCategoryIndexById(int id) {
    widget.categories.asMap().forEach((index, category) {
      if (category.id == id) {
        _itemScrollController.jumpTo(index: index);
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s10.rw,
            vertical: AppSize.s12.rh,
          ),
          child: SearchActionButtonView(onTap: _search),
        ),
        Padding(
          padding: EdgeInsets.only(
            left: AppSize.s16.rw,
            right: AppSize.s16.rw,
            bottom: AppSize.s8.rh,
          ),
          child: ValueListenableBuilder<MenuCategory?>(
            valueListenable: _categoriesNotifier,
            builder: (_, category, __) {
              return CategoriesDropDown(
                categories: widget.categories,
                onChanged: (index) {
                  _itemScrollController.jumpTo(index: index);
                },
                initValue: category,
              );
            },
          ),
        ),
        Expanded(
          child: ScrollableListTabScroller(
            itemScrollController: _itemScrollController,
            itemCount: widget.categories.length,
            earlyChangePositionOffset: -50,
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
              if (active) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _categoriesNotifier.value = widget.categories[index];
                });
              }
              return TabItemView(
                title: widget.categories[index].title,
                index: index,
                active: active,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              final category = widget.categories[index];
              return Container(
                color: AppColors.pearl,
                child: Column(
                  children: [
                    MenuCategoryInfoView(
                      index: index,
                      category: category,
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
                          childAspectRatio: ScreenSizes.isTablet ? 0.85 : 0.63,
                        ),
                        itemCount: category.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MenuCategoryItemView(
                            menuItem: category.items[index],
                            dayInfo: AvailableTimeProvider()
                                .todayInfo(category.availableTimes),
                            onAddItem: () {
                              _fetchModifier(category.items[index]);
                            },
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
