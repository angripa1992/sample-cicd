import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/widgets/progress_indicator/circular_progress.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/presentation/cubit/fetch_menu_items_cubit.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/non_modifier_item_details.dart';
import 'package:klikit/modules/add_order/utils/modifier_manager.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/modules/menu/domain/entities/menu/menu_item.dart';

import '../../../../core/utils/response_state.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/strings.dart';
import '../../../menu/domain/entities/menu/menu_categories.dart';
import '../../../widgets/snackbars.dart';
import '../../domain/entities/modifier/item_modifier_group.dart';
import '../../utils/cart_manager.dart';
import 'components/add_order_app_bar.dart';
import 'components/cart/cart_screen.dart';
import 'components/empty_brand_view.dart';
import 'components/go_to_cart_button.dart';
import 'components/menu_items_list_view.dart';
import 'components/modifier/add_modifier_view.dart';
import 'components/modifier/edit_modifier.dart';

class AddOrderBody extends StatefulWidget {
  final VoidCallback onBack;

  const AddOrderBody({
    Key? key,
    required this.onBack,
  }) : super(key: key);

  @override
  State<AddOrderBody> createState() => _AddOrderBodyState();
}

class _AddOrderBodyState extends State<AddOrderBody> {
  final _changeBrandNotifier = ValueNotifier<Brand?>(null);
  Brand? _selectedBrand;

  @override
  void initState() {
    if (CartManager().items.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _gotoCart();
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ValueListenableBuilder<Brand?>(
          valueListenable: _changeBrandNotifier,
          builder: (_, initialBrand, __) {
            return AddOrderAppBar(
              onBack: widget.onBack,
              onCartTap: _gotoCart,
              initialBrand: initialBrand,
              onChanged: (brand) {
                _selectedBrand = brand;
                _fetchMenus(brand);
              },
            );
          },
        ),
        Divider(color: AppColors.grey, thickness: 4.rh),
        Expanded(
          child: BlocBuilder<FetchAddOrderMenuItemsCubit, ResponseState>(
            builder: (context, state) {
              if (state is Loading) {
                return const Center(child: CircularProgress());
              } else if (state is Success<List<MenuCategory>>) {
                EasyLoading.dismiss();
                if (state.data.isEmpty) {
                  return Center(
                    child: Text(AppStrings.no_item_found.tr()),
                  );
                }
                return MenuCategoryItemsListView(
                  categories: state.data,
                  brand: _selectedBrand,
                  onCartTap: _gotoCart,
                  onNavigateItemDetails: _navigateToItemDetails,
                  onNavigateAddModifier: (groups, item, brand) {
                    _addModifier(groups: groups, item: item, brand: brand);
                  },
                  refreshMenu: () {
                    _fetchMenus(_selectedBrand);
                  },
                  onAddNonModifierItem: (item, brand) {
                    _addNonModifierItem(
                      item: item,
                      brand: brand,
                      quantity: 1,
                      instruction: EMPTY,
                    );
                  },
                );
              }
              return const EmptyBrandView();
            },
          ),
        ),
        Container(
          color: AppColors.greyLight,
          child: GoToCartButton(
            onGotoCart: _gotoCart,
          ),
        ),
      ],
    );
  }

  void _gotoCart() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return CartScreen(
            onEdit: _navigateToEditModifier,
            addMore: (brand) {
              _changeBrandNotifier.value = brand;
            },
          );
        },
      ),
    );
  }

  void _addToCart(AddToCartItem? item) {
    if (item != null) {
      CartManager().addToCart(item);
      showSuccessSnackBar(null, AppStrings.successfully_added_to_cart.tr());
    }
  }

  void _editCart(AddToCartItem? newItem, AddToCartItem oldItem) async {
    if (newItem != null) {
      await CartManager().editItem(newItem: newItem, oldItem: oldItem);
    }
    _gotoCart();
  }

  void _navigateToEditModifier(AddToCartItem item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => EditModifierView(
          cartItem: item.copy(),
          onClose: (cartItem) {
            _editCart(cartItem, item);
          },
          onCartTap: () {
            _gotoCart();
          },
          onAddAsNew: () {
            _addAsNew(item);
          },
        ),
      ),
    );
  }

  void _addAsNew(AddToCartItem cartItem) async {
    final copiedItem = cartItem.copy();
    await ModifierManager().clearModifier(copiedItem.modifiers);
    _addModifier(
      groups: copiedItem.modifiers,
      item: cartItem.item,
      brand: cartItem.brand,
    );
  }

  void _addModifier({
    required List<MenuItemModifierGroup> groups,
    required MenuCategoryItem item,
    required Brand brand,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => AddModifierView(
          groups: groups,
          item: item,
          brand: brand,
          onClose: _addToCart,
          onCartTap: _gotoCart,
        ),
      ),
    );
  }

  void _addNonModifierItem({
    required MenuCategoryItem item,
    required Brand brand,
    required int quantity,
    required String instruction,
  }) {
    _addToCart(
      AddToCartItem(
        modifiers: [],
        item: item,
        quantity: quantity,
        itemInstruction: instruction,
        modifiersPrice: 0,
        itemPrice: item.klikitPrice(),
        brand: brand,
        discountType: DiscountType.flat,
        discountValue: 0,
      ),
    );
  }

  void _navigateToItemDetails(MenuCategoryItem item, Brand brand) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NonModifierItemDetails(
          menuCategoryItem: item,
          addToCart: (quantity, instruction) {
            _addNonModifierItem(
              item: item,
              brand: brand,
              quantity: quantity,
              instruction: instruction,
            );
          },
          gotoCart: _gotoCart,
        ),
      ),
    );
  }

  void _fetchMenus(Brand? brand) {
    if (brand == null) return;
    context.read<FetchAddOrderMenuItemsCubit>().fetchSubsection(brand);
  }
}
