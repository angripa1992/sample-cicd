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
        metrics: metrics?.toEntity() ??
            Metrics(
              activeBrandIds: [],
              activeBranchIds: [],
              activeProviderIds: [],
              orderComparison: OrderComparison(
                totalOrders: TotalOrder(value: 0, status: ''),
                completedOrders: TotalOrder(value: 0, status: ''),
                cancelledOrders: TotalOrder(value: 0, status: ''),
                grossRevenue: TotalOrder(value: 0, status: ''),
                realizedRevenue: TotalOrder(value: 0, status: ''),
                netRevenue: TotalOrder(value: 0, status: ''),
                lostRevenue: TotalOrder(value: 0, status: ''),
                discount: TotalOrder(value: 0, status: ''),
              ),
            ),
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
  OrderComparisonModel? orderComparisonModel;

  MetricsModel({this.activeBrandIds, this.activeBranchIds, this.activeProviderIds, this.orderComparisonModel});

  MetricsModel.fromJson(Map<String, dynamic> json) {
    activeBrandIds = json['active_brand_ids'].cast<int>();
    activeBranchIds = json['active_branch_ids'].cast<int>();
    activeProviderIds = json['active_provider_ids'].cast<int>();
    orderComparisonModel = json['order_comparison'] != null ? OrderComparisonModel.fromJson(json['order_comparison']) : null;
  }

  Metrics toEntity() => Metrics(
    activeBrandIds: activeBrandIds?.map((e) => e.orZero()).toList() ?? [],
        activeBranchIds: activeBranchIds?.map((e) => e.orZero()).toList() ?? [],
        activeProviderIds: activeProviderIds?.map((e) => e.orZero()).toList() ?? [],
        orderComparison: orderComparisonModel?.toEntity() ??
            OrderComparison(
              totalOrders: TotalOrder(value: 0, status: ''),
              completedOrders: TotalOrder(value: 0, status: ''),
              cancelledOrders: TotalOrder(value: 0, status: ''),
              grossRevenue: TotalOrder(value: 0, status: ''),
              realizedRevenue: TotalOrder(value: 0, status: ''),
              netRevenue: TotalOrder(value: 0, status: ''),
              lostRevenue: TotalOrder(value: 0, status: ''),
              discount: TotalOrder(value: 0, status: ''),
            ),
      );
}

class OrderComparisonModel {
  TotalOrderModel? totalOrders;
  TotalOrderModel? completedOrders;
  TotalOrderModel? cancelledOrders;
  TotalOrderModel? grossRevenue;
  TotalOrderModel? realizedRevenue;
  TotalOrderModel? netRevenue;
  TotalOrderModel? lostRevenue;
  TotalOrderModel? discount;

  OrderComparisonModel({
    this.totalOrders,
    this.completedOrders,
    this.cancelledOrders,
    this.grossRevenue,
    this.realizedRevenue,
    this.netRevenue,
    this.lostRevenue,
    this.discount,
  });

  OrderComparisonModel.fromJson(Map<String, dynamic> json) {
    totalOrders = json['total_orders'] != null ? TotalOrderModel.fromJson(json['total_orders']) : null;
    completedOrders = json['completed_orders'] != null ? TotalOrderModel.fromJson(json['completed_orders']) : null;
    cancelledOrders = json['cancelled_orders'] != null ? TotalOrderModel.fromJson(json['cancelled_orders']) : null;
    grossRevenue = json['gross_revenue'] != null ? TotalOrderModel.fromJson(json['gross_revenue']) : null;
    realizedRevenue = json['realized_revenue'] != null ? TotalOrderModel.fromJson(json['realized_revenue']) : null;
    netRevenue = json['net_revenue'] != null ? TotalOrderModel.fromJson(json['net_revenue']) : null;
    lostRevenue = json['lost_revenue'] != null ? TotalOrderModel.fromJson(json['lost_revenue']) : null;
    discount = json['discount'] != null ? TotalOrderModel.fromJson(json['discount']) : null;
  }

  OrderComparison toEntity() => OrderComparison(
        totalOrders: totalOrders?.toEntity() ?? TotalOrder(value: 0, status: ''),
        completedOrders: completedOrders?.toEntity() ?? TotalOrder(value: 0, status: ''),
        cancelledOrders: cancelledOrders?.toEntity() ?? TotalOrder(value: 0, status: ''),
        grossRevenue: grossRevenue?.toEntity() ?? TotalOrder(value: 0, status: ''),
        realizedRevenue: realizedRevenue?.toEntity() ?? TotalOrder(value: 0, status: ''),
        netRevenue: netRevenue?.toEntity() ?? TotalOrder(value: 0, status: ''),
        lostRevenue: lostRevenue?.toEntity() ?? TotalOrder(value: 0, status: ''),
        discount: discount?.toEntity() ?? TotalOrder(value: 0, status: ''),
      );
}

class TotalOrderModel {
  num? value;
  String? status;

  TotalOrderModel({this.value, this.status});

  TotalOrderModel.fromJson(Map<String, dynamic> json) {
    value = json['value'];
    status = json['status'];
  }

  TotalOrder toEntity() => TotalOrder(value: value.orZero(), status: status.orEmpty());
}
