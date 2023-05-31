import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/add_order/domain/entities/customer_info.dart';

import '../data/models/billing_request.dart';
import '../domain/entities/add_to_cart_item.dart';
import '../domain/entities/selected_item_price.dart';
import 'modifier_manager.dart';
import 'order_entity_provider.dart';

class CartManager {
  static final _instance = CartManager._internal();
  static final _carts = <AddToCartItem>[];
  static EditableOrderInfo? _editInfo;
  static CustomerInfoData? _customerInfo;
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
    final item =
        _carts.firstWhereOrNull((element) => element.item.id == itemId);
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
      symbol = price.symbol;
      code = price.code;
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
        symbol = item.itemPrice.symbol;
        code = item.itemPrice.code;
      }
      final noOfItem = _noOfCartItem();
      _priceNotifier.value =
          SelectedItemPrice(noOfItem, symbol, totalPrice, code);
      _noOfCartItemNotifier.value = noOfItem;
    }
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

  CustomerInfoData? getCustomerInfo() => _customerInfo;

  EditableOrderInfo? getEditInfo() => _editInfo;

  void setEditInfo(EditableOrderInfo info){
    _editInfo = info;
  }

  void setCustomerInfo(CustomerInfoData data){
    _customerInfo = data;
  }

  void clear() {
    _carts.clear();
    _editInfo = null;
    _customerInfo = null;
    _notifyListener();
  }
}
