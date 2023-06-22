import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/domain/entities/sub_section_list_item.dart';
import 'package:klikit/modules/add_order/presentation/cubit/fetch_sub_section_cubit.dart';
import 'package:klikit/modules/add_order/utils/modifier_manager.dart';

import '../../../../app/di.dart';
import '../../../../core/utils/response_state.dart';
import '../../../../resources/colors.dart';
import '../../../../resources/strings.dart';
import '../../../menu/domain/entities/brand.dart';
import '../../../menu/domain/entities/items.dart';
import '../../../menu/presentation/cubit/menu_brands_cubit.dart';
import '../../../widgets/snackbars.dart';
import '../../domain/entities/item_modifier_group.dart';
import '../../utils/cart_manager.dart';
import '../cubit/calculate_bill_cubit.dart';
import '../cubit/place_order_cubit.dart';
import 'components/brand_selector_app_bar.dart';
import 'components/cart/cart_screen.dart';
import 'components/checkout/checkout_screen.dart';
import 'components/empty_brand_view.dart';
import 'components/go_to_cart_button.dart';
import 'components/menu_items_list_view.dart';
import 'components/modifier/add_modifier_view.dart';
import 'components/modifier/edit_modifier.dart';

class AddOrderBody extends StatefulWidget {
  final VoidCallback onBack;
  final bool willOpenCart;
  const AddOrderBody({Key? key, required this.onBack, required this.willOpenCart}) : super(key: key);

  @override
  State<AddOrderBody> createState() => _AddOrderBodyState();
}

class _AddOrderBodyState extends State<AddOrderBody> {
  final _changeBrandNotifier = ValueNotifier<MenuBrand?>(null);
  MenuBrand? _selectedBrand;

  @override
  void initState() {
    context.read<MenuBrandsCubit>().fetchMenuBrands();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MenuBrandsCubit, ResponseState>(
      listener: (context,state){
        if(state is Success<List<MenuBrand>> && widget.willOpenCart){
          WidgetsBinding.instance.addPostFrameCallback((_){
            _gotoCart();
          });
        }
      },
      builder: (context, state) {
        if (state is Loading) {
          EasyLoading.show();
        } else if (state is Success<List<MenuBrand>>) {
          EasyLoading.dismiss();
          return _body(state.data);
        } else if(state is Failed) {
          EasyLoading.dismiss();
          return Center(child: Text(state.failure.message));
        }
        return const SizedBox();
      },
    );
  }

  void _gotoCart() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<CalculateBillCubit>(create: (_) => getIt.get()),
          ],
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            extendBody: false,
            body: Container(
              margin: EdgeInsets.only(top: ScreenSizes.statusBarHeight),
              child: CartScreen(
                onClose: () {
                  Navigator.pop(context);
                },
                onEdit: (cartItem) {
                  Navigator.pop(context);
                  _editModifier(cartItem);
                },
                addMore: (brand) {
                  Navigator.pop(context);
                  _changeBrandNotifier.value = brand;
                },
                onCheckout: (checkoutData) {
                  Navigator.pop(context);
                  _checkout(checkoutData);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _checkout(CheckoutData checkoutData) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return BlocProvider<PlaceOrderCubit>(
          create: (_) => getIt.get(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Container(
              margin: EdgeInsets.only(top: ScreenSizes.statusBarHeight),
              child: CheckoutScreen(
                checkoutData: checkoutData,
                onBack: () {
                  Navigator.pop(context);
                  _gotoCart();
                },
                onSuccess: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _addToCart(AddToCartItem? item) {
    if (item != null) {
      CartManager().addToCart(item);
      showSuccessSnackBar(null,AppStrings.successfully_added_to_cart.tr());
    }
  }

  void _editCart(AddToCartItem? newItem, AddToCartItem oldItem) async{
    if (newItem != null) {
      await CartManager().editItem(
        newItem: newItem,
        oldItem: oldItem,
      );
    }
    _gotoCart();
  }

  void _editModifier(AddToCartItem item) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            margin: EdgeInsets.only(top: ScreenSizes.statusBarHeight),
            child: EditModifierView(
              cartItem: item.copy(),
              onClose: (cartItem) {
                Navigator.pop(context);
                _editCart(cartItem, item);
              },
              onCartTap: () {
                Navigator.pop(context);
                _gotoCart();
              },
              onAddAsNew: () {
                Navigator.pop(context);
                _addAsNew(item);
              },
            ),
          ),
        );
      },
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
    required List<ItemModifierGroup> groups,
    required MenuItems item,
    required MenuBrand brand,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            margin: EdgeInsets.only(top: ScreenSizes.statusBarHeight),
            child: AddModifierView(
              groups: groups,
              item: item,
              brand: brand,
              onClose: (cartItem) {
                Navigator.pop(context);
                _addToCart(cartItem);
              },
              onCartTap: () {
                Navigator.pop(context);
                _gotoCart();
              },
            ),
          ),
        );
      },
    );
  }

  Widget _body(List<MenuBrand> brands) {
    return Column(
      children: [
        ValueListenableBuilder<MenuBrand?>(
          valueListenable: _changeBrandNotifier,
          builder: (_, initialBrand, __) {
            return BrandSelectorAppBar(
              brands: brands,
              onChanged: (brand) {
                _selectedBrand = brand;
                context.read<FetchSubSectionCubit>().fetchSubsection(brand);
              },
              onBack: widget.onBack,
              onCartTap: _gotoCart,
              initialBrand: initialBrand,
            );
          },
        ),
        Expanded(
          child: BlocBuilder<FetchSubSectionCubit, ResponseState>(
            builder: (context, state) {
              if (state is Loading) {
                EasyLoading.show();
                return const SizedBox();
              } else if (state is Success<List<SubSectionListItem>>) {
                EasyLoading.dismiss();
                if(state.data.isEmpty){
                  return  Center(
                    child: Text(AppStrings.no_item_found.tr()),
                  );
                }
                return MenuItemsListView(
                  items: state.data,
                  brand: _selectedBrand,
                  onCartTap: _gotoCart,
                  onAddToCart: _addToCart,
                  onAddModifier: (groups, item, brand) {
                    _addModifier(
                      groups: groups,
                      item: item,
                      brand: brand,
                    );
                  },
                );
              }
              EasyLoading.dismiss();
              return const EmptyBrandView();
            },
          ),
        ),
        Container(
          color: AppColors.pearl,
          child: GoToCartButton(
            onGotoCart: _gotoCart,
          ),
        ),
      ],
    );
  }
}
