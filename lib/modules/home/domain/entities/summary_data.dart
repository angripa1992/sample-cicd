class OrderSummaryData {
  final List<OrderSummary> summary;
  final Metrics metrics;

  OrderSummaryData({
    required this.summary,
    required this.metrics,
  });
}

class OrderSummary {
  final int providerId;
  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;
  String currency;
  String currencySymbol;
  final num grossRevenue;
  final num realizedRevenue;
  final num netRevenue;
  final num lostRevenue;
  final num avgCompletedBasketSize;
  final num avgCancelledBasketSize;
  List<OrderSourceSummaries> orderSourceSummaries;
  final num discount;
  final num ordersPercentage;
  final num merchantDiscount;
  final num providerDiscount;

  OrderSummary({
    required this.providerId,
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.currency,
    required this.currencySymbol,
    required this.grossRevenue,
    required this.realizedRevenue,
    required this.netRevenue,
    required this.lostRevenue,
    required this.avgCompletedBasketSize,
    required this.avgCancelledBasketSize,
    required this.orderSourceSummaries,
    required this.discount,
    required this.ordersPercentage,
    required this.merchantDiscount,
    required this.providerDiscount,
  });
}

class OrderSourceSummaries {
  final int providerId;
  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;
  final String currency;
  final String currencySymbol;
  final num grossRevenue;
  final num realizedRevenue;
  final num netRevenue;
  final num lostRevenue;
  final num avgCompletedBasketSize;
  final num avgCancelledBasketSize;
  final String orderSource;
  final num discount;
  final num ordersPercentage;
  final num merchantDiscount;
  final num providerDiscount;

  OrderSourceSummaries({
    required this.providerId,
    required this.totalOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.currency,
    required this.currencySymbol,
    required this.grossRevenue,
    required this.realizedRevenue,
    required this.netRevenue,
    required this.lostRevenue,
    required this.avgCompletedBasketSize,
    required this.avgCancelledBasketSize,
    required this.orderSource,
    required this.discount,
    required this.ordersPercentage,
    required this.merchantDiscount,
    required this.providerDiscount,
  });
}

class Metrics {
  final List<int> activeBrandIds;
  final List<int> activeBranchIds;
  final List<int> activeProviderIds;

  Metrics({
    required this.activeBrandIds,
    required this.activeBranchIds,
    required this.activeProviderIds,
  });
}
