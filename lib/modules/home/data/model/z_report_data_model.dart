class ZReportDataModel {
  OrderSummaryModel? orderSummary;
  ItemSummaryModel? itemSummary;
  PaymentSummaryModel? paymentSummary;
  String? createdAt;
  String? fromTime;
  String? toTime;

  ZReportDataModel({
    this.orderSummary,
    this.itemSummary,
    this.paymentSummary,
    this.createdAt,
    this.fromTime,
    this.toTime,
  });

  ZReportDataModel.fromJson(Map<String, dynamic> json) {
    orderSummary = json['order_summary'] != null
        ? OrderSummaryModel.fromJson(json['order_summary'])
        : null;
    itemSummary = json['item_summary'] != null
        ? ItemSummaryModel.fromJson(json['item_summary'])
        : null;
    paymentSummary = json['payment_summary'] != null
        ? PaymentSummaryModel.fromJson(json['payment_summary'])
        : null;
    createdAt = json['created_at'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
  }
}

class OrderSummaryModel {
  List<OrderSummaryItemModel>? summary;
  String? lastRefreshedAt;

  OrderSummaryModel({this.summary, this.lastRefreshedAt});

  OrderSummaryModel.fromJson(Map<String, dynamic> json) {
    if (json['summary'] != null) {
      summary = <OrderSummaryItemModel>[];
      json['summary'].forEach((v) {
        summary!.add(OrderSummaryItemModel.fromJson(v));
      });
    }
    lastRefreshedAt = json['last_refreshed_at'];
  }
}

class ItemSummaryModel {
  List<ItemSummaryItemModel>? summary;
  String? lastRefreshedAt;

  ItemSummaryModel({this.summary, this.lastRefreshedAt});

  ItemSummaryModel.fromJson(Map<String, dynamic> json) {
    if (json['summary'] != null) {
      summary = <ItemSummaryItemModel>[];
      json['summary'].forEach((v) {
        summary!.add(ItemSummaryItemModel.fromJson(v));
      });
    }
    lastRefreshedAt = json['last_refreshed_at'];
  }
}

class PaymentSummaryModel {
  List<PaymentSummaryItemModel>? summary;
  String? lastRefreshedAt;

  PaymentSummaryModel({this.summary, this.lastRefreshedAt});

  PaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    if (json['summary'] != null) {
      summary = <PaymentSummaryItemModel>[];
      json['summary'].forEach((v) {
        summary!.add(PaymentSummaryItemModel.fromJson(v));
      });
    }
    lastRefreshedAt = json['last_refreshed_at'];
  }
}

class OrderSummaryItemModel {
  int? providerId;
  int? totalOrders;
  int? completedOrders;
  int? cancelledOrders;
  String? currency;
  String? currencySymbol;
  int? grossRevenue;
  int? realizedRevenue;
  int? lostRevenue;
  num? avgCompletedBasketSize;
  num? avgCancelledBasketSize;
  List<OrderSourceSummariesModel>? orderSourceSummaries;
  int? discount;
  int? ordersPercentage;
  int? merchantDiscount;
  int? providerDiscount;

  OrderSummaryItemModel({
    this.providerId,
    this.totalOrders,
    this.completedOrders,
    this.cancelledOrders,
    this.currency,
    this.currencySymbol,
    this.grossRevenue,
    this.realizedRevenue,
    this.lostRevenue,
    this.avgCompletedBasketSize,
    this.avgCancelledBasketSize,
    this.orderSourceSummaries,
    this.discount,
    this.ordersPercentage,
    this.merchantDiscount,
    this.providerDiscount,
  });

  OrderSummaryItemModel.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    totalOrders = json['total_orders'];
    completedOrders = json['completed_orders'];
    cancelledOrders = json['cancelled_orders'];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    grossRevenue = json['gross_revenue'];
    realizedRevenue = json['realized_revenue'];
    lostRevenue = json['lost_revenue'];
    avgCompletedBasketSize = json['avg_completed_basket_size'];
    avgCancelledBasketSize = json['avg_cancelled_basket_size'];
    if (json['order_source_summaries'] != null) {
      orderSourceSummaries = <OrderSourceSummariesModel>[];
      json['order_source_summaries'].forEach((v) {
        orderSourceSummaries!.add(OrderSourceSummariesModel.fromJson(v));
      });
    }
    discount = json['discount'];
    ordersPercentage = json['orders_percentage'];
    merchantDiscount = json['merchant_discount'];
    providerDiscount = json['provider_discount'];
  }
}

class OrderSourceSummariesModel {
  int? providerId;
  int? totalOrders;
  int? completedOrders;
  int? cancelledOrders;
  String? currency;
  String? currencySymbol;
  int? grossRevenue;
  int? realizedRevenue;
  int? lostRevenue;
  num? avgCompletedBasketSize;
  num? avgCancelledBasketSize;
  String? orderSource;
  int? discount;
  num? ordersPercentage;
  int? merchantDiscount;
  int? providerDiscount;

  OrderSourceSummariesModel(
      {this.providerId,
      this.totalOrders,
      this.completedOrders,
      this.cancelledOrders,
      this.currency,
      this.currencySymbol,
      this.grossRevenue,
      this.realizedRevenue,
      this.lostRevenue,
      this.avgCompletedBasketSize,
      this.avgCancelledBasketSize,
      this.orderSource,
      this.discount,
      this.ordersPercentage,
      this.merchantDiscount,
      this.providerDiscount});

  OrderSourceSummariesModel.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    totalOrders = json['total_orders'];
    completedOrders = json['completed_orders'];
    cancelledOrders = json['cancelled_orders'];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    grossRevenue = json['gross_revenue'];
    realizedRevenue = json['realized_revenue'];
    lostRevenue = json['lost_revenue'];
    avgCompletedBasketSize = json['avg_completed_basket_size'];
    avgCancelledBasketSize = json['avg_cancelled_basket_size'];
    orderSource = json['order_source'];
    discount = json['discount'];
    ordersPercentage = json['orders_percentage'];
    merchantDiscount = json['merchant_discount'];
    providerDiscount = json['provider_discount'];
  }
}

class ItemSummaryItemModel {
  String? title;
  int? count;
  int? quantity;
  int? revenue;
  int? revenueUsd;
  List<ItemSummaryProviderModel>? providers;

  ItemSummaryItemModel(
      {this.title,
      this.count,
      this.quantity,
      this.revenue,
      this.revenueUsd,
      this.providers});

  ItemSummaryItemModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    count = json['count'];
    quantity = json['quantity'];
    revenue = json['revenue'];
    revenueUsd = json['revenue_usd'];
    if (json['providers'] != null) {
      providers = <ItemSummaryProviderModel>[];
      json['providers'].forEach((v) {
        providers!.add(ItemSummaryProviderModel.fromJson(v));
      });
    }
  }
}

class ItemSummaryProviderModel {
  int? providerId;
  int? orderCount;
  int? quantity;
  int? revenue;
  int? revenueUsd;

  ItemSummaryProviderModel(
      {this.providerId,
      this.orderCount,
      this.quantity,
      this.revenue,
      this.revenueUsd});

  ItemSummaryProviderModel.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    orderCount = json['order_count'];
    quantity = json['quantity'];
    revenue = json['revenue'];
    revenueUsd = json['revenue_usd'];
  }
}

class PaymentSummaryItemModel {
  String? paymentMethod;
  String? currency;
  String? currencySymbol;
  int? totalOrders;
  int? grossRevenue;
  int? discount;
  num? avgBasketSize;
  List<PaymentChannelAnalyticModel>? channelAnalytics;

  PaymentSummaryItemModel(
      {this.paymentMethod,
      this.currency,
      this.currencySymbol,
      this.totalOrders,
      this.grossRevenue,
      this.discount,
      this.avgBasketSize,
      this.channelAnalytics,});

  PaymentSummaryItemModel.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    totalOrders = json['total_orders'];
    grossRevenue = json['gross_revenue'];
    discount = json['discount'];
    avgBasketSize = json['avg_basket_size'];
    if (json['channel_analytics'] != null) {
      channelAnalytics = <PaymentChannelAnalyticModel>[];
      json['channel_analytics'].forEach((v) {
        channelAnalytics!.add(PaymentChannelAnalyticModel.fromJson(v));
      });
    }
  }
}

class PaymentChannelAnalyticModel {
  String? paymentChannel;
  String? currency;
  String? currencySymbol;
  int? totalOrders;
  int? grossRevenue;
  int? discount;
  num? avgBasketSize;

  PaymentChannelAnalyticModel(
      {this.paymentChannel,
      this.currency,
      this.currencySymbol,
      this.totalOrders,
      this.grossRevenue,
      this.discount,
      this.avgBasketSize});

  PaymentChannelAnalyticModel.fromJson(Map<String, dynamic> json) {
    paymentChannel = json['payment_channel'];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    totalOrders = json['total_orders'];
    grossRevenue = json['gross_revenue'];
    discount = json['discount'];
    avgBasketSize = json['avg_basket_size'];
  }
}
