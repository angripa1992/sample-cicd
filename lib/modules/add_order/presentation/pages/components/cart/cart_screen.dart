import 'package:dartz/dartz.dart' as dartz;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/enums.dart';
import 'package:klikit/app/session_manager.dart';
import 'package:klikit/app/size_config.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/add_order/data/models/placed_order_response.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/add_order/domain/entities/cart_bill.dart';
import 'package:klikit/modules/add_order/domain/entities/order_source.dart';
import 'package:klikit/modules/add_order/domain/repository/add_order_repository.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/cart_items_list.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/cart_price_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/customer_info.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/empty_cart_view.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/place_order_button.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/cart/source_selector.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/dialogs/delete_item_dialog.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/dialogs/fee_dialogs.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/dialogs/promo_and_discount_modal.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/modifier/speacial_instruction.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/order_type_selector.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/payment_method_selector.dart';
import 'package:klikit/modules/add_order/presentation/pages/components/qris/qris_payment_page.dart';
import 'package:klikit/modules/add_order/utils/cart_manager.dart';
import 'package:klikit/modules/add_order/utils/order_entity_provider.dart';
import 'package:klikit/modules/add_order/utils/webshop_entity_provider.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/common/entities/branch.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/modules/common/entities/payment_info.dart';
import 'package:klikit/modules/widgets/snackbars.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/strings.dart';
import 'package:klikit/resources/values.dart';

class CartScreen extends StatefulWidget {
  final Function(AddToCartItem) onEdit;
  final Function(Brand) addMore;

  const CartScreen({
    Key? key,
    required this.onEdit,
    required this.addMore,
  }) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _textController = TextEditingController();
  final _calculateBillNotifier = ValueNotifier<CartBill?>(null);
  late ValueNotifier<int?> _paymentChanelNotifier;
  CartBill? _cartBill;
  int _currentDiscountType = DiscountType.flat;
  int _currentOrderType = OrderType.DINE_IN;
  int _currentSource = OrderSourceID.IN_STORE;
  num _globalDiscount = 0;
  num _globalAdditionalFee = 0;
  num _globalDeliveryFee = 0;
  int? _paymentMethod;
  int? _paymentChannel;
  CustomerInfo? _customerInfo;

  @override
  void initState() {
    final editData = CartManager().cartFee;
    if (editData != null) {
      _currentDiscountType = editData.discountType;
      _globalDiscount = editData.discountValue;
      _globalAdditionalFee = editData.additionalFee;
      _globalDeliveryFee = editData.deliveryFee;
    }
    _currentOrderType = CartManager().orderType;
    _currentSource = CartManager().orderSource;
    _textController.text = CartManager().orderComment;
    final paymentInfo = CartManager().paymentInfo;
    if (paymentInfo != null) {
      _paymentMethod = paymentInfo.paymentMethod;
      _paymentChannel = paymentInfo.paymentChannel;
    }
    _customerInfo = CartManager().customerInfo;
    _paymentChanelNotifier = ValueNotifier(_paymentChannel);
    _calculateBill();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.cart.tr())),
      backgroundColor: AppColors.white,
      body: ValueListenableBuilder<int>(
        valueListenable: CartManager().cartItemNotifier,
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
    );
  }

  Widget _body() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                if (!CartManager().isWebShopOrder) _orderTypeSelectorView(),
                if (!CartManager().willUpdateOrder) _orderSourceSelectorView(),
                CartItemsListView(
                  cartBill: _cartBill!,
                  onEdit: (item) {
                    Navigator.pop(context);
                    widget.onEdit(item);
                  },
                  addMore: (brand) {
                    Navigator.pop(context);
                    widget.addMore(brand);
                  },
                  addDiscount: (item) {
                    _addDiscount(isItemDiscount: true, cartItem: item);
                  },
                  onDelete: _remove,
                  onQuantityChanged: _quantityChanged,
                  removeAll: _removeAll,
                ),
                Divider(color: AppColors.grey, thickness: 8.rh),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 8.rh),
                  child: SpecialInstructionField(controller: _textController),
                ),
                Divider(color: AppColors.grey, thickness: 8.rh),
                if (!CartManager().isWebShopOrder) _customerInfoView(),
                if (!CartManager().willUpdateOrder) _paymentMethodSelectorView(),
                _cartPriceView(),
              ],
            ),
          ),
        ),
       FutureBuilder<Branch?>(
         future: getIt<BusinessInformationProvider>().branchByID(SessionManager().branchId()),
         builder: (_,snap){
           if(snap.hasData && snap.data != null){
             return  ValueListenableBuilder<int?>(
               valueListenable: _paymentChanelNotifier,
               builder: (_, chanelID, __) {
                 return PlaceOrderButton(
                   channelID: chanelID,
                   branch: snap.data!,
                   totalPrice: _cartBill!.totalPrice,
                   isWebShopOrder: CartManager().isWebShopOrder,
                   willUpdateOrder: CartManager().willUpdateOrder,
                   onPayNow: () => _placeOrder(CheckoutState.PAY_NOW),
                   onPlaceOrder: () => _placeOrder(CheckoutState.PLACE_ORDER),
                   onUpdateWebshopOrder: () => _updateWebShopOrder(),
                   onUpdateOrder: () => _placeOrder(CheckoutState.PLACE_ORDER),
                 );
               },
             );
           }
           return const SizedBox();
         },
       ),
      ],
    );
  }

  Widget _orderSourceSelectorView() {
    return Column(
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
                  CartManager().orderSource = _currentSource;
                },
              );
            }
            return const SizedBox();
          },
        ),
        Divider(color: AppColors.grey, thickness: 8.rh),
      ],
    );
  }

  Widget _orderTypeSelectorView() {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.rw, vertical: 8.rh),
          child: OrderTypeSelector(
            initialType: _currentOrderType,
            onTypeChange: (type) {
              _currentOrderType = type;
              CartManager().removePromoForOrderType(_currentOrderType);
              CartManager().clearCart();
              CartManager().orderType = _currentOrderType;
            },
          ),
        ),
        Divider(color: AppColors.grey, thickness: 8.rh),
      ],
    );
  }

  Widget _customerInfoView() {
    return Column(
      children: [
        CustomerInfoView(
          initInfo: _customerInfo,
          onCustomerInfoSave: (customerInfoData) {
            _customerInfo = customerInfoData;
          },
        ),
        Divider(color: AppColors.grey, thickness: 8.rh),
      ],
    );
  }

  Widget _paymentMethodSelectorView() {
    return FutureBuilder<List<PaymentMethod>>(
      future: getIt<BusinessInformationProvider>().fetchPaymentMethods(),
      builder: (_, snap) {
        if (snap.hasData && snap.data != null) {
          return Column(
            children: [
              PaymentMethodSelector(
                methods: snap.data!,
                initMethod: _paymentMethod,
                initChannel: _paymentChannel,
                onChanged: (paymentMethod, paymentChannel) {
                  _paymentMethod = paymentMethod;
                  _paymentChannel = paymentChannel;
                  _paymentChanelNotifier.value = _paymentChannel;
                },
              ),
              Divider(color: AppColors.grey, thickness: 8.rh),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  Widget _cartPriceView() {
    return Column(
      children: [
        CartPriceView(
          cartBill: _cartBill!,
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
          onApplyRoundOff: (roundOffApplicable) {
            CartManager().setRoundOffApplicable = roundOffApplicable;
            _calculateBill();
          },
        ),
        Divider(color: AppColors.grey, thickness: 8.rh),
      ],
    );
  }

  @override
  void dispose() {
    //_calculateBillNotifier.dispose();
    _paymentChanelNotifier.dispose();
    _textController.dispose();
    super.dispose();
  }

  void _saveCurrentEditInfo() {
    final cartInfo = CartFee(
      discountType: _currentDiscountType,
      discountValue: _globalDiscount,
      additionalFee: _globalAdditionalFee,
      deliveryFee: _globalDeliveryFee,
    );
    CartManager().orderType = _currentOrderType;
    CartManager().orderSource = _currentSource;
    CartManager().orderComment = _textController.text;
    CartManager().setCartFee = cartInfo;
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
              CartManager().removeAllByBrand(brandId);
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
            itemBill: _cartBill!.items.firstWhere((element) => element.id == item.item.id),
            onDelete: () async {
              await CartManager().removeFromCart(item);
              _calculateBill();
            },
          ),
        );
      },
    );
  }

  void _quantityChanged(AddToCartItem item, int quantity) async {
    await CartManager().changeQuantity(item, quantity);
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
              promoInfo: isItemDiscount ? cartItem!.promoInfo : CartManager().promoInfo,
              initialDiscountType: isItemDiscount ? cartItem!.discountType : discountType!,
              initialDiscountVale: isItemDiscount ? cartItem!.discountValue : discountValue!,
              brands: isItemDiscount ? [cartItem!.brand.id] : CartManager().availableBrands(),
              subtotal: _cartBill!.subTotal,
              isItemDiscount: isItemDiscount,
              itemQuantity: isItemDiscount ? cartItem!.quantity : CartManager().totalItemQuantity(),
              willShowPromo: isItemDiscount ? _cartBill!.orderPromoDiscount <= 0 : _cartBill!.itemPromoDiscount <= 0,
              orderType: _currentOrderType,
              onApply: (discountType, discountValue, promoInfo) async {
                if (isItemDiscount) {
                  await CartManager().addDiscount(cartItem: cartItem!, type: discountType, value: discountValue);
                  await CartManager().addPromoToItem(cartItem, promoInfo);
                } else {
                  _currentDiscountType = discountType;
                  _globalDiscount = discountValue;
                  CartManager().setPromoInfo = promoInfo;
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
    final items = CartManager().items;
    if (items.isEmpty) return null;
    EasyLoading.show();
    dartz.Either<Failure, CartBill>? response;
    if (CartManager().isWebShopOrder) {
      final payload = await WebShopEntityProvider().calculateBillPayload(
        cartItems: items,
        deliveryFee: _globalDeliveryFee,
      );
      response = await getIt.get<AddOrderRepository>().webShopCalculateBill(payload: payload);
    } else {
      final payload = await OrderEntityProvider().billingRequestModel(
        orderType: _currentOrderType,
        discountType: _currentDiscountType,
        discountValue: _globalDiscount,
        additionalFee: _globalAdditionalFee,
        deliveryFee: _globalDeliveryFee,
        cartItems: items,
      );
      response = await getIt.get<AddOrderRepository>().calculateBill(model: payload);
    }
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

  void _updateWebShopOrder() async {
    _saveCurrentEditInfo();
    final cartInfo = CartManager().updateCartInfo;
    if (_cartBill == null || cartInfo == null) return;
    EasyLoading.show();
    final payload = await WebShopEntityProvider().placeOrderPayload(_cartBill!);
    final response = await getIt.get<AddOrderRepository>().updateWebShopOrder(cartInfo.orderID, payload);
    EasyLoading.dismiss();
    response.fold(
      (failure) {
        showApiErrorSnackBar(context, failure);
      },
      (response) {
        showSuccessSnackBar(context, response.message ?? '');
        CartManager().clearAndNavigateToOrderScreen(context);
      },
    );
  }

  void _placeOrder(CheckoutState checkoutState) async {
    if (checkoutState == CheckoutState.PAY_NOW && (_paymentMethod == null || _paymentChannel == null)) {
      showErrorSnackBar(context, 'Please select payment method');
      return;
    }
    EasyLoading.show();
    final checkoutData = CheckoutData(
      items: CartManager().items,
      type: _currentOrderType,
      source: _currentSource,
      cartBill: _cartBill!,
      discountType: _currentDiscountType,
      discountValue: _globalDiscount,
      instruction: _textController.text,
    );
    final body = await OrderEntityProvider().placeOrderRequestData(
      checkoutData: checkoutData,
      paymentStatus: _paymentStatus(checkoutState),
      paymentMethod: _paymentMethod,
      paymentChannel: _paymentChannel,
      info: _customerInfo,
    );
    final response = await getIt.get<AddOrderRepository>().placeOrder(body: body);
    EasyLoading.dismiss();
    response.fold(
      (failure) => showApiErrorSnackBar(context, failure),
      (successResponse) => _handlePlacedOrderResponse(checkoutState, successResponse),
    );
  }

  int _paymentStatus(CheckoutState checkoutState) {
    late int paymentStatus;
    if (CartManager().willUpdateOrder) {
      paymentStatus = CartManager().paymentInfo?.paymentStatus ?? PaymentStatusId.pending;
    } else if (checkoutState == CheckoutState.PAY_NOW) {
      paymentStatus = PaymentStatusId.paid;
    } else {
      paymentStatus = PaymentStatusId.pending;
    }
    return paymentStatus;
  }

  void _handlePlacedOrderResponse(CheckoutState checkoutState, PlacedOrderResponse response) {
    if (checkoutState == CheckoutState.PAY_NOW && response.checkoutLink != null) {
      _payThroughQrisNow(response);
      return;
    }
    showSuccessSnackBar(context, response.message ?? '');
    if (CartManager().willUpdateOrder) {
      CartManager().clearAndNavigateToOrderScreen(context);
    } else {
      CartManager().clearAndNavigateToAddOrderScreen(context);
    }
  }

  void _payThroughQrisNow(PlacedOrderResponse response) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => QrisPaymentPage(
        paymentLink: response.checkoutLink!,
        orderID: response.orderId!,
        paymentState: PaymentState.PRE_PAYMENT,
      ),
    ));
  }
}
