import 'package:klikit/modules/add_order/data/models/billing_item.dart';
import 'package:klikit/modules/add_order/data/models/billing_item_modifier_group.dart';
import 'package:klikit/modules/add_order/data/models/item_brand.dart';
import 'package:klikit/modules/add_order/data/models/item_price.dart';
import 'package:klikit/modules/add_order/data/models/item_status.dart';
import 'package:klikit/modules/add_order/data/models/item_stock.dart';
import 'package:klikit/modules/add_order/data/models/title_v2.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/menu/domain/entities/brand.dart';
import 'package:klikit/modules/menu/domain/entities/price.dart';

import '../../../app/constants.dart';
import '../../../app/session_manager.dart';
import '../../menu/domain/entities/status.dart';
import '../../menu/domain/entities/stock.dart';
import '../data/models/billing_item_modifier.dart';
import '../data/models/billing_request.dart';
import '../domain/entities/item_modifier.dart';
import '../domain/entities/item_modifier_group.dart';
import '../domain/entities/item_price.dart';
import 'modifier_manager.dart';
import 'order_price_provider.dart';

class OrderEntityProvider {
  static final _instance = OrderEntityProvider._internal();

  factory OrderEntityProvider() => _instance;

  OrderEntityProvider._internal();

  Future<BillingRequestModel?> billingRequestModel(List<AddToCartItem> cartItems) async{
    if(cartItems.isNotEmpty){
      final cartItem = cartItems.first;
      return BillingRequestModel(
        brandId: cartItem.brand.id,
        branchId: SessionManager().currentUserBranchId(),
        deliveryFee: 0,
        discountType: 1,
        discountValue: 0,
        additionalFee: 0,
        currency: _billingCurrency(cartItem.itemPrice),
        items: await _cartsToBillingItems(cartItems),
      );
    }
    return null;
  }

  Future<List<BillingItem>> _cartsToBillingItems(List<AddToCartItem> cartsItems) async{
    final items = <BillingItem>[];
    for(var item in cartsItems){
      final groups = await ModifierManager().billingItemModifiers(item.modifiers);
      items.add(_cartItemToBillingItem(item, groups));
    }
    return items;
  }

  BillingItem _cartItemToBillingItem(AddToCartItem cartItem,List<BillingItemModifierGroup> groups) {
    final item = cartItem.item;
    return BillingItem(
      id: item.id,
      itemId: item.id,
      defaultItemId: item.defaultItemId,
      title: item.title,
      titleV2: TitleV2Model(en: item.titleV2.en),
      description: item.description,
      descriptionV2: TitleV2Model(en: item.descriptionV2.en),
      image: item.image,
      quantity: cartItem.quantity,
      sequence: item.sequence,
      hidden: item.hidden,
      enabled: item.enabled,
      vat: item.vat,
      brand: _toBrandModel(cartItem.brand),
      stock: _stockModel(item.stock),
      statuses: item.statuses.map((e) => _statusModel(e)).toList(),
      prices: item.prices.map((e) => _priceModel(e)).toList(),
      groups: groups,
    );
  }

  BillingItemModifierGroup cartToBillingModifierGroup(
    ItemModifierGroup group,
    List<BillingItemModifier> modifiers,
  ) =>
      BillingItemModifierGroup(
        groupId: group.groupId,
        title: group.title,
        label: group.label,
        brandId: group.brandId,
        sequence: group.sequence,
        statuses: group.statuses.map((e) => e.toModel()).toList(),
        rule: group.rule.toModel(),
        modifiers: modifiers,
      );

  BillingItemModifier cartToBillingModifier(
    ItemModifier modifier,
    List<BillingItemModifierGroup> groups,
  ) =>
      BillingItemModifier(
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
        extraPrice: modifier.prices.firstWhere((element) => element.providerId == ProviderID.KLIKIT).price,
      );

  ItemStockModel _stockModel(Stock stock) => ItemStockModel(
        available: stock.available,
        snooze: _snoozeModel(stock.snooze),
      );

  ItemSnoozeModel _snoozeModel(Snooze snooze) => ItemSnoozeModel(
        endTime: snooze.endTime,
        duration: snooze.duration,
      );

  ItemStatusModel _statusModel(Statuses status) => ItemStatusModel(
        providerId: status.providerId,
        enabled: status.enabled,
        hidden: status.hidden,
      );

  ItemPriceModel _priceModel(Prices prices) => ItemPriceModel(
        providerId: prices.providerId,
        currencyId: prices.currencyId,
        symbol: prices.symbol,
        code: prices.code,
        price: prices.price,
      );

  ItemBrandModel _toBrandModel(MenuBrand brand) => ItemBrandModel(
        id: brand.id,
        logo: brand.logo,
        title: brand.title,
      );
  BillingCurrency _billingCurrency(Prices price) => BillingCurrency(
    id: price.currencyId,
    symbol: price.symbol,
    code: price.code,
  );
}