import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/domain/entities/billing_response.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/source_selector.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/step_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/type_selector.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';

import '../../../../../../resources/colors.dart';
import '../../../../../../resources/strings.dart';
import '../../../../../../resources/values.dart';
import '../../../../../menu/domain/entities/brand.dart';
import '../../../../../widgets/snackbars.dart';
import '../../../../domain/entities/order_source.dart';
import '../dialogs/delete_item_dialog.dart';
import '../dialogs/fee_dialogs.dart';
import '../dialogs/promo_and_discount_modal.dart';
import 'cart_app_bar.dart';
import 'cart_items_list.dart';
import 'empty_cart_view.dart';
import 'order_action_button.dart';

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
  final _textController = TextEditingController();
  final _calculateBillNotifier = ValueNotifier<CartBill?>(null);
  CartBill? _cartBill;
  int _currentDiscountType = DiscountType.flat;
  int _currentOrderType = OrderType.DINE_IN;
  int _currentSource = OrderSource.IN_STORE;
  num _globalDiscount = 0;
  num _globalAdditionalFee = 0;
  num _globalDeliveryFee = 0;

  @override
  void initState() {
    final editData = CartManager().getEditInfo();
    if (editData != null) {
      _currentDiscountType = editData.discountType;
      _globalDiscount = editData.discountValue;
      _currentOrderType = editData.type;
      _currentSource = editData.source;
      _globalAdditionalFee = editData.additionalFee;
      _globalDeliveryFee = editData.deliveryFee;
      _textController.text = editData.comment;
    }
    _calculateBill();
    super.initState();
  }

  @override
  void dispose() {
    //_calculateBillNotifier.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _saveCurrentEditInfo() {
    final editInfo = CartInfo(
      type: _currentOrderType,
      source: _currentSource,
      discountType: _currentDiscountType,
      discountValue: _globalDiscount,
      additionalFee: _globalAdditionalFee,
      deliveryFee: _globalDeliveryFee,
      comment: _textController.text,
    );
    CartManager().setEditInfo(editInfo);
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
            itemBill: _cartBill!.items
                .firstWhere((element) => element.id == item.item.id),
            onDelete: () {
              CartManager().removeFromCart(item);
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

  void _showGlobalFeeDialog({
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
            initValue: value,
            feeType: feeType,
            onSave: (value, feeType) {
              if (feeType == FeeType.additional) {
                _globalAdditionalFee = value;
              } else {
                _globalDeliveryFee = value;
              }
              _calculateBill();
            },
            subTotal: _cartBill!.subTotal,
          ),
        );
      },
    );
  }

  void _onCheckout() {
    final checkoutData = CheckoutData(
      items: CartManager().items(),
      type: _currentOrderType,
      source: _currentSource,
      cartBill: _cartBill!,
      discountType: _currentDiscountType,
      discountValue: _globalDiscount,
      instruction: _textController.text,
    );
    _saveCurrentEditInfo();
    widget.onCheckout(checkoutData);
  }

  void _addDiscount({
    required bool isItemDiscount,
    AddToCartItem? cartItem,
    int? discountType,
    num? discountValue,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            margin: EdgeInsets.only(top: ScreenSizes.statusBarHeight),
            color: AppColors.grey,
            child: OrderDiscountModalView(
              promoInfo: isItemDiscount
                  ? cartItem!.promoInfo
                  : CartManager().getPromoInfo(),
              initialDiscountType:
                  isItemDiscount ? cartItem!.discountType : discountType!,
              initialDiscountVale:
                  isItemDiscount ? cartItem!.discountValue : discountValue!,
              brands: isItemDiscount
                  ? [cartItem!.brand.id]
                  : CartManager().availableBrands(),
              subtotal: _cartBill!.subTotal,
              isItemDiscount: isItemDiscount,
              itemQuantity: isItemDiscount
                  ? cartItem!.quantity
                  : CartManager().totalItemQuantity(),
              willShowPromo: isItemDiscount
                  ? _cartBill!.orderPromoDiscount <= 0
                  : _cartBill!.itemPromoDiscount <= 0,
              orderType: _currentOrderType,
              onApply: (discountType, discountValue, promoInfo) {
                if (isItemDiscount) {
                  CartManager().addDiscount(
                    itemId: cartItem!.item.id,
                    type: discountType,
                    value: discountValue,
                  );
                  CartManager().addPromoToItem(cartItem.item.id, promoInfo);
                } else {
                  _currentDiscountType = discountType;
                  _globalDiscount = discountValue;
                  CartManager().setPromoInfo(promoInfo);
                }
                _calculateBill();
              },
            ),
          ),
        );
      },
    );
  }

  void _calculateBill() async {
    final payload = await CartManager().calculateBillingRequestPaylod(
      orderType: _currentOrderType,
      discountType: _currentDiscountType,
      discountValue: _globalDiscount,
      additionalFee: _globalAdditionalFee,
      deliveryFee: _globalDeliveryFee,
    );
    if (payload == null) return;
    EasyLoading.show();
    final response =
        await getIt.get<AddOrderRepository>().calculateBill(model: payload);
    EasyLoading.dismiss();
    response.fold(
      (failure) {
        if (_cartBill != null) {
          CartManager().syncPromoWithCalculateBill(_cartBill!);
        }
        showErrorSnackBar(context, failure.message);
      },
      (bill) {
        _cartBill = bill;
        CartManager().syncPromoWithCalculateBill(_cartBill!);
        _saveCurrentEditInfo();
        _calculateBillNotifier.value = bill;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.grey,
      child: Column(
        children: [
          CartAppBar(
            onClose: () {
              widget.onClose();
            },
          ),
          Expanded(
            child: ValueListenableBuilder<int>(
              valueListenable: CartManager().getNotifyListener(),
              builder: (_, value, __) {
                if (value > 0) {
                  return ValueListenableBuilder<CartBill?>(
                    valueListenable: _calculateBillNotifier,
                    builder: (_, cartBill, __) {
                      if (cartBill != null) {
                        return _body();
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

  Widget _body() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: AppSize.s10.rw,
            vertical: AppSize.s8.rh,
          ),
          child: const StepView(stepPosition: StepPosition.cart),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<List<AddOrderSourceType>>(
                  future: getIt.get<AddOrderRepository>().fetchSources(),
                  builder: (_, snap) {
                    if (snap.hasData && snap.data != null) {
                      return SourceSelector(
                        sources: snap.data!,
                        initialSource: _currentSource,
                        onChangeSource: (source) {
                          _currentSource = source.id;
                          _saveCurrentEditInfo();
                        },
                      );
                    }
                    return const SizedBox();
                  },
                ),
                TypeSelector(
                  initialType: _currentOrderType,
                  onTypeChange: (type) {
                    _currentOrderType = type;
                    CartManager().removePromoForOrderType(_currentOrderType);
                    _calculateBill();
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
                  addDiscount: (item) {
                    _addDiscount(isItemDiscount: true, cartItem: item);
                  },
                  onDelete: _remove,
                  onQuantityChanged: _quantityChanged,
                  removeAll: _removeAll,
                  onDeliveryFee: () {
                    _showGlobalFeeDialog(
                      value: _cartBill!.deliveryFee,
                      feeType: FeeType.delivery,
                    );
                  },
                  onDiscount: () {
                    _addDiscount(
                      isItemDiscount: false,
                      discountType: _currentDiscountType,
                      discountValue: _cartBill!.manualDiscount,
                    );
                  },
                  onAdditionalFee: () {
                    _showGlobalFeeDialog(
                      value: _cartBill!.additionalFee,
                      feeType: FeeType.additional,
                    );
                  },
                  textController: _textController,
                ),
              ],
            ),
          ),
        ),
        OrderActionButton(
          buttonText: AppStrings.procees_to_checkout.tr(),
          enable: true,
          loading: false,
          totalPrice: _cartBill!.totalPrice,
          onProceed: _onCheckout,
        ),
      ],
    );
  }
}
