import 'package:klikit/modules/add_order/data/models/billing_item.dart';
import 'package:klikit/modules/add_order/data/models/item_price.dart';
import 'package:klikit/modules/add_order/data/models/item_status.dart';
import 'package:klikit/modules/add_order/data/models/item_stock.dart';
import 'package:klikit/modules/add_order/data/models/title_v2.dart';
import 'package:klikit/modules/add_order/domain/entities/add_to_cart_item.dart';
import 'package:klikit/modules/menu/domain/entities/price.dart';

import '../../menu/domain/entities/status.dart';
import '../../menu/domain/entities/stock.dart';

class OrderEntityConverter {
  BillingItem cartItemToBillingItem(AddToCartItem cartItem) {
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
      stock: _stockModel(item.stock),
      statuses: item.statuses.map((e) => _statusModel(e)).toList(),
      prices: item.prices.map((e) => _priceModel(e)).toList(),

    );
  }

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
}
