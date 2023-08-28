import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';

import '../data/models/request/billing_request.dart';
import '../domain/entities/add_to_cart_item.dart';
import '../domain/entities/cart_bill.dart';
import '../domain/entities/selected_item_price.dart';
import 'modifier_manager.dart';
import 'order_entity_provider.dart';

class CartManager {
  static final _instance = CartManager._internal();
  static final _carts = <AddToCartItem>[];
  static CartInfo? _cartInfo;
  static CustomerInfo? _customerInfo;
  static PaymentInfo? _paymentInfo;
  static UpdateCartInfo? _updateCartInfo;
  static PromoInfo? _promoInfo;
  static final _cartItemNotifier = ValueNotifier<int>(0);
  static final _noOfCartItemNotifier = ValueNotifier<int>(0);
  static final _priceNotifier = ValueNotifier<SelectedItemPrice?>(null);

  factory CartManager() => _instance;

  CartManager._internal();

  List<AddToCartItem> items() => _carts;

  Future<void> addToCart(AddToCartItem cartItem) async {
    final duplicateItem = await _findDuplicate(cartItem);
    if (duplicateItem != null) {
      _carts.removeWhere((element) => element.item.id == duplicateItem.item.id);
      cartItem.quantity += duplicateItem.quantity;
    }
    _carts.add(cartItem);
    _notifyListener();
  }

  Future<void> editItem({
    required AddToCartItem newItem,
    required AddToCartItem oldItem,
  }) async {
    _carts.removeWhere((element) =>
        element.item.id == oldItem.item.id &&
        element.quantity == oldItem.quantity);
    await addToCart(newItem);
  }

  AddToCartItem? findCartItem(int itemId) {
    try {
      return _carts.firstWhere((element) => element.item.id == itemId);
    } catch (e) {
      return null;
    }
  }

  void removeFromCart(AddToCartItem item) {
    _carts.removeWhere(
      (element) =>
          element.item.id == item.item.id && element.quantity == item.quantity,
    );
    _checkCartAndClearIfNeeded();
  }

  void removeAll(int brandId) {
    _carts.removeWhere((element) => element.brand.id == brandId);
    _checkCartAndClearIfNeeded();
  }

  void _checkCartAndClearIfNeeded() {
    if (_carts.isEmpty) {
      clear();
    } else {
      _notifyListener();
    }
  }

  void notifyPriceChanged() {
    _notifyListener();
  }

  int _noOfCartItem() {
    int nofOfItem = 0;
    for (var item in _carts) {
      nofOfItem += item.quantity;
    }
    return nofOfItem;
  }

  void addDiscount({
    required int itemId,
    required int type,
    required num value,
  }) {
    final item =
        _carts.firstWhereOrNull((element) => element.item.id == itemId);
    if (item != null) {
      item.discountValue = value;
      item.discountType = type;
    }
  }

  void changeQuantity(int itemId, int quantity) {
    final item = _carts.firstWhereOrNull((element) => element.item.id == itemId);
    if (item != null) {
      item.quantity = quantity;
    }
    _notifyListener();
  }

  BillingCurrency currency() {
    int id = ZERO;
    String symbol = EMPTY;
    String code = EMPTY;

    if (_carts.isNotEmpty) {
      final price = _carts.first.itemPrice;
      id = price.currencyId;
      symbol = price.currencySymbol;
      code = price.currencyCode;
    }
    return BillingCurrency(id: id, symbol: symbol, code: code);
  }

  void _notifyListener() {
    _cartItemNotifier.value = _carts.length;
    _updatePrice();
  }

  ValueNotifier<int> getNotifyListener() => _cartItemNotifier;

  ValueNotifier<SelectedItemPrice?> getPriceNotifyListener() => _priceNotifier;

  ValueNotifier<int> cartItemNotifier() => _noOfCartItemNotifier;

  void _updatePrice() {
    if (_carts.isEmpty) {
      _priceNotifier.value = null;
      _noOfCartItemNotifier.value = 0;
    } else {
      num totalPrice = 0;
      String symbol = EMPTY;
      String code = EMPTY;
      for (var item in _carts) {
        final price =
            (item.modifiersPrice + item.itemPrice.price) * item.quantity;
        totalPrice += price;
        symbol = item.itemPrice.currencySymbol;
        code = item.itemPrice.currencySymbol;
      }
      final noOfItem = _noOfCartItem();
      _priceNotifier.value =
          SelectedItemPrice(noOfItem, symbol, totalPrice, code);
      _noOfCartItemNotifier.value = noOfItem;
    }
  }

  List<int> availableBrands() {
    return _carts.map((e) => e.brand.id).toList();
  }

  List<List<AddToCartItem>> cartItemsMapWithBrands() {
    Map<int, List<AddToCartItem>> cartsByBrand = {};
    for (var item in _carts) {
      final brandId = item.brand.id;
      if (cartsByBrand.containsKey(brandId)) {
        cartsByBrand[brandId]!.add(item);
      } else {
        List<AddToCartItem> carts = [];
        carts.add(item);
        cartsByBrand[brandId] = carts;
      }
    }
    List<List<AddToCartItem>> listOfItemByBrands = [];
    cartsByBrand.forEach((key, value) {
      listOfItemByBrands.add(value);
    });
    return listOfItemByBrands;
  }

  Future<AddToCartItem?> _findDuplicate(AddToCartItem cartItem) async {
    final searchedItem = _carts
        .firstWhereOrNull((element) => element.item.id == cartItem.item.id);
    if (searchedItem != null) {
      final newtUniqueId = await ModifierManager().generateCheckingId(
        groups: cartItem.modifiers,
        item: cartItem.item,
      );
      final existingUniqueId = await ModifierManager().generateCheckingId(
        groups: searchedItem.modifiers,
        item: searchedItem.item,
      );
      if (newtUniqueId == existingUniqueId) {
        return searchedItem;
      }
    }
    return null;
  }

  Future<BillingRequestModel?> calculateBillingRequestPaylod({
    required int orderType,
    required int discountType,
    required num discountValue,
    required num additionalFee,
    required num deliveryFee,
  }) async {
    if (_carts.isNotEmpty) {
      return OrderEntityProvider().billingRequestModel(
        cartItems: _carts,
        discountType: discountType,
        discountValue: discountValue,
        additionalFee: additionalFee,
        deliveryFee: deliveryFee,
        orderType: orderType,
      );
    }
    return null;
  }

  CustomerInfo? getCustomerInfo() => _customerInfo;

  CartInfo? getEditInfo() => _cartInfo;

  PaymentInfo? getPaymentInfo() => _paymentInfo;

  UpdateCartInfo? getUpdateCartInfo() => _updateCartInfo;

  PromoInfo? getPromoInfo() => _promoInfo;

  void setEditInfo(CartInfo info) {
    _cartInfo = info;
  }

  void setCustomerInfo(CustomerInfo data) {
    _customerInfo = data;
  }

  void setPaymentInfo(PaymentInfo data) {
    _paymentInfo = data;
  }

  void setUpdateCartInfo(UpdateCartInfo data) {
    _updateCartInfo = data;
  }

  void setPromoInfo(PromoInfo? data) {
    _promoInfo = data;
  }

  void addPromoToItem(int itemId, PromoInfo? promoInfo) {
    final item =
        _carts.firstWhereOrNull((element) => element.item.id == itemId);
    if (item != null) {
      item.promoInfo = promoInfo;
    }
  }

  int totalItemQuantity() {
    int quantity = 0;
    for (var item in _carts) {
      quantity += item.quantity;
    }
    return quantity;
  }

  bool willShowPromo(bool isItemDiscount) {
    if (isItemDiscount) {
      return _promoInfo == null;
    } else {
      bool flag = true;
      for (var item in _carts) {
        if (item.promoInfo != null) {
          flag = false;
          break;
        }
      }
      return flag;
    }
  }

  void removePromoForOrderType(int orderType) {
    _promoInfo = null;
    for (var item in _carts) {
      item.promoInfo = null;
    }
    // if(orderType != OrderType.DINE_IN){
    //   if(_promoInfo != null && _promoInfo!.promo.isSeniorCitizenPromo!){
    //     _promoInfo?.citizen = null;
    //     _promoInfo?.customer = null;
    //   }
    //   for(var item in _carts){
    //     if(item.promoInfo != null && item.promoInfo!.promo.isSeniorCitizenPromo!){
    //       item.promoInfo?.citizen = null;
    //       item.promoInfo?.customer = null;
    //     }
    //   }
    // }
  }

  void syncPromoWithCalculateBill(CartBill cartBill) {
    for (var element in cartBill.items) {
      final cartItem = findCartItem(element.id.toInt());
      if (cartItem != null) {
        if (element.appliedPromo != null) {
          final promoInfo = PromoInfo(
            promo: element.appliedPromo!,
            citizen: element.quantityOfPromoItem > 0
                ? element.quantityOfPromoItem
                : null,
          );
          cartItem.promoInfo = promoInfo;
        } else {
          cartItem.promoInfo = null;
        }
      }
    }
    if (cartBill.appliedPromo != null) {
      final promoInfo = PromoInfo(
        promo: cartBill.appliedPromo!,
        citizen: cartBill.numberOfSeniorCitizen > 0
            ? cartBill.numberOfSeniorCitizen
            : null,
        customer: cartBill.numberOfSeniorCustomer > 0
            ? cartBill.numberOfSeniorCustomer
            : null,
      );
      setPromoInfo(promoInfo);
    } else {
      setPromoInfo(null);
    }
  }

  void clear() {
    _carts.clear();
    _cartInfo = null;
    _customerInfo = null;
    _paymentInfo = null;
    _updateCartInfo = null;
    _promoInfo = null;
    _notifyListener();
  }
}
