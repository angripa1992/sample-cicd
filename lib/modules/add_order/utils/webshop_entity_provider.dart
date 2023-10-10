import 'package:klikit/app/di.dart';
import 'package:klikit/modules/add_order/data/models/request/webshop_calculate_bill_payload.dart';
import 'package:klikit/modules/common/business_information_provider.dart';

import '../../common/entities/branch_info.dart';
import '../data/models/modifier/item_price_model.dart';
import '../data/models/request/billing_request.dart';
import '../data/models/request/item_brand_request.dart';
import '../domain/entities/add_to_cart_item.dart';
import 'cart_manager.dart';

class WebShopEntityProvider {
  static final _instance = WebShopEntityProvider._internal();

  factory WebShopEntityProvider() => _instance;

  WebShopEntityProvider._internal();

  Future<WebShopCalculateBillPayload?> calculateBillPayload({
    required List<AddToCartItem> cartItems,
    required int orderType,
    required int discountType,
    required num discountValue,
    required num additionalFee,
    required num deliveryFee,
  }) async {
    final branch = await getIt.get<BusinessInformationProvider>().branchInfo();
    if (branch == null) return null;
    final cartItem = cartItems.first;
    final orderPromoInfo = CartManager().getPromoInfo();
    return WebShopCalculateBillPayload(
        branchId: branch.id,
        appliedPromo: orderPromoInfo?.promo,
        currency: BillingCurrency(
          id: cartItem.itemPrice.currencyId,
          code: cartItem.itemPrice.currencyCode,
          symbol: cartItem.itemPrice.currencySymbol,
        ),
        cart: cartItems.map((item) => _cartItem(item, branch)).toList());
  }

  WebShopCartItemPayload _cartItem(AddToCartItem cartItem, BusinessBranchInfo branchInfo) {
    return WebShopCartItemPayload(
      branch: branchInfo,
      brand: ItemBrandRequestModel(id: cartItem.brand.id, logo: cartItem.brand.logo, title: cartItem.brand.title),
      comment: cartItem.itemInstruction,
      discountValue: null,
      itemId: cartItem.item.id,
      subSectionId: cartItem.item.categoryID,
      itemName: cartItem.item.title,
      menuVersion: cartItem.item.menuVersion,
      quantity: cartItem.quantity,
      itemFinalPrice: cartItem.itemPrice.price.toInt() / 100,
      unitPrice: cartItem.itemPrice.price.toInt() / 100,
      price: (cartItem.itemPrice.price * cartItem.quantity) / 100,
      vat: cartItem.item.vat / 100,
      prices: [
        MenuItemPriceModel(
          providerId: cartItem.item.klikitPrice().providerId,
          currencyId: cartItem.item.klikitPrice().currencyId,
          code: cartItem.item.klikitPrice().currencyCode,
          price: cartItem.item.klikitPrice().price / 100,
        ),
      ],
    );
  }
}
