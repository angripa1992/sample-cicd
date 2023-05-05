import 'package:flutter/material.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/sub_section_list_item.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';
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
import '../../../utils/order_price_provider.dart';
import 'dropdown/select_categories_dropdown.dart';
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
  late ItemScrollController _itemScrollController;
  final _addOrderRepository = getIt.get<AddOrderRepository>();

  @override
  void initState() {
    _itemScrollController = ItemScrollController();
    super.initState();
  }

  void _fetchModifier(MenuItems item) async {
    final response = await _addOrderRepository.fetchModifiers(itemId: item.id);
    response.fold(
      (failure) {
        showErrorSnackBar(context, failure.message);
      },
      (data) {
        if (data.isNotEmpty) {
          widget.onAddModifier(data, item, widget.brand!);
        } else {
          widget.onAddToCart(
            AddToCartItem(
              modifiers: [],
              item: item,
              quantity: 1,
              itemInstruction: '',
              modifiersPrice: 0,
              itemPrice: OrderPriceProvider.klikitPrice(item.prices),
              brand: widget.brand!,
              discountType: DiscountType.flat,
              discountValue: 0,
            ),
          );
        }
      },
    );
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
              print('==============$active $index');
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
                          childAspectRatio: 0.62,
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
