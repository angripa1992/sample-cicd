import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';

import '../data/models/billing_request.dart';
import '../domain/entities/add_to_cart_item.dart';
import 'modifier_manager.dart';
import 'order_entity_provider.dart';

class CartManager {
  static final _instance = CartManager._internal();
  static final _carts = <AddToCartItem>[];
  static final ValueNotifier<int> _cartItemNotifier = ValueNotifier<int>(0);

  factory CartManager() => _instance;

  CartManager._internal();

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
    addToCart(newItem);
  }

  void removeFromCart(AddToCartItem item) {
    _carts.removeWhere(
      (element) =>
          element.item.id == item.item.id && element.quantity == item.quantity,
    );
    _notifyListener();
  }

  void removeAll(int brandId) {
    _carts.removeWhere((element) => element.brand.id == brandId);
    _notifyListener();
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
    final item =
        _carts.firstWhereOrNull((element) => element.item.id == itemId);
    if (item != null) {
      item.quantity = quantity;
    }
  }

  BillingCurrency currency() {
    int id = ZERO;
    String symbol = EMPTY;
    String code = EMPTY;

    if (_carts.isNotEmpty) {
      final price = _carts.first.itemPrice;
      id = price.currencyId;
      symbol = price.symbol;
      code = price.code;
    }
    return BillingCurrency(id: id, symbol: symbol, code: code);
  }

  void _notifyListener() {
    _cartItemNotifier.value = _carts.length;
  }

  ValueNotifier<int> getNotifyListener() => _cartItemNotifier;

  Map<String, dynamic> totalPrice() {
    num totalPrice = 0;
    String symbol = '';
    for (var item in _carts) {
      final price =
          (item.modifiersPrice + item.itemPrice.price) * item.quantity;
      totalPrice += price;
      symbol = item.itemPrice.symbol;
    }
    return {
      'price': totalPrice,
      'symbol': symbol,
    };
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
    final searchedItem = _carts.firstWhereOrNull(
      (element) =>
          element.item.id == cartItem.item.id &&
          element.quantity == cartItem.quantity,
    );
    if (searchedItem != null) {
      final newtUniqueId = await ModifierManager().generateCheckingId(
        groups: cartItem.modifiers,
        item: cartItem.item,
        quantity: cartItem.quantity,
      );
      final existingUniqueId = await ModifierManager().generateCheckingId(
        groups: searchedItem.modifiers,
        item: searchedItem.item,
        quantity: searchedItem.quantity,
      );
      if (newtUniqueId == existingUniqueId) {
        return searchedItem;
      }
    }
    return null;
  }

  Future<BillingRequestModel?> calculateBillingRequestPaylod({
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
      );
    }
    return null;
  }
}
