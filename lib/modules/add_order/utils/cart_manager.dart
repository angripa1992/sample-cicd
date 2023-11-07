import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';

import '../data/models/applied_promo.dart';
import '../data/models/request/billing_request.dart';
import '../domain/entities/add_to_cart_item.dart';
import '../domain/entities/cart_bill.dart';
import '../domain/entities/selected_item_price.dart';
import 'modifier_manager.dart';

class CartManager {
  static final _instance = CartManager._internal();
  static final _carts = <AddToCartItem>[];
  static CartInfo? _cartInfo;
  static CustomerInfo? _customerInfo;
  static PaymentInfo? _paymentInfo;
  static UpdateCartInfo? _updateCartInfo;
  static AppliedPromoInfo? _promoInfo;
  static final _cartItemNotifier = ValueNotifier<int>(0);
  static final _noOfCartItemNotifier = ValueNotifier<int>(0);
  static final _priceNotifier = ValueNotifier<SelectedItemPrice?>(null);

  factory CartManager() => _instance;

  CartManager._internal();

  ValueNotifier<int> getNotifyListener() => _cartItemNotifier;

  ValueNotifier<SelectedItemPrice?> getPriceNotifyListener() => _priceNotifier;

  ValueNotifier<int> cartItemNotifier() => _noOfCartItemNotifier;

  List<AddToCartItem> items() => _carts;

  CustomerInfo? getCustomerInfo() => _customerInfo;

  CartInfo? getEditInfo() => _cartInfo;

  PaymentInfo? getPaymentInfo() => _paymentInfo;

  UpdateCartInfo? getUpdateCartInfo() => _updateCartInfo;

  AppliedPromoInfo? getPromoInfo() => _promoInfo;

  bool isWebShopOrder() => _updateCartInfo?.isWebShopOrder ?? false;

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

  void setPromoInfo(AppliedPromoInfo? data) {
    _promoInfo = data;
  }

  Future<void> addToCart(AddToCartItem cartItem) async {
    final duplicateItem = await _findCartItemByUniqueID(cartItem);
    if (duplicateItem != null) {
      _deleteItemFromCartByUUID(duplicateItem);
      cartItem.quantity += duplicateItem.quantity;
    }
    _carts.add(cartItem);
    _notifyListener();
  }

  Future<void> addDiscount({required AddToCartItem cartItem, required int type, required num value}) async{
    final item = await _findCartItemByUniqueIDAndQuantity(cartItem);
    if (item != null) {
      item.discountValue = value;
      item.discountType = type;
    }
  }

  Future<void> addPromoToItem(AddToCartItem cartItem, AppliedPromoInfo? promoInfo) async {
    final item = await _findCartItemByUniqueIDAndQuantity(cartItem);
    if (item != null) {
      item.promoInfo = promoInfo;
    }
  }

  Future<void> editItem({required AddToCartItem newItem, required AddToCartItem oldItem}) async {
    _deleteItemFromCartByUUIDandQuantity(oldItem);
    addToCart(newItem);
  }

  Future<void> removeFromCart(AddToCartItem item) async {
    _deleteItemFromCartByUUIDandQuantity(item);
    _checkCartAndClearIfNeeded();
  }

  void removeAllByBrand(int brandId) {
    _carts.removeWhere((element) => element.brand.id == brandId);
    _checkCartAndClearIfNeeded();
  }

  Future<void> changeQuantity(AddToCartItem item, int quantity) async {
    final cartItem = await _findCartItemByUniqueIDAndQuantity(item);
    if (cartItem != null) {
      cartItem.quantity = quantity;
      _notifyListener();
    }
  }

  void _deleteItemFromCartByUUIDandQuantity(AddToCartItem item) {
    final removeUniqueID = ModifierManager().generateCheckingId(groups: item.modifiers, item: item.item);
    _carts.removeWhere((element) {
      final uniqueId = ModifierManager().generateCheckingId(groups: element.modifiers, item: element.item);
      return (uniqueId == removeUniqueID) && (item.quantity == element.quantity);
    });
  }

  void _deleteItemFromCartByUUID(AddToCartItem item) {
    final removeUniqueID = ModifierManager().generateCheckingId(groups: item.modifiers, item: item.item);
    _carts.removeWhere((element) {
      final uniqueId = ModifierManager().generateCheckingId(groups: element.modifiers, item: element.item);
      return uniqueId == removeUniqueID;
    });
  }

  Future<AddToCartItem?> _findCartItemByUniqueID(AddToCartItem cartItem) async {
    final itemUniqueId = ModifierManager().generateCheckingId(groups: cartItem.modifiers, item: cartItem.item);
    for (var item in _carts) {
      final uniqueId = ModifierManager().generateCheckingId(groups: item.modifiers, item: item.item);
      if (uniqueId == itemUniqueId) return item;
    }
    return null;
  }

  Future<AddToCartItem?> _findCartItemByUniqueIDAndQuantity(AddToCartItem cartItem) async {
    final itemUniqueId = ModifierManager().generateCheckingId(groups: cartItem.modifiers, item: cartItem.item);
    for (var item in _carts) {
      final uniqueId = ModifierManager().generateCheckingId(groups: item.modifiers, item: item.item);
      if (uniqueId == itemUniqueId && item.quantity == cartItem.quantity) return item;
    }
    return null;
  }

  Future<AddToCartItem?> _findCartItemByIDAndQuantity(int itemID, int quantity) async {
    final item = _carts.firstWhereOrNull((element) => element.item.id == itemID && element.quantity == quantity);
    return item;
  }

  void _checkCartAndClearIfNeeded() {
    if (_carts.isEmpty && !isWebShopOrder()) {
      clear();
    } else {
      _notifyListener();
    }
  }

  int _noOfCartItem() {
    int nofOfItem = 0;
    for (var item in _carts) {
      nofOfItem += item.quantity;
    }
    return nofOfItem;
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

  void _updatePrice() {
    if (_carts.isEmpty) {
      _priceNotifier.value = null;
      _noOfCartItemNotifier.value = 0;
    } else {
      num totalPrice = 0;
      String symbol = EMPTY;
      String code = EMPTY;
      for (var item in _carts) {
        final price = (item.modifiersPrice + item.itemPrice.price) * item.quantity;
        totalPrice += price;
        symbol = item.itemPrice.currencySymbol;
        code = item.itemPrice.currencySymbol;
      }
      final noOfItem = _noOfCartItem();
      _priceNotifier.value = SelectedItemPrice(noOfItem, symbol, totalPrice, code);
      _noOfCartItemNotifier.value = noOfItem;
    }
  }

  List<int> availableBrands() {
    return _carts.map((e) => e.brand.id).toList();
  }

  List<List<AddToCartItem>> cartItemsMapWithBrands() {
    Map<int, List<AddToCartItem>> cartsByBrand = {};
    for (var item in _carts) {
      final index = _carts.indexOf(item);
      final brandId = item.brand.id;
      item.cartIndex = index;
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
  }

  void syncPromoWithCalculateBill(CartBill cartBill) async {
    try{
      for (var element in cartBill.items) {
        final index = cartBill.items.indexOf(element);
        final cartItem = _carts.elementAt(index);
        if (cartItem.item.id == element.id) {
          if (element.appliedPromo != null) {
            final promoInfo = AppliedPromoInfo(
              promo: element.appliedPromo!,
              numberOfSeniorCitizen: element.quantityOfPromoItem > 0 ? element.quantityOfPromoItem : null,
            );
            cartItem.promoInfo = promoInfo;
          } else {
            cartItem.promoInfo = null;
          }
        }
      }
    }catch(e){
      //ignore
    }
    if (cartBill.appliedPromo != null) {
      final promoInfo = AppliedPromoInfo(
        promo: cartBill.appliedPromo!,
        numberOfSeniorCitizen: cartBill.numberOfSeniorCitizen > 0 ? cartBill.numberOfSeniorCitizen : null,
        numberOfCustomer: cartBill.numberOfSeniorCustomer > 0 ? cartBill.numberOfSeniorCustomer : null,
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
