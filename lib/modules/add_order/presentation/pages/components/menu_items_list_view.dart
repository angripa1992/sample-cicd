import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/sub_section_list_item.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/search/menu_search_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/search/search_button.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/subsection_info_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/tab_item_view.dart';
import 'package:klikit/modules/add_order/utils/available_time_provider.dart';
import 'package:klikit/modules/menu/domain/entities/brand.dart';
import 'package:scrollable_list_tab_scroller/scrollable_list_tab_scroller.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../../app/constants.dart';
import '../../../../../resources/colors.dart';
import '../../../../../resources/values.dart';
import '../../../../menu/domain/entities/items.dart';
import '../../../../widgets/snackbars.dart';
import '../../../domain/entities/add_to_cart_item.dart';
import '../../../domain/entities/item_modifier_group.dart';
import '../../../utils/modifier_manager.dart';
import '../../../utils/order_price_provider.dart';
import 'dropdown/select_categories_dropdown.dart';
import 'menu_item_description.dart';
import 'menu_item_view.dart';

class MenuItemsListView extends StatefulWidget {
  final MenuBrand? brand;
  final List<SubSectionListItem> items;
  final VoidCallback onCartTap;
  final Function(AddToCartItem?) onAddToCart;
  final Function(List<ItemModifierGroup>, MenuItems, MenuBrand) onAddModifier;

  const MenuItemsListView({
    Key? key,
    required this.items,
    required this.onCartTap,
    this.brand,
    required this.onAddToCart,
    required this.onAddModifier,
  }) : super(key: key);

  @override
  State<MenuItemsListView> createState() => _MenuItemsListViewState();
}

class _MenuItemsListViewState extends State<MenuItemsListView> {
  final _categoriesNotifier = ValueNotifier<SubSectionListItem?>(null);
  late ItemScrollController _itemScrollController;
  final _addOrderRepository = getIt.get<AddOrderRepository>();

  @override
  void initState() {
    _itemScrollController = ItemScrollController();
    super.initState();
  }

  void _fetchModifier(MenuItems item) async {
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

  void _addNonModifierItem(MenuItems item, int quantity,String instruction) {
    widget.onAddToCart(
      AddToCartItem(
        modifiers: [],
        item: item,
        quantity: quantity,
        itemInstruction: instruction,
        modifiersPrice: 0,
        itemPrice: OrderPriceProvider.klikitPrice(item.prices),
        brand: widget.brand!,
        discountType: DiscountType.flat,
        discountValue: 0,
      ),
    );
  }

  void _showItemDetails(BuildContext context, MenuItems item) {
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
              // borderRadius: BorderRadius.only(
              //     topLeft: Radius.circular(AppSize.s12.rSp),
              //     topRight: Radius.circular(AppSize.s12.rSp)),
              color: AppColors.whiteSmoke,
            ),
            child: MenuItemDescription(
              items: item,
              addToCart: (quantity,instruction) {
                Navigator.pop(context);
                _addNonModifierItem(item, quantity,instruction);
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
              items: widget.items,
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
    widget.items.asMap().forEach((index, value) {
      if (value.subSections.id == id) {
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
          child: ValueListenableBuilder<SubSectionListItem?>(
            valueListenable: _categoriesNotifier,
            builder: (_, category, __) {
              return CategoriesDropDown(
                items: widget.items,
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
            itemCount: widget.items.length,
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
                  _categoriesNotifier.value = widget.items[index];
                });
              }
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
                          childAspectRatio: ScreenSizes.isTablet ? 0.85 : 0.63,
                        ),
                        itemCount: listItem.subSections.items.length,
                        itemBuilder: (BuildContext context, int index) {
                          return MenuItemView(
                            menuItem: listItem.subSections.items[index],
                            dayInfo: AvailableTimeProvider()
                                .todayInfo(listItem.availableTimes),
                            onAddItem: () {
                              _fetchModifier(listItem.subSections.items[index]);
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
