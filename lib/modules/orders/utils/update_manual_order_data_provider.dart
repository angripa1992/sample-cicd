import 'package:dio/dio.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/modules/common/business_information_provider.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/modules/orders/utils/update_webshop_order_data_provider.dart';

import '../../../app/constants.dart';
import '../../../app/extensions.dart';
import '../../add_order/data/models/applied_promo.dart';
import '../../add_order/domain/entities/add_to_cart_item.dart';
import '../../add_order/utils/cart_manager.dart';
import '../../add_order/utils/modifier_manager.dart';
import '../domain/entities/order.dart';
import '../domain/repository/orders_repository.dart';
import 'applied_promo_provider.dart';
import 'order_menu_item_provider.dart';

class UpdateManualOrderDataProvider {
  final OrderRepository _orderRepository;

  UpdateManualOrderDataProvider(
    this._orderRepository,
  );

  Future<void> generateCartData(Order manualOrder) async {
    try {
      if (manualOrder.providerId == ProviderID.KLIKIT && !manualOrder.isManualOrder) {
        await getIt.get<UpdateWebShopOrderDataProvider>().generateCartData(manualOrder);
        return;
      }
      final order = await _orderRepository.fetchOrderById(manualOrder.id);
      final promos = await AppliedPromoProvider().fetchPromos(
        productType: 'add_order',
        orderAmountInCent: order!.itemPrice,
        brandsID: order.brands.map((e) => e.id).toList(),
      );
      final cartItems = await _generateCartItem(order, promos);
      CartManager().clear();
      for (var cartItem in cartItems) {
        await CartManager().addToCart(cartItem);
      }
      final promoInfo = AppliedPromoProvider().appliedPromoInfo(
        promos: promos,
        orderPromo: order.orderAppliedPromo,
        itemPromos: [],
      );
      CartManager().setPromoInfo(promoInfo);
      _setEditableInfo(order);
    } catch (error) {
      rethrow;
    }
  }

  Future<List<AddToCartItem>> _generateCartItem(Order order, List<Promo> promos) async {
    try {
      List<AddToCartItem> carts = [];
      for (var cartv2 in order.cartV2) {
        final menuItemOrNull = await OrderMenuItemProvider().fetchMenuItem(
          itemId: cartv2.id,
          brandId: cartv2.cartBrand.id,
          branchId: order.branchId,
          providerId: order.providerId,
        );
        if (menuItemOrNull != null) {
          final modifierGroups = await OrderMenuItemProvider().fetchModifiers(cartv2, menuItemOrNull.branchInfo);
          final brand = await _fetchMenuBrand(brandId: cartv2.cartBrand.id);
          final modifiersPrice = await ModifierManager().calculateModifiersPrice(modifierGroups);
          final itemPrice = menuItemOrNull.klikitPrice();
          final cartV1Item = order.cartV1.firstWhere((element) => element.itemId.toString() == cartv2.id);
          final promoInfo = AppliedPromoProvider().appliedPromoInfo(
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
            brand: brand!,
            promoInfo: promoInfo,
            discountType: cartV1Item.discountType == 0 ? DiscountType.flat : cartV1Item.discountType,
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

  Future<Brand?> _fetchMenuBrand({required int brandId}) async {
    try {
      final brand = await getIt.get<BusinessInformationProvider>().findBrandById(brandId);
      return brand;
    } on DioException {
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
      paymentMethod: order.paymentMethod == ZERO ? PaymentMethodID.CASH : order.paymentMethod,
      paymentChannel: order.paymentChannel == ZERO ? PaymentChannelID.CASH : order.paymentChannel,
    );
    final updateCartInfo = UpdateCartInfo(
      id: order.id,
      externalId: order.externalId,
      identity: order.identity,
      isWebShopOrder: false,
      isPrePayment: order.paymentStatus == PaymentStatusId.paid,
      itemPrice: order.itemPrice / 100,
    );
    CartManager().setCustomerInfo(customerInfo);
    CartManager().setEditInfo(editInfo);
    CartManager().setPaymentInfo(paymentInfo);
    CartManager().setUpdateCartInfo(updateCartInfo);
  }
}
