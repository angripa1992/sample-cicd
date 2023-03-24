class ItemPriceModel {
  int? providerId;
  int? currencyId;
  String? code;
  String? symbol;
  int? price;

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
}
