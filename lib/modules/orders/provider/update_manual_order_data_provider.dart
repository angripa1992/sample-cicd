import 'package:collection/collection.dart';
import 'package:dio/dio.dart';
import 'package:klikit/modules/menu/domain/usecase/fetch_menus.dart';

import '../../../app/constants.dart';
import '../../../app/extensions.dart';
import '../../../app/session_manager.dart';
import '../../add_order/data/datasource/add_order_datasource.dart';
import '../../add_order/data/mapper/v1_modifier_to_modifier.dart';
import '../../add_order/data/models/applied_promo.dart';
import '../../add_order/domain/entities/add_to_cart_item.dart';
import '../../add_order/domain/entities/modifier/item_modifier_group.dart';
import '../../add_order/utils/cart_manager.dart';
import '../../add_order/utils/modifier_manager.dart';
import '../../menu/data/datasource/menu_remote_datasource.dart';
import '../../menu/domain/entities/brand.dart';
import '../../menu/domain/entities/menu/menu_item.dart';
import '../data/models/order_applied_promo.dart';
import '../domain/entities/cart.dart';
import '../domain/entities/order.dart';
import '../domain/repository/orders_repository.dart';

class UpdateManualOrderDataProvider {
  final MenuRemoteDatasource _menuRemoteDatasource;
  final AddOrderDatasource _addOrderDatasource;
  final OrderRepository _orderRepository;

  UpdateManualOrderDataProvider(
    this._menuRemoteDatasource,
    this._addOrderDatasource,
    this._orderRepository,
  );

  Future<void> generateCartData(Order manualOrder) async {
    final order = await _orderRepository.fetchOrderById(manualOrder.id);
    final promos = await _fetchPromos(order!);
    final cartItems = await _generateCartItem(order, promos);
    CartManager().clear();
    for (var cartItem in cartItems) {
      await CartManager().addToCart(cartItem);
    }
    final promoInfo = _promoInfo(
      promos: promos,
      orderPromo: order.orderAppliedPromo,
      itemPromos: [],
      isItemPromo: false,
      itemId: 0,
    );
    CartManager().setPromoInfo(promoInfo);
    _setEditableInfo(order);
  }

  Future<List<AddToCartItem>> _generateCartItem(
      Order order, List<AppliedPromo> promos) async {
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
          providerId: order.providerId,
        );
        if (menuItemOrNull != null) {
          final modifiersPrice =
              await ModifierManager().calculateModifiersPrice(modifierGroups);
          final itemPrice = menuItemOrNull.klikitPrice();
          final cartV1Item = order.cartV1
              .firstWhere((element) => element.itemId.toString() == cartv2.id);
          final promoInfo = _promoInfo(
            promos: promos,
            orderPromo: null,
            itemPromos: order.itemAppliedPromos,
            isItemPromo: true,
            itemId: cartV1Item.itemId,
          );
          final cartItem = AddToCartItem(
            modifiers: modifierGroups,
            item: menuItemOrNull,
            quantity: cartv2.quantity,
            itemInstruction: cartv2.comment,
            modifiersPrice: modifiersPrice,
            itemPrice: itemPrice,
            brand: brand,
            promoInfo: promoInfo,
            discountType: cartV1Item.discountType == 0
                ? DiscountType.flat
                : cartV1Item.discountType,
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

  PromoInfo? _promoInfo({
    required List<AppliedPromo> promos,
    required OrderAppliedPromo? orderPromo,
    required List<OrderAppliedPromo> itemPromos,
    required bool isItemPromo,
    required int itemId,
  }) {
    try {
      if (isItemPromo) {
        if (itemPromos.isEmpty) return null;
        final itemPromo =
            itemPromos.firstWhere((element) => element.itemId == itemId);
        final promo =
            promos.firstWhere((element) => itemPromo.promoId == element.id);
        return _promoInfoFromAppliedPromo(
            appliedPromo: itemPromo, promo: promo, isItemPromo: true);
      } else {
        if (orderPromo == null) return null;
        final promo =
            promos.firstWhere((element) => orderPromo.promoId == element.id);
        return _promoInfoFromAppliedPromo(
            appliedPromo: orderPromo, promo: promo, isItemPromo: false);
      }
    } catch (e) {
      return null;
    }
  }

  PromoInfo _promoInfoFromAppliedPromo({
    required OrderAppliedPromo appliedPromo,
    required AppliedPromo promo,
    required bool isItemPromo,
  }) {
    int? citizen;
    int? customer;
    if (isItemPromo) {
      citizen = appliedPromo.quantityOfScPromoItem;
    } else {
      citizen = appliedPromo.numberOfSeniorCitizen;
      customer = appliedPromo.numberOfCustomer;
    }
    if (!appliedPromo.isSeniorCitizenPromo!) {
      citizen = null;
      customer = null;
    }
    if (citizen != null && citizen <= 0) {
      citizen = null;
    }
    if (customer != null && customer <= 0) {
      customer = null;
    }
    return PromoInfo(promo: promo, citizen: citizen, customer: customer);
  }

  Future<List<AppliedPromo>> _fetchPromos(Order order) async {
    try {
      final user = SessionManager().user();
      final params = {
        'country': user.countryIds.first,
        'business': user.businessId,
        'branch': user.branchId,
        'product_type': 'add_order',
        'order_amount': order.itemPrice / 100,
        'brands': ListParam<int>(
          order.brands.map((e) => e.id).toList(),
          ListFormat.csv,
        ),
      };
      final response = await _addOrderDatasource.fetchPromos(params);
      return response;
    } catch (e) {
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
    } on DioException {
      rethrow;
    }
  }

  Future<MenuCategoryItem?> _fetchMenuItem({
    required String itemId,
    required int brandId,
    required int branchId,
    required int providerId,
  }) async {
    try {
      final menusItemsResponse = await _menuRemoteDatasource.fetchMenus(
        FetchMenuParams(
          businessId: SessionManager().user().businessId,
          branchId: branchId,
          brandId: brandId,
          providerID: providerId,
        ),
      );
      for (var section in menusItemsResponse.sections) {
        for (var category in section.categories) {
          for (var item in category.items) {
            if (item.id.toString() == itemId) {
              return item;
            }
          }
        }
      }
      return null;
    } on DioException {
      rethrow;
    }
  }

  Future<List<AddOrderItemModifierGroup>> _fetchModifiers(CartV2 cartV2) async {
    try {
      final modifierGroupsResponse = await _addOrderDatasource.fetchModifiers(
          itemId: int.parse(cartV2.id));
      final groups = mapAddOrderV1ModifierToModifier(modifierGroupsResponse);
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

  void _setEditableInfo(Order order) {
    final editInfo = CartInfo(
      type: order.type == ZERO ? OrderType.DINE_IN : order.type,
      source: order.source,
      discountType: order.discountTYpe,
      discountValue: order.discountValue,
      additionalFee: order.additionalFee / 100,
      deliveryFee: order.deliveryFee / 100,
      comment: order.orderComment,
    );
    final customerInfo = CustomerInfo(
      firstName: order.userFirstName,
      lastName: order.userLastName,
      email: order.userEmail,
      phone: order.userPhone,
      tableNo: order.tableNo,
    );
    final paymentInfo = PaymentInfo(
      paymentStatus: order.paymentStatus,
      paymentMethod: order.paymentMethod == ZERO
          ? PaymentMethodId.CASH
          : order.paymentMethod,
    );
    final updateCartInfo = UpdateCartInfo(
      id: order.id,
      externalId: order.externalId,
      identity: order.identity,
    );
    CartManager().setCustomerInfo(customerInfo);
    CartManager().setEditInfo(editInfo);
    CartManager().setPaymentInfo(paymentInfo);
    CartManager().setUpdateCartInfo(updateCartInfo);
  }
}
