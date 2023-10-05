import 'package:dio/dio.dart';
import 'package:klikit/app/constants.dart';

import '../../../app/di.dart';
import '../../add_order/domain/entities/add_to_cart_item.dart';
import '../../add_order/utils/cart_manager.dart';
import '../../add_order/utils/modifier_manager.dart';
import '../../common/business_information_provider.dart';
import '../../common/entities/brand.dart';
import '../data/models/webshop_order_details_model.dart';
import '../domain/entities/order.dart';
import '../domain/repository/orders_repository.dart';
import 'applied_promo_provider.dart';
import 'order_menu_item_provider.dart';

class UpdateWebShopOrderDataProvider {
  final OrderRepository _orderRepository;

  UpdateWebShopOrderDataProvider(this._orderRepository);

  Future<void> generateCartData(Order manualOrder) async {
    try {
      final webShopOrder = await _orderRepository.fetchOmsOrderById(manualOrder.externalId);
      final cartItems = await _generateCartItem(webShopOrder!);
      CartManager().clear();
      for (var cartItem in cartItems) {
        await CartManager().addToCart(cartItem);
      }
      CartManager().setPromoInfo(AppliedPromoProvider().appliedPromoInfoForWebShopOrder(webShopOrder));
      _setEditableInfo(webShopOrder);
    } catch (error) {
      rethrow;
    }
  }

  Future<List<AddToCartItem>> _generateCartItem(WebShopOrderDetailsModel order) async {
    try {
      List<AddToCartItem> carts = [];
      for (var cart in order.cart ?? <WebShopCartModel>[]) {
        final menuItemOrNull = await OrderMenuItemProvider().fetchMenuItem(
          itemId: cart.itemId!.toString(),
          brandId: cart.brand!.id!,
          branchId: order.branchId!,
          providerId: ProviderID.KLIKIT,
        );
        if (menuItemOrNull != null) {
          final modifierGroups = await OrderMenuItemProvider().fetchModifiersForWebShopOrder(cart, menuItemOrNull.branchInfo);
          final brand = await _fetchMenuBrand(brandId: cart.brand!.id!);
          final modifiersPrice = await ModifierManager().calculateModifiersPrice(modifierGroups);
          final itemPrice = menuItemOrNull.klikitPrice();
          final cartItem = AddToCartItem(
            modifiers: modifierGroups,
            item: menuItemOrNull,
            quantity: cart.quantity!,
            itemInstruction: cart.comment!,
            modifiersPrice: modifiersPrice,
            itemPrice: itemPrice,
            brand: brand!,
            promoInfo: null,
            discountType: cart.discountType ?? DiscountType.flat,
            discountValue: cart.discountValue ?? 0,
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

  void _setEditableInfo(WebShopOrderDetailsModel order) {
    try {
      final editInfo = CartInfo(
        type: order.type ?? 0,
        source: 0,
        discountType: DiscountType.flat,
        discountValue: 0,
        additionalFee: order.additionalFee! / 100,
        deliveryFee: order.deliveryFee! / 100,
        comment: order.orderComment ?? '',
      );
      final customerInfo = CustomerInfo(
        firstName: order.user?.firstName ?? '',
        lastName: order.user?.lastName ?? '',
        email: order.user?.email ?? '',
        phone: order.user?.phone ?? '',
        tableNo: order.tableNo ?? '',
      );
      final paymentInfo = PaymentInfo(
        paymentStatus: order.paymentStatus,
        paymentMethod: order.paymentMethod,
        paymentChannel: order.paymentChannelId,
      );
      final updateCartInfo = UpdateCartInfo(
        id: 0,
        externalId: order.externalId ?? '',
        identity: order.identity ?? '',
        isWebShopOrder: true,
        isPrePayment: order.paymentStatus == PaymentStatusId.paid,
        itemPrice: order.itemPrice! / 100,
      );
      CartManager().setCustomerInfo(customerInfo);
      CartManager().setEditInfo(editInfo);
      CartManager().setPaymentInfo(paymentInfo);
      CartManager().setUpdateCartInfo(updateCartInfo);
    } catch (error) {
      rethrow;
    }
  }
}
