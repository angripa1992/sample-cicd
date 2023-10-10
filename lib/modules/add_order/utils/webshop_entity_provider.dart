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
      itemFinalPrice: 0,
      itemId: cartItem.item.id,
      itemName: cartItem.item.title,
      menuVersion: cartItem.item.menuVersion,
      quantity: cartItem.quantity,
      prices: cartItem.item.prices
          .map((price) => MenuItemPriceModel(
                providerId: price.providerId,
                currencyId: price.currencyId,
                code: price.currencyCode,
                price: price.price,
              ))
          .toList(),

    );
  }
}
