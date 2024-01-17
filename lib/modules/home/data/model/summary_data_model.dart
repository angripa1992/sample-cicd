import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/home/domain/entities/summary_data.dart';

class OrderSummaryDataModel {
  List<OrderSummaryModel>? summary;
  MetricsModel? metrics;

  OrderSummaryDataModel({this.summary, this.metrics});

  OrderSummaryDataModel.fromJson(Map<String, dynamic> json) {
    if (json['summary'] != null) {
      summary = <OrderSummaryModel>[];
      json['summary'].forEach((v) {
        summary!.add(OrderSummaryModel.fromJson(v));
      });
    }
    metrics = json['metrics'] != null ? MetricsModel.fromJson(json['metrics']) : null;
  }

  OrderSummaryData toEntity() => OrderSummaryData(
        summary: summary?.map((e) => e.toEntity()).toList() ?? [],
        metrics: metrics?.toEntity() ?? Metrics(activeBrandIds: [], activeBranchIds: [], activeProviderIds: []),
      );
}

class OrderSummaryModel {
  int? providerId;
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
  List<OrderSourceSummariesModel>? orderSourceSummaries;
  num? discount;
  num? ordersPercentage;
  num? merchantDiscount;
  num? providerDiscount;

  OrderSummaryModel(
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
      this.orderSourceSummaries,
      this.discount,
      this.ordersPercentage,
      this.merchantDiscount,
      this.providerDiscount});

  OrderSummaryModel.fromJson(Map<String, dynamic> json) {
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

  OrderSummary toEntity() => OrderSummary(
        providerId: providerId.orZero(),
        totalOrders: totalOrders.orZero(),
        completedOrders: completedOrders.orZero(),
        cancelledOrders: cancelledOrders.orZero(),
        currency: currency.orEmpty(),
        currencySymbol: currencySymbol.orEmpty(),
        grossRevenue: grossRevenue.orZero(),
        realizedRevenue: realizedRevenue.orZero(),
        netRevenue: netRevenue.orZero(),
        lostRevenue: lostRevenue.orZero(),
        avgCompletedBasketSize: avgCompletedBasketSize.orZero(),
        avgCancelledBasketSize: avgCancelledBasketSize.orZero(),
        orderSourceSummaries: orderSourceSummaries?.map((e) => e.toEntity()).toList() ?? [],
        discount: discount.orZero(),
        ordersPercentage: ordersPercentage.orZero(),
        merchantDiscount: merchantDiscount.orZero(),
        providerDiscount: providerDiscount.orZero(),
      );
}

class OrderSourceSummariesModel {
  int? providerId;
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
  String? orderSource;
  num? discount;
  num? ordersPercentage;
  num? merchantDiscount;
  num? providerDiscount;

  OrderSourceSummariesModel(
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

  OrderSourceSummariesModel.fromJson(Map<String, dynamic> json) {
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

  OrderSourceSummaries toEntity() => OrderSourceSummaries(
        providerId: providerId.orZero(),
        totalOrders: totalOrders.orZero(),
        completedOrders: completedOrders.orZero(),
        cancelledOrders: cancelledOrders.orZero(),
        currency: currency.orEmpty(),
        currencySymbol: currencySymbol.orEmpty(),
        grossRevenue: grossRevenue.orZero(),
        realizedRevenue: realizedRevenue.orZero(),
        netRevenue: netRevenue.orZero(),
        lostRevenue: lostRevenue.orZero(),
        avgCompletedBasketSize: avgCompletedBasketSize.orZero(),
        avgCancelledBasketSize: avgCancelledBasketSize.orZero(),
        orderSource: orderSource.orEmpty(),
        discount: discount.orZero(),
        ordersPercentage: ordersPercentage.orZero(),
        merchantDiscount: merchantDiscount.orZero(),
        providerDiscount: providerDiscount.orZero(),
      );
}

class MetricsModel {
  List<int>? activeBrandIds;
  List<int>? activeBranchIds;
  List<int>? activeProviderIds;

  MetricsModel({this.activeBrandIds, this.activeBranchIds, this.activeProviderIds});

  MetricsModel.fromJson(Map<String, dynamic> json) {
    activeBrandIds = json['active_brand_ids'].cast<int>();
    activeBranchIds = json['active_branch_ids'].cast<int>();
    activeProviderIds = json['active_provider_ids'].cast<int>();
  }

  Metrics toEntity() => Metrics(
        activeBrandIds: activeBrandIds?.map((e) => e.orZero()).toList() ?? [],
        activeBranchIds: activeBranchIds?.map((e) => e.orZero()).toList() ?? [],
        activeProviderIds: activeProviderIds?.map((e) => e.orZero()).toList() ?? [],
      );
}
