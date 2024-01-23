import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/dropdown/select_categories_dropdown.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/menu_category_info_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/menu_category_item_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/search/menu_search_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/search/search_button.dart';
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
import '../../../domain/entities/add_to_cart_item.dart';
import '../../../domain/entities/modifier/item_modifier_group.dart';
import '../../../utils/modifier_manager.dart';
import 'menu_item_description.dart';
import 'order_type_selector.dart';

class MenuCategoryItemsListView extends StatefulWidget {
  final Brand? brand;
  final List<MenuCategory> categories;
  final VoidCallback onCartTap;
  final VoidCallback refreshMenu;
  final Function(AddToCartItem?) onAddToCart;
  final Function(List<MenuItemModifierGroup>, MenuCategoryItem, Brand) onAddModifier;

  const MenuCategoryItemsListView({
    Key? key,
    required this.categories,
    required this.onCartTap,
    required this.onAddToCart,
    required this.onAddModifier,
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
        if (data.isNotEmpty) {
          ModifierManager().removeDisabledModifier(data);
          widget.onAddModifier(data, item, widget.brand!);
        } else {
          _showItemDetails(context, item);
        }
      },
    );
  }

  void _addNonModifierItem(MenuCategoryItem item, int quantity, String instruction) {
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
            decoration: BoxDecoration(color: AppColors.grey),
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
          onItemSelected: (selectedMenuItem) {
            _fetchModifier(selectedMenuItem);
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
          Divider(thickness: 8.rh, color: AppColors.grey),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.rw, vertical: 8.rh),
            child: SearchActionButtonView(onTap: _search),
          ),
          Divider(thickness: 8.rh, color: AppColors.grey),
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
          return Padding(
            padding: EdgeInsets.only(bottom: 16.rh, left: 8.rw, right: 8.rw,top: 8.rh),
            child: widget,
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
          MenuCategoryInfoView(index: index, category: category),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.rh, horizontal: 8.rw),
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
                  dayInfo: MenuAvailableTimeProvider().findCurrentDay(category.availableTimes),
                  onAddItem: () {
                    _fetchModifier(category.items[index]);
                  },
                );
              },
            ),
          ),
        ],
      );
}
