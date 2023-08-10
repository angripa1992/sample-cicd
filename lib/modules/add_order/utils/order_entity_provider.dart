import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/add_order/data/models/item_price.dart';
import 'package:klikit/modules/add_order/data/models/item_status.dart';
import 'package:klikit/modules/add_order/data/models/item_stock.dart';
import 'package:klikit/modules/add_order/data/models/request/billing_item_modifier_group_request.dart';
import 'package:klikit/modules/add_order/data/models/request/billing_item_request.dart';
import 'package:klikit/modules/add_order/data/models/request/item_brand_request.dart';
import 'package:klikit/modules/add_order/data/models/title_v2.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/menu/domain/entities/brand.dart';

import '../../../app/constants.dart';
import '../../../app/session_manager.dart';
import '../../menu/domain/entities/menu/menu_item_price.dart';
import '../../menu/domain/entities/menu/menu_out_of_stock.dart';
import '../../menu/domain/entities/menu/menu_visibility.dart';
import '../data/models/request/billing_item_modifier_request.dart';
import '../data/models/request/billing_request.dart';
import '../data/models/request/place_order_data_request.dart';
import '../domain/entities/billing_response.dart';
import '../domain/entities/item_modifier.dart';
import '../domain/entities/item_modifier_group.dart';
import 'cart_manager.dart';
import 'modifier_manager.dart';

class OrderEntityProvider {
  static final _instance = OrderEntityProvider._internal();

  factory OrderEntityProvider() => _instance;

  OrderEntityProvider._internal();

  Future<BillingRequestModel> billingRequestModel({
    required List<AddToCartItem> cartItems,
    required int orderType,
    required int discountType,
    required num discountValue,
    required num additionalFee,
    required num deliveryFee,
  }) async {
    final cartItem = cartItems.first;
    final orderPromoInfo = CartManager().getPromoInfo();
    return BillingRequestModel(
      orderType: orderType,
      brandId: cartItem.brand.id,
      branchId: SessionManager().branchId(),
      deliveryFee: deliveryFee,
      discountType: discountType,
      discountValue: discountValue,
      additionalFee: additionalFee,
      currency: BillingCurrency(
        id: cartItem.itemPrice.currencyId,
        code: cartItem.itemPrice.currencyCode,
        symbol: cartItem.itemPrice.currencySymbol,
      ),
      appliedPromoModel: orderPromoInfo?.promo,
      numberOfSeniorCitizen: orderPromoInfo?.citizen,
      numberOfCustomer: orderPromoInfo?.customer,
      items: await _cartsToBillingItemsForCalculateBill(cartsItems: cartItems),
    );
  }

  Future<List<BillingItemRequestModel>> _cartsToBillingItemsForCalculateBill({
    required List<AddToCartItem> cartsItems,
  }) async {
    final items = <BillingItemRequestModel>[];
    for (var item in cartsItems) {
      final groups =
          await ModifierManager().billingItemModifiers(item.modifiers);
      items.add(
        _cartItemToBillingItem(
          cartItem: item,
          groups: groups,
          promoDiscount: null,
          promoInfo: item.promoInfo,
        ),
      );
    }
    return items;
  }

  Future<List<BillingItemRequestModel>> _cartsToBillingItemsForPlaceOrder({
    required List<AddToCartItem> cartsItems,
    required List<ItemBill> itemBills,
  }) async {
    final items = <BillingItemRequestModel>[];
    for (var item in cartsItems) {
      final groups =
          await ModifierManager().billingItemModifiers(item.modifiers);
      final itemBill =
          itemBills.firstWhere((element) => element.id == item.item.id);
      items.add(
        _cartItemToBillingItem(
          cartItem: item,
          groups: groups,
          promoDiscount: itemBill.promoDiscountCent,
          promoInfo: item.promoInfo,
        ),
      );
    }
    return items;
  }

  BillingItemRequestModel _cartItemToBillingItem({
    required AddToCartItem cartItem,
    required List<BillingItemModifierGroupRequestModel> groups,
    required num? promoDiscount,
    required PromoInfo? promoInfo,
  }) {
    final item = cartItem.item;
    return BillingItemRequestModel(
      id: item.id,
      itemId: item.id,
      defaultItemId: item.defaultItemId,
      title: item.title,
      titleV2: TitleV2Model(en: item.title),
      description: item.description,
      descriptionV2: TitleV2Model(en: item.description),
      image: item.image,
      quantity: cartItem.quantity,
      sequence: item.sequence,
      hidden: item.visible(ProviderID.KLIKIT),
      enabled: item.enabled,
      vat: item.vat,
      brand: _toBrandModel(cartItem.brand),
      stock: _stockModel(item.outOfStock),
      statuses: item.visibilities
          .map((visibility) => _statusModel(item.enabled, visibility))
          .toList(),
      prices: item.prices.map((e) => _priceModel(e)).toList(),
      groups: groups,
      unitPrice: cartItem.itemPrice.price,
      discountValue: cartItem.discountValue,
      discountType: cartItem.discountType,
      comment: cartItem.itemInstruction,
      appliedPromoModel: promoInfo?.promo,
      quantityOfScPromoItem: promoInfo?.citizen,
      promoDiscount: promoDiscount,
    );
  }

  BillingItemModifierGroupRequestModel cartToBillingModifierGroup(
    ItemModifierGroup group,
    List<BillingItemModifierRequestModel> modifiers,
  ) =>
      BillingItemModifierGroupRequestModel(
        groupId: group.groupId,
        title: group.title,
        label: group.label,
        brandId: group.brandId,
        sequence: group.sequence,
        statuses: group.statuses.map((e) => e.toModel()).toList(),
        rule: group.rule.toModel(),
        modifiers: modifiers,
      );

  BillingItemModifierRequestModel cartToBillingModifier(
    ItemModifier modifier,
    List<BillingItemModifierGroupRequestModel> groups,
  ) =>
      BillingItemModifierRequestModel(
        id: modifier.id,
        modifierId: modifier.modifierId,
        immgId: modifier.immgId,
        title: modifier.title,
        titleV2: TitleV2Model(en: modifier.title),
        statuses: modifier.statuses.map((e) => e.toModel()).toList(),
        prices: modifier.prices.map((e) => e.toModel()).toList(),
        groups: groups,
        isSelected: modifier.isSelected,
        modifierQuantity: modifier.quantity,
        extraPrice: modifier.prices
            .firstWhere((element) => element.providerId == ProviderID.KLIKIT)
            .price,
      );

  ItemStockModel _stockModel(MenuOutOfStock stock) => ItemStockModel(
        available: stock.available,
        snooze: _snoozeModel(stock.menuSnooze),
      );

  ItemSnoozeModel _snoozeModel(MenuSnooze snooze) => ItemSnoozeModel(
        endTime: snooze.endTime,
        duration: snooze.duration,
      );

  ItemStatusModel _statusModel(bool enabled, MenuVisibility visibility) =>
      ItemStatusModel(
        providerId: visibility.providerID,
        enabled: enabled,
        hidden: visibility.visible,
      );

  ItemPriceModel _priceModel(MenuItemPrice price) => ItemPriceModel(
        providerId: price.providerId,
        currencyId: price.currencyId,
        code: price.currencyCode,
        price: price.price,
      );

  ItemBrandRequestModel _toBrandModel(MenuBrand brand) => ItemBrandRequestModel(
        id: brand.id,
        logo: brand.logo,
        title: brand.title,
      );

  Future<PlaceOrderDataRequestModel> placeOrderRequestData({
    required CheckoutData checkoutData,
    required int paymentStatus,
    required int? paymentMethod,
    required CustomerInfo? info,
  }) async {
    final bill = checkoutData.cartBill;
    final cartItems = await _cartsToBillingItemsForPlaceOrder(
      cartsItems: checkoutData.items,
      itemBills: bill.items,
    );
    int totalItems = 0;
    for (var element in cartItems) {
      totalItems += element.quantity ?? 0;
    }
    final uniqueItems = cartItems.length;
    final currency = CartManager().currency();
    CustomerInfoModel user = CustomerInfoModel();
    if (info != null) {
      user.firstName = info.firstName.notEmptyOrNull();
      user.lastName = info.lastName.notEmptyOrNull();
      user.email = info.email.notEmptyOrNull();
      user.phone = info.phone.notEmptyOrNull();
    }
    final updateInfo = CartManager().getUpdateCartInfo();
    return PlaceOrderDataRequestModel(
      id: updateInfo?.id,
      externalId: updateInfo?.externalId,
      identity: updateInfo?.identity,
      branchId: SessionManager().branchId(),
      currency: currency.code,
      currencySymbol: currency.symbol,
      currencyId: currency.id,
      source: checkoutData.source,
      type: checkoutData.type,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      deliveryFee: bill.deliveryFeeCent.toInt(),
      vatAmount: bill.vatPriceCent.toInt(),
      discountAmount: bill.discountAmountCent.toInt(),
      discountValue: checkoutData.discountValue.toInt(),
      discountType: checkoutData.discountType,
      additionalFee: bill.additionalFeeCent.toInt(),
      serviceFee: bill.serviceFeeCent.toInt(),
      uniqueItems: uniqueItems,
      totalItems: totalItems,
      tableNo: info?.tableNo.notEmptyOrNull(),
      user: user,
      finalPrice: bill.totalPriceCent.toInt(),
      itemPrice: bill.subTotalCent.toInt(),
      cart: cartItems,
      orderComment: checkoutData.instruction,
      numberOfSeniorCitizen:
          bill.numberOfSeniorCitizen > 0 ? bill.numberOfSeniorCitizen : null,
      numberOfCustomer:
          bill.numberOfSeniorCustomer > 0 ? bill.numberOfSeniorCustomer : null,
      orderPromoDiscount: bill.orderPromoDiscountCent,
      appliedPromoModel: bill.appliedPromo,
    );
  }
}
