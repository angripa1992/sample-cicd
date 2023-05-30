import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:klikit/modules/menu/domain/entities/items.dart';

import '../../add_order/data/datasource/add_order_datasource.dart';
import '../../add_order/domain/entities/add_to_cart_item.dart';
import '../../add_order/domain/entities/item_modifier_group.dart';
import '../../add_order/utils/modifier_manager.dart';
import '../../add_order/utils/order_price_provider.dart';
import '../../menu/data/datasource/menu_remote_datasource.dart';
import '../../menu/domain/entities/brand.dart';
import '../domain/entities/cart.dart';
import '../domain/entities/order.dart';

class UpdateManualOrderDataProvider {
  final MenuRemoteDatasource _menuRemoteDatasource;
  final AddOrderDatasource _addOrderDatasource;

  UpdateManualOrderDataProvider(
      this._menuRemoteDatasource, this._addOrderDatasource);

  Future<List<AddToCartItem>> generateCartItem(Order order) async {
    try {
      List<AddToCartItem> carts = [];
      for (var cartv2 in order.cartV2) {
        final modifierGroups = await _fetchModifiers(cartv2);
        final brand = await _fetchMenuBrand(
          brandId: cartv2.cartBrand.id,
          branchId: order.branchId,
        );
        final menuItemOrNull = await _fetchMenuItem(
          itemId: cartv2.id,
          brandId: cartv2.cartBrand.id,
          branchId: order.branchId,
        );
        if (menuItemOrNull != null) {
          final modifiersPrice =
              await ModifierManager().calculateModifiersPrice(modifierGroups);
          final itemPrice =
              OrderPriceProvider.klikitPrice(menuItemOrNull.prices);
          final cartV1Item = order.cartV1
              .firstWhere((element) => element.itemId.toString() == cartv2.id);
          final cartItem = AddToCartItem(
            modifiers: modifierGroups,
            item: menuItemOrNull,
            quantity: cartv2.quantity,
            itemInstruction: '',
            modifiersPrice: modifiersPrice,
            itemPrice: itemPrice,
            brand: brand,
            discountType: cartV1Item.discountType,
            discountValue: cartV1Item.discountValue,
          );
          carts.add(cartItem);
        }
      }
      return carts;
    } on Exception {
      rethrow;
    }
  }

  Future<MenuBrand> _fetchMenuBrand({
    required int brandId,
    required int branchId,
  }) async {
    try {
      final menuBrandResponse = await _menuRemoteDatasource.fetchMenuBrand(
        brandId: brandId,
        branchId: branchId,
      );
      return menuBrandResponse.toEntity();
    } on DioError {
      rethrow;
    }
  }

  Future<MenuItems?> _fetchMenuItem({
    required String itemId,
    required int brandId,
    required int branchId,
  }) async {
    try {
      final menusItemsResponse = await _addOrderDatasource.fetchMenus(
          branchId: branchId, brandId: brandId);
      final sections = menusItemsResponse.toEntity().sections;
      for (var section in sections) {
        for (var subSection in section.subSections) {
          for (var item in subSection.items) {
            if (item.id.toString() == itemId) {
              item.availableTimes = section.availableTimes;
              return item;
            }
          }
        }
      }
      return null;
    } on DioError {
      rethrow;
    }
  }

  Future<List<ItemModifierGroup>> _fetchModifiers(CartV2 cartV2) async {
    try {
      final modifierGroupsResponse = await _addOrderDatasource.fetchModifiers(
          itemId: int.parse(cartV2.id));
      final groups = modifierGroupsResponse.map((e) => e.toEntity()).toList();
      for (var modifierGroupOne in cartV2.modifierGroups) {
        final groupLevelOne = groups.firstWhereOrNull(
            (element) => element.groupId.toString() == modifierGroupOne.id);
        for (var modifierOne in modifierGroupOne.modifiers) {
          final modifierLevelOne = groupLevelOne?.modifiers.firstWhereOrNull(
              (element) => element.modifierId.toString() == modifierOne.id);
          if (modifierLevelOne != null) {
            modifierLevelOne.isSelected = true;
            modifierLevelOne.quantity = modifierOne.quantity;
          }
          for (var modifierGroupTwo in modifierOne.modifierGroups) {
            final groupLevelTwo = modifierLevelOne?.groups.firstWhereOrNull(
                (element) => element.groupId.toString() == modifierGroupTwo.id);
            for (var modifierTwo in modifierGroupTwo.modifiers) {
              final modifierLevelTwo = groupLevelTwo?.modifiers
                  .firstWhereOrNull((element) =>
                      element.modifierId.toString() == modifierTwo.id);
              if (modifierLevelTwo != null) {
                modifierLevelTwo.isSelected = true;
                modifierLevelTwo.quantity = modifierTwo.quantity;
              }
            }
          }
        }
      }
      return groups;
    } on Exception {
      rethrow;
    }
  }
}
