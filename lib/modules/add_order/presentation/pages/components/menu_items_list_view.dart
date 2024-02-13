import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/menu_category_info_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/menu_category_item_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/search/menu_search_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/search/search_button.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/select_categories_dropdown.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/tab_item_view.dart';
import 'package:klikit/modules/add_order/utils/available_time_provider.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/resources/values.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../menu/domain/entities/menu/menu_categories.dart';
import '../../../../menu/domain/entities/menu/menu_item.dart';
import '../../../../widgets/snackbars.dart';
import '../../../domain/entities/modifier/item_modifier_group.dart';
import '../../../utils/modifier_manager.dart';
import 'order_type_selector.dart';

class MenuCategoryItemsListView extends StatefulWidget {
  final Brand? brand;
  final List<MenuCategory> categories;
  final VoidCallback onCartTap;
  final VoidCallback refreshMenu;
  final Function(MenuCategoryItem, Brand) onAddNonModifierItem;
  final Function(MenuCategoryItem, Brand) onNavigateItemDetails;
  final Function(List<MenuItemModifierGroup>, MenuCategoryItem, Brand) onNavigateAddModifier;

  const MenuCategoryItemsListView({
    Key? key,
    required this.categories,
    required this.onCartTap,
    required this.onAddNonModifierItem,
    required this.onNavigateItemDetails,
    required this.onNavigateAddModifier,
    required this.refreshMenu,
    this.brand,
  }) : super(key: key);

  @override
  State<MenuCategoryItemsListView> createState() => _MenuCategoryItemsListViewState();
}

class _MenuCategoryItemsListViewState extends State<MenuCategoryItemsListView> {
  late ValueNotifier<MenuCategory?> _categoriesNotifier;
  final _addOrderRepository = getIt.get<AddOrderRepository>();
  final _itemScrollController = ItemScrollController();

  @override
  void initState() {
    _categoriesNotifier = ValueNotifier<MenuCategory?>(null);
    super.initState();
  }

  void _fetchModifier(MenuCategoryItem item) async {
    EasyLoading.show();
    final response = await _addOrderRepository.fetchModifiers(
      itemId: item.id,
      sectionID: item.sectionID,
      categoryID: item.categoryID,
      branchInfo: item.branchInfo,
      type: CartManager().orderType,
    );
    response.fold(
      (failure) {
        EasyLoading.dismiss();
        showErrorSnackBar(context, failure.message);
      },
      (data) {
        EasyLoading.dismiss();
        final filteredModifierGroups = ModifierManager().removeDisabledModifier(data);
        widget.onNavigateAddModifier(filteredModifierGroups, item, widget.brand!);
      },
    );
  }

  void _search() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => MenuSearchView(
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
          onAddModifierItem: (selectedMenuItem) {
            _fetchModifier(selectedMenuItem);
          },
          onAddNonModifierItem: (selectedMenuItem) {
            widget.onAddNonModifierItem(selectedMenuItem, widget.brand!);
          },
          onRemoveNonModifierItem: (selectedMenuItem) {
            CartManager().removeNonModifierItemFromCart(selectedMenuItem.id);
          },
          onShowDetails: (item) {
            if (item.haveModifier) {
              _fetchModifier(item);
            } else {
              widget.onNavigateItemDetails(item, widget.brand!);
            }
          },
        ),
      ),
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
        _header(),
        _menuCategoryFilter(),
        Expanded(child: _menuCategoryList()),
      ],
    );
  }

  Widget _header() => Column(
        children: [
          ValueListenableBuilder<int?>(
            valueListenable: CartManager().orderTypeNotifier,
            builder: (context, type, child) => Visibility(
              visible: !CartManager().willUpdateOrder,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 8.rh),
                child: OrderTypeSelector(
                  initialType: type ?? OrderType.DINE_IN,
                  onTypeChange: (type) {
                    if (CartManager().items.isNotEmpty) {
                      CartManager().clearCart();
                    }
                    CartManager().orderType = type;
                    widget.refreshMenu();
                  },
                ),
              ),
            ),
          ),
          Divider(thickness: 6.rh, color: AppColors.grey),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 4.rh),
            child: SearchActionButtonView(onTap: _search),
          ),
          Divider(thickness: 6.rh, color: AppColors.grey),
        ],
      );

  Widget _menuCategoryFilter() => Padding(
        padding: EdgeInsets.only(left: 16.rw, right: 16.rw, bottom: 8.rh),
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
      );

  Widget _menuCategoryList() => ScrollableListTabScroller(
        itemScrollController: _itemScrollController,
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        itemCount: widget.categories.length,
        headerContainerBuilder: (context, widget) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.rw),
                child: widget,
              ),
              SizedBox(height: 8.rh),
              Divider(thickness: 6.rh, color: AppColors.grey),
            ],
          );
        },
        tabBuilder: (BuildContext context, int index, bool active) {
          if (active) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _categoriesNotifier.value = widget.categories[index];
            });
          }
          return TabItemView(title: widget.categories[index].title, index: index, active: active);
        },
        itemBuilder: (BuildContext context, int index) => _menuItemList(index, widget.categories[index]),
      );

  Widget _menuItemList(int index, MenuCategory category) => Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 8.rh),
            child: MenuCategoryInfoView(index: index, category: category),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.rh, horizontal: 12.rw),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: AppSize.s10.rh,
                childAspectRatio: ScreenSizes.isTablet ? 0.75 : 0.63,
              ),
              itemCount: category.items.length,
              itemBuilder: (BuildContext context, int index) {
                return MenuCategoryItemView(
                  menuItem: category.items[index],
                  dayInfo: MenuAvailableTimeProvider().findCurrentDay(category.availableTimes),
                  onAddNonModifierItem: () {
                    widget.onAddNonModifierItem(category.items[index], widget.brand!);
                  },
                  onAddModifierItem: () {
                    _fetchModifier(category.items[index]);
                  },
                  onRemoveNonModifierItem: () {
                    CartManager().removeNonModifierItemFromCart(category.items[index].id);
                  },
                  onShowDetails: () {
                    final item = category.items[index];
                    if (item.haveModifier) {
                      _fetchModifier(item);
                    } else {
                      widget.onNavigateItemDetails(item, widget.brand!);
                    }
                  },
                );
              },
            ),
          ),
        ],
      );
}
