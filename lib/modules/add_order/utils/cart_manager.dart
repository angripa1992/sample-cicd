import 'package:flutter/material.dart';

import '../domain/entities/add_to_cart_item.dart';

class CartManager {
  static final _instance = CartManager._internal();
  static final _carts = <AddToCartItem>[];
  static final ValueNotifier<int> _cartItemNotifier = ValueNotifier<int>(0);

  factory CartManager() => _instance;

  CartManager._internal();

  void addToCart(AddToCartItem item) {
    _carts.add(item);
    _notifyListener();
  }

  void removeFromCart(int itemId) {
    _carts.removeWhere((element) => element.item.id == itemId);
    _notifyListener();
  }

  void _notifyListener() {
    _cartItemNotifier.value = _carts.length;
  }

  ValueNotifier<int> getNotifyListener() => _cartItemNotifier;

  Map<String,dynamic> totalPrice() {
    num totalPrice = 0;
    String symbol = '';
    for (var item in _carts) {
      final price = (item.modifiersPrice + item.itemPrice.price) * item.quantity;
      totalPrice += price;
      symbol = item.itemPrice.symbol;
    }
    return {
      'price': totalPrice,
      'symbol': symbol,
    };
  }

}
