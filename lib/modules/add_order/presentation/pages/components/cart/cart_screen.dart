import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/domain/entities/billing_response.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/step_view.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/styles.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/brand.dart';
import '../../../cubit/calculate_bill_cubit.dart';
import '../dialogs/fee_dialogs.dart';
import 'cart_app_bar.dart';
import 'cart_item.dart';
import 'cart_item_brand.dart';
import 'cart_price_view.dart';

class CartScreen extends StatefulWidget {
  final VoidCallback onClose;
  final Function(AddToCartItem) onEdit;
  final Function(MenuBrand) addMore;

  const CartScreen({
    Key? key,
    required this.onClose,
    required this.onEdit,
    required this.addMore,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    _calculateBill();
    super.initState();
  }

  void _removeAll(int brandId) {
    CartManager().removeAll(brandId);
    _calculateBill();
  }

  void _remove(int itemId) {
    CartManager().removeFromCart(itemId);
    _calculateBill();
  }

  void _addDiscount(int itemId) {
    CartManager().addDiscount(
      itemId: itemId,
      type: 1,
      value: 0,
    );
    _calculateBill();
  }

  void _quantityChanged(int itemId, int quantity) {
    CartManager().changeQuantity(itemId, quantity);
    _calculateBill();
  }

  void _calculateBill() {
    CartManager().calculateBillingRequestPaylod().then((value) {
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
            onSave: (type, value, feeType) {},
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.whiteSmoke,
      child: Column(
        children: [
          CartAppBar(onClose: widget.onClose),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSize.s10.rw,
              vertical: AppSize.s16.rh,
            ),
            child: const StepView(stepPosition: StepPosition.cart),
          ),
          Expanded(
            child: BlocBuilder<CalculateBillCubit, ResponseState>(
              builder: (_, state) {
                if (state is Loading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is Failed) {
                  return Center(child: Text(state.failure.message));
                } else if (state is Success<CartBill>) {
                  final cartsItemByBrands =
                      CartManager().cartItemsMapWithBrands();
                  return SingleChildScrollView(
                    child: Column(
                      children: [
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: cartsItemByBrands.length,
                          itemBuilder: (context, index) {
                            final cartItems = cartsItemByBrands[index];
                            return Container(
                              margin: EdgeInsets.only(
                                left: AppSize.s16.rw,
                                right: AppSize.s16.rw,
                                bottom: AppSize.s8.rw,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(AppSize.s8.rSp),
                                color: AppColors.white,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CartItemBrand(
                                    menuBrand: cartItems.first.brand,
                                    removeAll: _removeAll,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppSize.s12.rw),
                                    child: Column(
                                      children: cartItems.map((cartItem) {
                                        return CartItemView(
                                          cartItem: cartItem,
                                          onEdit: () {
                                            widget.onEdit(cartItem);
                                          },
                                          addDiscount: _addDiscount,
                                          onDelete: _remove,
                                          onQuantityChanged: _quantityChanged,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: AppSize.s12.rw),
                                    child: TextButton(
                                      onPressed: () {
                                        widget.addMore(cartItems.first.brand);
                                      },
                                      child: Text(
                                        '+ Add more items',
                                        style: getMediumTextStyle(
                                          color: AppColors.purpleBlue,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                        ),
                        CartPriceView(
                          cartBill: state.data,
                          onDeliveryFee: () {
                            _showFeeDialog(
                              type: DiscountType.none,
                              value: state.data.deliveryFee,
                              feeType: FeeType.delivery,
                            );
                          },
                          onDiscount: () {
                            _showFeeDialog(
                              type: DiscountType.flat,
                              value: state.data.discountAmount,
                              feeType: FeeType.discount,
                            );
                          },
                          onAdditionalFee: () {
                            _showFeeDialog(
                              type: DiscountType.none,
                              value: state.data.additionalFee,
                              feeType: FeeType.additional,
                            );
                          },
                        ),
                      ],
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
