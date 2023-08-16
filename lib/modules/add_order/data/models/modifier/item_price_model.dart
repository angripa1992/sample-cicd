import 'package:klikit/app/extensions.dart';

import '../../../domain/entities/modifier/item_price.dart';

class MenuItemPriceModel {
  int? providerId;
  int? currencyId;
  String? code;
  String? symbol;
  num? price;

  MenuItemPriceModel({
    this.providerId,
    this.currencyId,
    this.code,
    this.symbol,
    this.price,
  });

  MenuItemPriceModel.fromJson(Map<String, dynamic> json) {
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

  // AddOrderModifierItemPrice toEntity() {
  //   return AddOrderModifierItemPrice(
  //     providerId: providerId.orZero(),
  //     currencyId: currencyId.orZero(),
  //     code: code.orEmpty(),
  //     symbol: symbol.orEmpty(),
  //     price: price ?? ZERO,
  //   );
  // }
}
