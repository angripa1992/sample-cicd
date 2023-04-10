import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/add_order/domain/entities/item_price.dart';

class ItemPriceModel {
  int? providerId;
  int? currencyId;
  String? code;
  String? symbol;
  double? price;

  ItemPriceModel({
    this.providerId,
    this.currencyId,
    this.code,
    this.symbol,
    this.price,
  });

  ItemPriceModel.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    currencyId = json['currency_id'];
    code = json['code'];
    symbol = json['symbol'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['provider_id'] = providerId;
    data['currency_id'] = currencyId;
    data['code'] = code;
    data['symbol'] = symbol;
    data['price'] = price;
    return data;
  }

  ItemPrice toEntity() {
    return ItemPrice(
      providerId: providerId.orZero(),
      currencyId: currencyId.orZero(),
      code: code.orEmpty(),
      symbol: symbol.orEmpty(),
      price: price.orZero(),
    );
  }
}
