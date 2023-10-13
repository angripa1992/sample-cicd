import 'package:klikit/app/di.dart';
import 'package:klikit/modules/add_order/data/models/modifier/modifier_rule.dart';
import 'package:klikit/modules/add_order/data/models/request/webshop_calculate_bill_payload.dart';
import 'package:klikit/modules/add_order/domain/entities/modifier/item_modifier.dart';
import 'package:klikit/modules/add_order/domain/entities/modifier/item_modifier_group.dart';
import 'package:klikit/modules/common/business_information_provider.dart';

import '../../common/entities/branch_info.dart';
import '../data/models/modifier/item_price_model.dart';
import '../data/models/request/billing_request.dart';
import '../data/models/request/item_brand_request.dart';
import '../domain/entities/add_to_cart_item.dart';
import 'cart_manager.dart';
import 'modifier_manager.dart';

class WebShopEntityProvider {
  static final _instance = WebShopEntityProvider._internal();

  factory WebShopEntityProvider() => _instance;

  WebShopEntityProvider._internal();

  Future<WebShopCalculateBillPayload> calculateBillPayload({required List<AddToCartItem> cartItems}) async {
    final branch = await getIt.get<BusinessInformationProvider>().branchInfo();
    final cartItem = cartItems.first;
    final orderPromoInfo = CartManager().getPromoInfo();
    final cart = <WebShopCartItemPayload>[];
    for (var element in cartItems) {
      final item = await _cartItem(element, branch!);
      cart.add(item);
    }
    return WebShopCalculateBillPayload(
      branchId: branch!.id,
      appliedPromo: orderPromoInfo?.promo,
      currency: BillingCurrency(
        id: cartItem.itemPrice.currencyId,
        code: cartItem.itemPrice.currencyCode,
        symbol: cartItem.itemPrice.currencySymbol,
      ),
      cart: cart,
    );
  }

  Future<WebShopCartItemPayload> _cartItem(AddToCartItem cartItem, BusinessBranchInfo branchInfo) async {
    final groups = await ModifierManager().billingWebShopItemModifiers(cartItem.modifiers);
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
      itemFinalPrice: cartItem.itemPrice.price,
      unitPrice: cartItem.itemPrice.price,
      price: cartItem.itemPrice.price * cartItem.quantity,
      vat: cartItem.item.vat,
      prices: [
        MenuItemPriceModel(
            providerId: cartItem.item.klikitPrice().providerId,
            currencyId: cartItem.item.klikitPrice().currencyId,
            code: cartItem.item.klikitPrice().currencyCode,
            price: cartItem.item.klikitPrice().price),
      ],
      groups: groups,
    );
  }

  WebShopGroupPayload webShopModifierGroup(MenuItemModifierGroup group, List<WebShopModifierPayload> modifiers) {
    return WebShopGroupPayload(
      groupId: group.groupId,
      rule: MenuItemModifierRuleModel(
        id: group.rule.id,
        title: group.rule.title,
        typeTitle: group.rule.typeTitle,
        value: group.rule.value,
        brandId: group.rule.brandId,
        min: group.rule.min,
        max: group.rule.max,
      ),
      modifiers: modifiers,
    );
  }

  WebShopModifierPayload webShopModifier(MenuItemModifier modifier, List<WebShopGroupPayload> groups) {
    return WebShopModifierPayload(
      id: modifier.id,
      modifierId: modifier.modifierId,
      modifierQuantity: modifier.quantity,
      extraPrice: modifier.klikitPrice().price,
      groups: groups,
      isSelected: modifier.isSelected,
    );
  }
}
