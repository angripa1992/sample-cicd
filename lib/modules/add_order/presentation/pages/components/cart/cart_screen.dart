import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/domain/entities/billing_response.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/proceed_checkout_button.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/source_selector.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/step_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/type_selector.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/brand.dart';
import '../../../../domain/entities/order_source.dart';
import '../../../cubit/calculate_bill_cubit.dart';
import '../../../cubit/fetch_add_order_sources_cubit.dart';
import '../dialogs/delete_item_dialog.dart';
import '../dialogs/fee_dialogs.dart';
import 'cart_app_bar.dart';
import 'cart_items_list.dart';
import 'empty_cart_view.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback onClose;
  final Function(AddToCartItem) onEdit;
  final Function(MenuBrand) addMore;
  final Function(CheckoutData) onCheckout;

  const CartScreen({
    Key? key,
    required this.onClose,
    required this.onEdit,
    required this.addMore,
    required this.onCheckout,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartBill? _cartBill;
  int _currentDiscountType = DiscountType.flat;
  int? _currentOrderType;
  AddOrderSourceType? _currentSourceType;
  AddOrderSource? _currentSource;

  @override
  void initState() {
    context.read<AddOrderSourcesCubit>().fetchSources();
    _calculateBill();
    super.initState();
  }

  void _removeAll(int brandId) {
    showDialog(
      context: context,
      builder: (dContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.s16.rSp),
            ),
          ),
          content: DeleteAllDialogView(
            onDelete: () {
              CartManager().removeAll(brandId);
              _calculateBill();
            },
          ),
        );
      },
    );
  }

  void _remove(AddToCartItem item) {
    showDialog(
      context: context,
      builder: (dContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.s16.rSp),
            ),
          ),
          content: DeleteItemDialogView(
            cartItem: item,
            onDelete: () {
              CartManager().removeFromCart(item);
              _calculateBill();
            },
          ),
        );
      },
    );
  }

  void _addDiscount(AddToCartItem item) {
    showDialog(
      context: context,
      builder: (dContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.s16.rSp),
            ),
          ),
          content: FeeDialogView(
            initType: item.discountType,
            initValue: item.discountValue,
            feeType: FeeType.discount,
            onSave: (type, value, feeType) {
              CartManager()
                  .addDiscount(itemId: item.item.id, type: type, value: value);
              _calculateBill();
            },
          ),
        );
      },
    );
  }

  void _quantityChanged(int itemId, int quantity) {
    CartManager().changeQuantity(itemId, quantity);
    _calculateBill();
  }

  void _calculateBill({
    num? discountValue,
    num? additionalFee,
    num? deliveryFee,
  }) {
    CartManager()
        .calculateBillingRequestPaylod(
      discountType: _currentDiscountType,
      discountValue: discountValue ?? _cartBill?.discountAmount ?? ZERO,
      additionalFee: additionalFee ?? _cartBill?.additionalFee ?? ZERO,
      deliveryFee: deliveryFee ?? _cartBill?.deliveryFee ?? ZERO,
    )
        .then((value) {
      if (value != null) {
        context.read<CalculateBillCubit>().calculateBill(value);
      }
    });
  }

  void _showFeeDialog({
    required int type,
    required num value,
    required FeeType feeType,
  }) {
    showDialog(
      context: context,
      builder: (dContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(AppSize.s16.rSp),
            ),
          ),
          content: FeeDialogView(
            initType: type,
            initValue: value,
            feeType: feeType,
            onSave: (type, value, feeType) {
              if (feeType == FeeType.discount) {
                _currentDiscountType = type;
              }
              _calculateBill(
                discountValue: feeType == FeeType.discount ? value : null,
                additionalFee: feeType == FeeType.additional ? value : null,
                deliveryFee: feeType == FeeType.delivery ? value : null,
              );
            },
          ),
        );
      },
    );
  }

  void _onCheckout() {
    final checkoutData = CheckoutData(
      CartManager().items(),
      _currentSourceType!,
      _currentSource!,
      _cartBill!,
    );
    print('called');
    widget.onCheckout(checkoutData);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteSmoke,
      child: Column(
        children: [
          CartAppBar(onClose: widget.onClose),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: CartManager().getNotifyListener(),
              builder: (_, value, __) {
                if (value > 0) {
                  return BlocBuilder<CalculateBillCubit, ResponseState>(
                    builder: (_, state) {
                      if (state is Loading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is Failed) {
                        return Center(child: Text(state.failure.message));
                      } else if (state is Success<CartBill>) {
                        _cartBill = state.data;
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: AppSize.s10.rw,
                                vertical: AppSize.s16.rh,
                              ),
                              child: const StepView(
                                  stepPosition: StepPosition.cart),
                            ),
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    BlocBuilder<AddOrderSourcesCubit,
                                        ResponseState>(
                                      builder: (_, state) {
                                        if (state is Success<
                                            List<AddOrderSourceType>>) {
                                          return SourceSelector(
                                            sources: state.data,
                                            sourceType: _currentSourceType,
                                            source: _currentSource,
                                            onChangeSource:
                                                (sourceType, source) {
                                              _currentSourceType = sourceType;
                                              _currentSource = source;
                                            },
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                    TypeSelector(
                                      initialType: _currentOrderType ??
                                          OrderType.DINE_IN,
                                      onTypeChange: (type) {
                                        _currentOrderType = type;
                                      },
                                    ),
                                    CartItemsListView(
                                      cartBill: _cartBill!,
                                      onEdit: (item) {
                                        widget.onEdit(item);
                                      },
                                      addMore: (brand) {
                                        widget.addMore(brand);
                                      },
                                      addDiscount: _addDiscount,
                                      onDelete: _remove,
                                      onQuantityChanged: _quantityChanged,
                                      removeAll: _removeAll,
                                      onDeliveryFee: () {
                                        _showFeeDialog(
                                          type: DiscountType.none,
                                          value: _cartBill!.deliveryFee,
                                          feeType: FeeType.delivery,
                                        );
                                      },
                                      onDiscount: () {
                                        _showFeeDialog(
                                          type: DiscountType.flat,
                                          value: _cartBill!.discountAmount,
                                          feeType: FeeType.discount,
                                        );
                                      },
                                      onAdditionalFee: () {
                                        _showFeeDialog(
                                          type: DiscountType.none,
                                          value: _cartBill!.additionalFee,
                                          feeType: FeeType.additional,
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ProceedCheckoutButton(
                              enable: true,
                              totalPrice: _cartBill!.totalPrice,
                              onProceed: _onCheckout,
                            ),
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                } else {
                  return const EmptyCartView();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
