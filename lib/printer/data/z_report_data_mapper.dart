import 'package:docket_design_template/model/z_report_data.dart';
import 'package:intl/intl.dart';
import 'package:klikit/core/utils/price_calculator.dart';

import '../../app/constants.dart';
import '../../app/di.dart';
import '../../modules/home/data/model/z_report_data_model.dart';
import '../../modules/orders/provider/order_information_provider.dart';

class ZReportCurrency {
  final String code;
  final String symbol;

  ZReportCurrency(this.code, this.symbol);
}

class ZReportDataProvider {
  static final _instance = ZReportDataProvider._internal();

  static const _total = "total_sales";
  static const _summaries = "summaries";

  factory ZReportDataProvider() => _instance;

  ZReportDataProvider._internal();

  String _convertPrice({
    required String code,
    required String symbol,
    required num priceInCent,
  }) {
    final price = priceInCent / 100;
    return PriceCalculator.formatPrice(
      price: price,
      symbol: symbol,
      code: code,
    );
  }

  ZReportCurrency _currency(OrderSummaryModel? orderSummary) {
    if (orderSummary != null && orderSummary.summary != null) {
      if (orderSummary.summary!.isNotEmpty) {
        final summary = orderSummary.summary!.first;
        return ZReportCurrency(summary.currency!, summary.currencySymbol!);
      }
    }
    return ZReportCurrency('USD', '\$');
  }

  Future<TemplateZReport> generateTemplateData(
    ZReportDataModel dataModel,
    DateTime reportTime,
  ) async {
    final currency = _currency(dataModel.orderSummary);
    final providerSummary = await _templateProviderSummary(
      dataModel.orderSummary,
      currency,
    );
    final itemSummary = await _templateItemSummary(
      dataModel.itemSummary,
      currency,
    );
    final paymentMethodSummary = await _templatePaymentMethodSummary(
      dataModel.paymentSummary!,
      currency,
    );
    final paymentChannelSummary = await _templatePaymentChannelSummary(
      dataModel.paymentSummary!,
      currency,
    );
    return TemplateZReport(
      generatedDate: DateFormat('MMMM dd yyyy, hh:mm aaa')
          .format(DateTime.now().toLocal())
          .toString(),
      reportDate: DateFormat('MMMM dd, yyyy').format(reportTime).toString(),
      providerSummary: providerSummary,
      itemSummary: itemSummary,
      paymentMethodSummary: paymentMethodSummary,
      paymentChannelSummary: paymentChannelSummary,
    );
  }

  Future<TemplateProviderSummary> _templateProviderSummary(
    OrderSummaryModel? orderSummaryModel,
    ZReportCurrency currency,
  ) async {
    final response = await _providerSummaryItems(
      orderSummaryModel!.summary,
      currency,
    );
    return TemplateProviderSummary(
      lastRefreshedTime: orderSummaryModel.lastRefreshedAt ?? '',
      totalSales: response[_total],
      summaries: response[_summaries],
    );
  }

  Future<Map<String, dynamic>> _providerSummaryItems(
    List<OrderSummaryItemModel>? summaries,
    ZReportCurrency currency,
  ) async {
    final providerSummaries = <TemplateSummaryItem>[];
    num totalSales = 0;
    for (var providerSummary in summaries!) {
      totalSales += providerSummary.grossRevenue!;
      if (providerSummary.providerId! == ProviderID.KLIKIT) {
        for (var klikitProvider in providerSummary.orderSourceSummaries!) {
          String name = 'Klikit Webshop';
          if (klikitProvider.orderSource == 'm') {
            name = 'Klikit Add Order';
          }
          providerSummaries.add(
            TemplateSummaryItem(
              name: name,
              amount: _convertPrice(
                code: currency.code,
                symbol: currency.symbol,
                priceInCent: klikitProvider.grossRevenue!,
              ),
            ),
          );
        }
      } else {
        final provider = await getIt
            .get<OrderInformationProvider>()
            .findProviderById(providerSummary.providerId!);
        providerSummaries.add(
          TemplateSummaryItem(
            name: provider.title,
            amount: _convertPrice(
              code: currency.code,
              symbol: currency.symbol,
              priceInCent: providerSummary.grossRevenue!,
            ),
          ),
        );
      }
    }
    return {
      _total: _convertPrice(
        code: currency.code,
        symbol: currency.symbol,
        priceInCent: totalSales,
      ),
      _summaries: providerSummaries,
    };
  }

  Future<TemplateItemSummary> _templateItemSummary(
    ItemSummaryModel? summaryModel,
    ZReportCurrency currency,
  ) async {
    final response = await _itemSummaries(
      summaryModel!.summary,
      currency,
    );
    return TemplateItemSummary(
      lastRefreshedTime: summaryModel.lastRefreshedAt ?? '',
      totalSales: response[_total],
      summaries: response[_summaries],
    );
  }

  Future<Map<String, dynamic>> _itemSummaries(
    List<ItemSummaryItemModel>? summaries,
    ZReportCurrency currency,
  ) async {
    final itemSummaries = <TemplateSummaryItem>[];
    num totalSales = 0;
    for (var itemSummary in summaries!) {
      totalSales += itemSummary.revenue!;
      itemSummaries.add(
        TemplateSummaryItem(
          name: itemSummary.title!,
          quantity: itemSummary.quantity!,
          amount: _convertPrice(
            code: currency.code,
            symbol: currency.symbol,
            priceInCent: itemSummary.revenue!,
          ),
        ),
      );
    }
    return {
      _total: _convertPrice(
        code: currency.code,
        symbol: currency.symbol,
        priceInCent: totalSales,
      ),
      _summaries: itemSummaries,
    };
  }

  Future<TemplatePaymentMethodSummary> _templatePaymentMethodSummary(
    PaymentSummaryModel summaryModel,
    ZReportCurrency currency,
  ) async {
    final response = await _paymentMethodSummaries(
      summaryModel.summary,
      currency,
    );
    return TemplatePaymentMethodSummary(
      lastRefreshedTime: summaryModel.lastRefreshedAt ?? '',
      totalSales: response[_total],
      summaries: response[_summaries],
    );
  }

  Future<Map<String, dynamic>> _paymentMethodSummaries(
    List<PaymentSummaryItemModel>? summaries,
    ZReportCurrency currency,
  ) async {
    final methodSummaries = <TemplateSummaryItem>[];
    num totalSales = 0;
    for (var methodSummary in summaries!) {
      totalSales += methodSummary.grossRevenue!;
      methodSummaries.add(
        TemplateSummaryItem(
          name: methodSummary.paymentMethod!,
          amount: _convertPrice(
            code: currency.code,
            symbol: currency.symbol,
            priceInCent: methodSummary.grossRevenue!,
          ),
        ),
      );
    }
    return {
      _total: _convertPrice(
        code: currency.code,
        symbol: currency.symbol,
        priceInCent: totalSales,
      ),
      _summaries: methodSummaries,
    };
  }

  Future<TemplatePaymentChannelSummary> _templatePaymentChannelSummary(
    PaymentSummaryModel summaryModel,
    ZReportCurrency currency,
  ) async {
    final response = await _paymentChannelSummaries(
      summaryModel.summary,
      currency,
    );
    return TemplatePaymentChannelSummary(
      lastRefreshedTime: summaryModel.lastRefreshedAt ?? '',
      totalSales: response[_total],
      summaries: response[_summaries],
    );
  }

  Future<Map<String, dynamic>> _paymentChannelSummaries(
    List<PaymentSummaryItemModel>? summaries,
    ZReportCurrency currency,
  ) async {
    final channelSummaries = <TemplateSummaryItem>[];
    num totalSales = 0;
    for (var methodSummary in summaries!) {
      for (var channelSummary in methodSummary.channelAnalytics!) {
        totalSales += channelSummary.grossRevenue!;
        channelSummaries.add(
          TemplateSummaryItem(
            name: channelSummary.paymentChannel!,
            amount: _convertPrice(
              code: currency.code,
              symbol: currency.symbol,
              priceInCent: channelSummary.grossRevenue!,
            ),
          ),
        );
      }
    }
    return {
      _total: _convertPrice(
        code: currency.code,
        symbol: currency.symbol,
        priceInCent: totalSales,
      ),
      _summaries: channelSummaries,
    };
  }
}
