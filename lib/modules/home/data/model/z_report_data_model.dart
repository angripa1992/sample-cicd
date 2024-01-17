class ZReportData {
  OrderSummary? orderSummary;
  ItemAndModifierSummary? itemSummary;
  ItemAndModifierSummary? modifierItemSummary;
  PaymentSummary? paymentSummary;
  String? createdAt;
  String? fromTime;
  String? toTime;

  ZReportData({
    this.orderSummary,
    this.itemSummary,
    this.modifierItemSummary,
    this.paymentSummary,
    this.createdAt,
    this.fromTime,
    this.toTime,
  });

  ZReportData.fromJson(Map<String, dynamic> json) {
    orderSummary = json['order_summary'] != null ? OrderSummary.fromJson(json['order_summary']) : null;
    itemSummary = json['item_summary'] != null ? ItemAndModifierSummary.fromJson(json['item_summary']) : null;
    modifierItemSummary = json['modifier_summary'] != null ? ItemAndModifierSummary.fromJson(json['modifier_summary']) : null;
    paymentSummary = json['payment_summary'] != null ? PaymentSummary.fromJson(json['payment_summary']) : null;
    createdAt = json['created_at'];
    fromTime = json['from_time'];
    toTime = json['to_time'];
  }
}

class OrderSummary {
  List<OrderSummaryItem>? summary;
  List<BrandOrderSummary>? brandOrderSummary;

  OrderSummary({this.summary, this.brandOrderSummary});

  OrderSummary.fromJson(Map<String, dynamic> json) {
    if (json['summary'] != null) {
      summary = <OrderSummaryItem>[];
      json['summary'].forEach((v) {
        summary!.add(OrderSummaryItem.fromJson(v));
      });
    }
    if (json['brand_order_summary'] != null) {
      brandOrderSummary = <BrandOrderSummary>[];
      json['brand_order_summary'].forEach((v) {
        brandOrderSummary!.add(BrandOrderSummary.fromJson(v));
      });
    }
  }
}

class ItemAndModifierSummary {
  List<ItemSummaryItem>? summary;

  ItemAndModifierSummary({this.summary});

  ItemAndModifierSummary.fromJson(Map<String, dynamic> json) {
    if (json['summary'] != null) {
      summary = <ItemSummaryItem>[];
      json['summary'].forEach((v) {
        summary!.add(ItemSummaryItem.fromJson(v));
      });
    }
  }
}

class PaymentSummary {
  List<PaymentSummaryItem>? summary;

  PaymentSummary({this.summary});

  PaymentSummary.fromJson(Map<String, dynamic> json) {
    if (json['summary'] != null) {
      summary = <PaymentSummaryItem>[];
      json['summary'].forEach((v) {
        summary!.add(PaymentSummaryItem.fromJson(v));
      });
    }
  }
}

class OrderSummaryItem {
  int? providerId;
  num? totalOrders;
  num? completedOrders;
  num? cancelledOrders;
  String? currency;
  String? currencySymbol;
  num? grossRevenue;
  num? realizedRevenue;
  num? netRevenue;
  num? lostRevenue;
  num? avgCompletedBasketSize;
  num? avgCancelledBasketSize;
  List<OrderSourceSummaries>? orderSourceSummaries;
  num? discount;
  num? ordersPercentage;
  num? merchantDiscount;
  num? providerDiscount;

  OrderSummaryItem({
    this.providerId,
    this.totalOrders,
    this.completedOrders,
    this.cancelledOrders,
    this.currency,
    this.currencySymbol,
    this.grossRevenue,
    this.realizedRevenue,
    this.netRevenue,
    this.lostRevenue,
    this.avgCompletedBasketSize,
    this.avgCancelledBasketSize,
    this.orderSourceSummaries,
    this.discount,
    this.ordersPercentage,
    this.merchantDiscount,
    this.providerDiscount,
  });

  OrderSummaryItem.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    totalOrders = json['total_orders'];
    completedOrders = json['completed_orders'];
    cancelledOrders = json['cancelled_orders'];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    grossRevenue = json['gross_revenue'];
    realizedRevenue = json['realized_revenue'];
    netRevenue = json['net_revenue'];
    lostRevenue = json['lost_revenue'];
    avgCompletedBasketSize = json['avg_completed_basket_size'];
    avgCancelledBasketSize = json['avg_cancelled_basket_size'];
    if (json['order_source_summaries'] != null) {
      orderSourceSummaries = <OrderSourceSummaries>[];
      json['order_source_summaries'].forEach((v) {
        orderSourceSummaries!.add(OrderSourceSummaries.fromJson(v));
      });
    }
    discount = json['discount'];
    ordersPercentage = json['orders_percentage'];
    merchantDiscount = json['merchant_discount'];
    providerDiscount = json['provider_discount'];
  }
}

class OrderSourceSummaries {
  int? providerId;
  num? totalOrders;
  num? completedOrders;
  num? cancelledOrders;
  String? currency;
  String? currencySymbol;
  num? grossRevenue;
  num? realizedRevenue;
  num? netRevenue;
  num? lostRevenue;
  num? avgCompletedBasketSize;
  num? avgCancelledBasketSize;
  String? orderSource;
  num? discount;
  num? ordersPercentage;
  num? merchantDiscount;
  num? providerDiscount;

  OrderSourceSummaries(
      {this.providerId,
      this.totalOrders,
      this.completedOrders,
      this.cancelledOrders,
      this.currency,
      this.currencySymbol,
      this.grossRevenue,
      this.realizedRevenue,
      this.netRevenue,
      this.lostRevenue,
      this.avgCompletedBasketSize,
      this.avgCancelledBasketSize,
      this.orderSource,
      this.discount,
      this.ordersPercentage,
      this.merchantDiscount,
      this.providerDiscount});

  OrderSourceSummaries.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    totalOrders = json['total_orders'];
    completedOrders = json['completed_orders'];
    cancelledOrders = json['cancelled_orders'];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    grossRevenue = json['gross_revenue'];
    realizedRevenue = json['realized_revenue'];
    netRevenue = json['net_revenue'];
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

class BrandOrderSummary {
  int? brandId;
  int? totalOrders;
  int? completedOrders;
  int? cancelledOrders;
  String? currency;
  String? currencySymbol;
  num? grossRevenue;
  num? realizedRevenue;
  num? netRevenue;
  num? lostRevenue;
  num? avgCompletedBasketSize;
  num? avgCancelledBasketSize;
  num? discount;
  num? ordersPercentage;
  num? merchantDiscount;
  num? providerDiscount;

  BrandOrderSummary(
      {this.brandId,
      this.totalOrders,
      this.completedOrders,
      this.cancelledOrders,
      this.currency,
      this.currencySymbol,
      this.grossRevenue,
      this.realizedRevenue,
      this.netRevenue,
      this.lostRevenue,
      this.avgCompletedBasketSize,
      this.avgCancelledBasketSize,
      this.discount,
      this.ordersPercentage,
      this.merchantDiscount,
      this.providerDiscount});

  BrandOrderSummary.fromJson(Map<String, dynamic> json) {
    brandId = json['brand_id'];
    totalOrders = json['total_orders'];
    completedOrders = json['completed_orders'];
    cancelledOrders = json['cancelled_orders'];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    grossRevenue = json['gross_revenue'];
    realizedRevenue = json['realized_revenue'];
    netRevenue = json['net_revenue'];
    lostRevenue = json['lost_revenue'];
    avgCompletedBasketSize = json['avg_completed_basket_size'];
    avgCancelledBasketSize = json['avg_cancelled_basket_size'];
    discount = json['discount'];
    ordersPercentage = json['orders_percentage'];
    merchantDiscount = json['merchant_discount'];
    providerDiscount = json['provider_discount'];
  }
}

class ItemSummaryItem {
  String? title;
  num? count;
  int? quantity;
  num? revenue;
  num? revenueUsd;
  List<ItemSummaryProvider>? providers;

  ItemSummaryItem({this.title, this.count, this.quantity, this.revenue, this.revenueUsd, this.providers});

  ItemSummaryItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    count = json['count'];
    quantity = json['quantity'];
    revenue = json['revenue'];
    revenueUsd = json['revenue_usd'];
    if (json['providers'] != null) {
      providers = <ItemSummaryProvider>[];
      json['providers'].forEach((v) {
        providers!.add(ItemSummaryProvider.fromJson(v));
      });
    }
  }
}

class ItemSummaryProvider {
  int? providerId;
  num? orderCount;
  int? quantity;
  num? revenue;
  num? revenueUsd;

  ItemSummaryProvider({this.providerId, this.orderCount, this.quantity, this.revenue, this.revenueUsd});

  ItemSummaryProvider.fromJson(Map<String, dynamic> json) {
    providerId = json['provider_id'];
    orderCount = json['order_count'];
    quantity = json['quantity'];
    revenue = json['revenue'];
    revenueUsd = json['revenue_usd'];
  }
}

class PaymentSummaryItem {
  String? paymentMethod;
  String? currency;
  String? currencySymbol;
  num? totalOrders;
  num? grossRevenue;
  num? netRevenue;
  num? discount;
  num? avgBasketSize;
  List<PaymentChannelItem>? channelAnalytics;

  PaymentSummaryItem({
    this.paymentMethod,
    this.currency,
    this.currencySymbol,
    this.totalOrders,
    this.netRevenue,
    this.grossRevenue,
    this.discount,
    this.avgBasketSize,
    this.channelAnalytics,
  });

  PaymentSummaryItem.fromJson(Map<String, dynamic> json) {
    paymentMethod = json['payment_method'];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    totalOrders = json['total_orders'];
    netRevenue = json['net_revenue'];
    grossRevenue = json['gross_revenue'];
    discount = json['discount'];
    avgBasketSize = json['avg_basket_size'];
    if (json['channel_analytics'] != null) {
      channelAnalytics = <PaymentChannelItem>[];
      json['channel_analytics'].forEach((v) {
        channelAnalytics!.add(PaymentChannelItem.fromJson(v));
      });
    }
  }
}

class PaymentChannelItem {
  String? paymentChannel;
  String? currency;
  String? currencySymbol;
  num? totalOrders;
  num? netRevenue;
  num? grossRevenue;
  num? discount;
  num? avgBasketSize;

  PaymentChannelItem({
    this.paymentChannel,
    this.currency,
    this.currencySymbol,
    this.totalOrders,
    this.netRevenue,
    this.grossRevenue,
    this.discount,
    this.avgBasketSize,
  });

  PaymentChannelItem.fromJson(Map<String, dynamic> json) {
    paymentChannel = json['payment_channel'];
    currency = json['currency'];
    currencySymbol = json['currency_symbol'];
    totalOrders = json['total_orders'];
    netRevenue = json['net_revenue'];
    grossRevenue = json['gross_revenue'];
    discount = json['discount'];
    avgBasketSize = json['avg_basket_size'];
  }
}
