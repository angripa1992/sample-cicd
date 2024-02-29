import 'package:dio/dio.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/orders/data/models/webshop_order_details_model.dart';

import '../../../app/di.dart';
import '../../add_order/data/models/request/webshop_calculate_bill_payload.dart';
import '../../add_order/domain/entities/add_to_cart_item.dart';
import '../../add_order/utils/cart_manager.dart';
import '../../add_order/utils/modifier_manager.dart';
import '../../common/business_information_provider.dart';
import '../../common/entities/brand.dart';
import '../domain/entities/order.dart';
import '../domain/repository/orders_repository.dart';
import 'applied_promo_provider.dart';
import 'order_menu_item_provider.dart';

class UpdateWebShopOrderDataProvider {
  final OrderRepository _orderRepository;

  UpdateWebShopOrderDataProvider(this._orderRepository);

  Future<void> generateCartData(Order manualOrder) async {
    try {
      final order = await _orderRepository.fetchOrderById(manualOrder.id);
      final cartItems = await _generateCartItem(order!);
      CartManager().clear();
      for (var cartItem in cartItems) {
        await CartManager().addToCart(cartItem);
      }
      final orderPromo = await AppliedPromoProvider().appliedPromoInfoForWebShopOrder(order);
      CartManager().setPromoInfo = orderPromo;
      await _setEditableInfo(order);
    } catch (error) {
      rethrow;
    }
  }

  Future<List<AddToCartItem>> _generateCartItem(Order order) async {
    try {
      List<AddToCartItem> carts = [];
      for (var cart in order.cartV2) {
        final menuItemOrNull = await OrderMenuItemProvider().fetchMenuItem(
          itemId: cart.id,
          brandId: cart.cartBrand.id,
          branchId: order.branchId,
          providerId: order.providerId,
        );
        if (menuItemOrNull != null) {
          final modifierGroups = await OrderMenuItemProvider().fetchModifiers(cart, menuItemOrNull, order.type);
          final brand = await _fetchMenuBrand(brandId: cart.cartBrand.id);
          final modifiersPrice = await ModifierManager().calculateModifiersPrice(modifierGroups);
          final itemPrice = menuItemOrNull.klikitPrice();
          final cartItem = AddToCartItem(
            modifiers: modifierGroups,
            item: menuItemOrNull,
            quantity: cart.quantity,
            itemInstruction: cart.comment,
            modifiersPrice: modifiersPrice,
            itemPrice: itemPrice,
            brand: brand!,
            promoInfo: null,
            discountType: DiscountType.flat,
            discountValue: order.discountValue,
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

  Future<void> _setEditableInfo(Order order) async {
    try {
      WebShopOrderDetailsModel? webShopOrderDetailsModel;
      if (order.type == OrderType.DELIVERY) {
        webShopOrderDetailsModel = await _orderRepository.fetchOmsOrderById(order.externalId);
      }
      final editInfo = CartFee(
        discountType: DiscountType.flat,
        discountValue: 0,
        additionalFee: order.additionalFee / 100,
        deliveryFee: order.deliveryFee / 100,
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
        paymentMethod: order.paymentMethod,
        paymentChannel: order.paymentChannel,
      );
      final updateCartInfo = UpdateCartInfo(
        orderID: order.id,
        externalId: order.externalId,
        identity: order.identity,
        isWebShopOrder: true,
        willUpdateOrder: true,
        isPrePayment: order.paymentStatus == PaymentStatusId.paid,
        totalPrice: order.finalPrice / 100,
        orderHash: order.externalId,
        deliveryLocation: order.type == OrderType.DELIVERY
            ? OrderDeliveryLocation(
                latitude: webShopOrderDetailsModel?.fulfillmentReceiver?.coordinates?.latitude ?? ZERO,
                longitude: webShopOrderDetailsModel?.fulfillmentReceiver?.coordinates?.longitude ?? ZERO,
                address: webShopOrderDetailsModel?.fulfillmentReceiver?.address ?? EMPTY,
                keywords: webShopOrderDetailsModel?.fulfillmentReceiver?.keywords,
                instruction: webShopOrderDetailsModel?.fulfillmentReceiver?.instruction,
              )
            : null,
      );
      CartManager().orderType = order.type;
      CartManager().orderSource = order.source;
      CartManager().orderComment = order.orderComment;
      CartManager().setCustomerInfo = customerInfo;
      CartManager().setCartFee = editInfo;
      CartManager().setPaymentInfo = paymentInfo;
      CartManager().setUpdateCartInfo = updateCartInfo;
      CartManager().setRoundOffApplicable = null;
      CartManager().setRewardPointId = order.rewardPointId.notZeroOrNull();
      CartManager().setOrderCreatorUserId = order.userId;
    } catch (error) {
      rethrow;
    }
  }
}
