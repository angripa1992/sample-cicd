import 'package:klikit/app/di.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/modules/add_order/data/models/modifier/modifier_rule.dart';
import 'package:klikit/modules/add_order/data/models/modifier/title_v2_model.dart';
import 'package:klikit/modules/add_order/data/models/request/webshop_calculate_bill_payload.dart';
import 'package:klikit/modules/add_order/domain/entities/cart_bill.dart';
import 'package:klikit/modules/add_order/domain/entities/modifier/item_modifier.dart';
import 'package:klikit/modules/add_order/domain/entities/modifier/item_modifier_group.dart';
import 'package:klikit/modules/common/business_information_provider.dart';

import '../../common/entities/branch_info.dart';
import '../data/models/modifier/item_price_model.dart';
import '../data/models/request/billing_request.dart';
import '../data/models/request/item_brand_request.dart';
import '../data/models/request/webshop_pace_order_payload.dart';
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
    final updateCartInfo = CartManager().getUpdateCartInfo();
    final editInfo = CartManager().getEditInfo();
    final cart = <WebShopCartItemPayload>[];
    for (var element in cartItems) {
      final item = await _cartItem(element, branch!);
      cart.add(item);
    }
    return WebShopCalculateBillPayload(
      branchId: branch!.id,
      orderHash: updateCartInfo?.orderHash,
      appliedPromo: orderPromoInfo?.promo,
      orderType: editInfo?.type,
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
      // discountValue: null,
      itemId: cartItem.item.id,
      // subSectionId: cartItem.item.categoryID,
      itemName: cartItem.item.title,
      //menuVersion: cartItem.item.menuVersion,
      quantity: cartItem.quantity,
      //  itemFinalPrice: cartItem.itemPrice.price,
      unitPrice: cartItem.itemPrice.price,
      // price: cartItem.itemPrice.price * cartItem.quantity,
      vat: cartItem.item.vat,
      // prices: [
      //   MenuItemPriceModel(
      //       providerId: cartItem.item.klikitPrice().providerId,
      //       currencyId: cartItem.item.klikitPrice().currencyId,
      //       code: cartItem.item.klikitPrice().currencyCode,
      //       price: cartItem.item.klikitPrice().price),
      // ],
      groups: groups,
    );
  }

  WebShopModifierGroupPayload webShopModifierGroup(MenuItemModifierGroup group, List<WebShopModifierPayload> modifiers) {
    return WebShopModifierGroupPayload(
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

  WebShopModifierPayload webShopModifier(MenuItemModifier modifier, List<WebShopModifierGroupPayload> groups) {
    return WebShopModifierPayload(
      id: modifier.id,
      modifierId: modifier.modifierId,
      modifierQuantity: modifier.quantity,
      extraPrice: modifier.klikitPrice().price,
      groups: groups,
      isSelected: modifier.isSelected,
    );
  }

  Future<WebShopPlaceOrderPayload> placeOrderPayload(CartBill bill) async {
    final customerInfo = CartManager().getCustomerInfo();
    final editInfo = CartManager().getEditInfo();
    final currency = CartManager().currency();
    final items = CartManager().items();
    final tz = await DateTimeProvider.timeZone();
    final branch = await getIt.get<BusinessInformationProvider>().branchInfo();
    int totalItems = 0;
    for (var element in items) {
      totalItems += element.quantity;
    }
    final uniqueItems = items.length;
    final cartItems = <WebShopPlaceOrderCartItem>[];
    for (var item in items) {
      final groups = await ModifierManager().billingWebShopItemModifiers(item.modifiers);
      final itemBill = bill.items.firstWhere((element) => element.id == item.item.id);
      cartItems.add(_cartItemPayload(branchInfo: branch!, cartItem: item, itemBill: itemBill, groups: groups));
    }
    return WebShopPlaceOrderPayload(
      itemPrice: bill.subTotalCent,
      finalPrice: bill.totalPriceCent,
      deliveryFee: bill.deliveryFeeCent,
      vatPrice: bill.vatPriceCent,
      discountAmount: bill.discountAmountCent,
      serviceFee: bill.serviceFeeCent,
      uniqueItems: uniqueItems,
      totalItems: totalItems,
      tz: tz,
      updateCartNote: 'something changed',
      orderComment: editInfo?.comment,
      orderType: editInfo?.type,
      branchId: branch?.id,
      tableNo: customerInfo?.tableNo,
      currency: currency,
      appliedPromo: bill.appliedPromo,
      cart: cartItems,
    );
  }

  WebShopPlaceOrderCartItem _cartItemPayload({
    required BusinessBranchInfo branchInfo,
    required AddToCartItem cartItem,
    required ItemBill itemBill,
    required List<WebShopModifierGroupPayload> groups,
  }) {
    return WebShopPlaceOrderCartItem(
      comment: cartItem.itemInstruction,
      itemId: cartItem.item.id,
      itemName: cartItem.item.title,
      title: cartItem.item.title,
      titleV2: MenuItemTitleV2Model(en: cartItem.item.title),
      description: cartItem.item.description,
      quantity: itemBill.quantity,
      itemFinalPrice: itemBill.itemFinalPrice,
      unitPrice: itemBill.basePrice,
      price: itemBill.itemPrice,
      vat: cartItem.item.vat,
      prices: [
        MenuItemPriceModel(
          providerId: cartItem.item.klikitPrice().providerId,
          currencyId: cartItem.item.klikitPrice().currencyId,
          code: cartItem.item.klikitPrice().currencyCode,
          price: cartItem.item.klikitPrice().price,
        ),
      ],
      groups: groups,
      brand: ItemBrandRequestModel(id: cartItem.brand.id, logo: cartItem.brand.logo, title: cartItem.brand.title),
    );
  }
}