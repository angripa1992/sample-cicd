import 'package:docket_design_template/model/z_report_data.dart';
import 'package:klikit/core/utils/price_calculator.dart';

import '../../app/constants.dart';
import '../../app/di.dart';
import '../../modules/home/data/model/z_report_data_model.dart';
import '../../modules/orders/provider/order_information_provider.dart';

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
      currencySymbol: symbol,
      code: code,
    );
  }

  Future<TemplateZReport> generateTemplateData(
    ZReportDataModel dataModel,
  ) async {
    final providerSummary =
        await _templateProviderSummary(dataModel.orderSummary);
    final itemSummary = await _templateItemSummary(dataModel.itemSummary);
    final paymentMethodSummary =
        await _templatePaymentMethodSummary(dataModel.paymentSummary!);
    final paymentChannelSummary =
        await _templatePaymentChannelSummary(dataModel.paymentSummary!);
    return TemplateZReport(
      generatedDate: dataModel.createdAt ?? '',
      providerSummary: providerSummary,
      itemSummary: itemSummary,
      paymentMethodSummary: paymentMethodSummary,
      paymentChannelSummary: paymentChannelSummary,
    );
  }

  Future<TemplateProviderSummary> _templateProviderSummary(
    OrderSummaryModel? orderSummaryModel,
  ) async {
    final response = await _providerSummaryItems(orderSummaryModel!.summary);
    return TemplateProviderSummary(
      lastRefreshedTime: orderSummaryModel.lastRefreshedAt ?? '',
      totalSales: response[_total],
      summaries: response[_summaries],
    );
  }

  Future<Map<String, dynamic>> _providerSummaryItems(
    List<OrderSummaryItemModel>? summaries,
  ) async {
    final providerSummaries = <TemplateSummaryItem>[];
    num totalSales = 0;
    String code = 'USD';
    String symbol = '\$';

    for (var providerSummary in summaries!) {
      totalSales += providerSummary.grossRevenue!;
      code = providerSummary.currency!;
      symbol = providerSummary.currencySymbol!;

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
                code: klikitProvider.currency!,
                symbol: klikitProvider.currencySymbol!,
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
              code: providerSummary.currency!,
              symbol: providerSummary.currencySymbol!,
              priceInCent: providerSummary.grossRevenue!,
            ),
          ),
        );
      }
    }

    return {
      _total: _convertPrice(
        code: code,
        symbol: symbol,
        priceInCent: totalSales,
      ),
      _summaries: providerSummaries,
    };
  }

  Future<TemplateItemSummary> _templateItemSummary(
    ItemSummaryModel? summaryModel,
  ) async {
    final response = await _itemSummaries(summaryModel!.summary);
    return TemplateItemSummary(
      lastRefreshedTime: summaryModel.lastRefreshedAt ?? '',
      totalSales: response[_total],
      summaries: response[_summaries],
    );
  }

  Future<Map<String, dynamic>> _itemSummaries(
    List<ItemSummaryItemModel>? summaries,
  ) async {
    final itemSummaries = <TemplateSummaryItem>[];
    num totalSales = 0;

    for (var itemSummary in summaries!) {
      totalSales += itemSummary.revenueUsd!;
      itemSummaries.add(
        TemplateSummaryItem(
          name: itemSummary.title!,
          quantity: itemSummary.quantity!,
          amount: _convertPrice(
            code: 'USD',
            symbol: '\$',
            priceInCent: itemSummary.revenueUsd!,
          ),
        ),
      );
    }

    return {
      _total: _convertPrice(
        code: 'USD',
        symbol: '\$',
        priceInCent: totalSales,
      ),
      _summaries: itemSummaries,
    };
  }

  Future<TemplatePaymentMethodSummary> _templatePaymentMethodSummary(
    PaymentSummaryModel summaryModel,
  ) async {
    final response = await _paymentMethodSummaries(summaryModel.summary);
    return TemplatePaymentMethodSummary(
      lastRefreshedTime: summaryModel.lastRefreshedAt ?? '',
      totalSales: response[_total],
      summaries: response[_summaries],
    );
  }

  Future<Map<String, dynamic>> _paymentMethodSummaries(
    List<PaymentSummaryItemModel>? summaries,
  ) async {
    final methodSummaries = <TemplateSummaryItem>[];
    num totalSales = 0;
    String code = 'USD';
    String symbol = '\$';

    for (var methodSummary in summaries!) {
      totalSales += methodSummary.grossRevenue!;
      code = methodSummary.currency!;
      symbol = methodSummary.currencySymbol!;

      methodSummaries.add(
        TemplateSummaryItem(
          name: methodSummary.paymentMethod!,
          amount: _convertPrice(
            code: methodSummary.currency!,
            symbol: methodSummary.currencySymbol!,
            priceInCent: methodSummary.grossRevenue!,
          ),
        ),
      );
    }

    return {
      _total: _convertPrice(
        code: code,
        symbol: symbol,
        priceInCent: totalSales,
      ),
      _summaries: methodSummaries,
    };
  }

  Future<TemplatePaymentChannelSummary> _templatePaymentChannelSummary(
    PaymentSummaryModel summaryModel,
  ) async {
    final response = await _paymentChannelSummaries(summaryModel.summary);
    return TemplatePaymentChannelSummary(
      lastRefreshedTime: summaryModel.lastRefreshedAt ?? '',
      totalSales: response[_total],
      summaries: response[_summaries],
    );
  }

  Future<Map<String, dynamic>> _paymentChannelSummaries(
    List<PaymentSummaryItemModel>? summaries,
  ) async {
    final channelSummaries = <TemplateSummaryItem>[];
    num totalSales = 0;
    String code = 'USD';
    String symbol = '\$';

    for (var methodSummary in summaries!) {
      for (var channelSummary in methodSummary.channelAnalytics!) {
        totalSales += channelSummary.grossRevenue!;
        code = channelSummary.currency!;
        symbol = channelSummary.currencySymbol!;

        channelSummaries.add(
          TemplateSummaryItem(
            name: channelSummary.paymentChannel!,
            amount: _convertPrice(
              code: channelSummary.currency!,
              symbol: channelSummary.currencySymbol!,
              priceInCent: channelSummary.grossRevenue!,
            ),
          ),
        );
      }
    }
    return {
      _total: _convertPrice(
        code: code,
        symbol: symbol,
        priceInCent: totalSales,
      ),
      _summaries: channelSummaries,
    };
  }
}
