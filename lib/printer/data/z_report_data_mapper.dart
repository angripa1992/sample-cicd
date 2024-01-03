import 'package:docket_design_template/model/z_report_data.dart';
import 'package:intl/intl.dart';
import 'package:klikit/core/utils/price_calculator.dart';

import '../../app/constants.dart';
import '../../app/di.dart';
import '../../modules/common/business_information_provider.dart';
import '../../modules/home/data/model/z_report_data_model.dart';

class ZReportCurrency {
  final String code;
  final String symbol;

  ZReportCurrency(this.code, this.symbol);
}

class ZReportDataProvider {
  static final _instance = ZReportDataProvider._internal();

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

  Future<ZReportCurrency> _currency(OrderSummary? orderSummary) async {
    if (orderSummary != null && orderSummary.summary != null) {
      if (orderSummary.summary!.isNotEmpty) {
        final summary = orderSummary.summary!.first;
        return ZReportCurrency(summary.currency!, summary.currencySymbol!);
      }
    }
    final branchInfo = await getIt.get<BusinessInformationProvider>().branchInfo();
    if (branchInfo != null) {
      return ZReportCurrency(branchInfo.currencyCode, branchInfo.currencySymbol);
    }
    return ZReportCurrency('USD', '\$');
  }

  Future<TemplateZReport> generateTemplateData(ZReportData dataModel, DateTime reportTime) async {
    final currency = await _currency(dataModel.orderSummary);
    final salesSummary = await _templateSalesSummary(dataModel.orderSummary, currency);
    final brandSummary = await _templateBrandSummary(dataModel.orderSummary, currency);
    final itemSummary = await _templateItemAndModifierSummary(dataModel.itemSummary, currency);
    final itemModifierSummary = await _templateItemAndModifierSummary(dataModel.modifierItemSummary, currency);
    final paymentMethodSummary = await _templatePaymentMethodSummary(dataModel.paymentSummary!, currency);
    final paymentChannelSummary = await _templatePaymentChannelSummary(dataModel.paymentSummary!, currency);
    return TemplateZReport(
      generatedDate: DateFormat('MMMM dd yyyy, hh:mm aaa').format(DateTime.now().toLocal()).toString(),
      reportDate: DateFormat('MMMM dd, yyyy').format(reportTime).toString(),
      salesSummary: salesSummary,
      itemSummary: itemSummary,
      modifierItemSummary: itemModifierSummary,
      paymentMethodSummary: paymentMethodSummary,
      paymentChannelSummary: paymentChannelSummary,
      brandSummary: brandSummary,
    );
  }

  Future<TemplateSalesSummary> _templateSalesSummary(OrderSummary? orderSummary, ZReportCurrency currency) async {
    final summaries = <TemplateSummaryItem>[];
    num totalSales = 0;
    num discount = 0;
    num netSales = 0;
    for (var summary in orderSummary?.summary ?? <OrderSummaryItem>[]) {
      totalSales += summary.realizedRevenue ?? 0;
      discount += summary.discount ?? 0;
      netSales += summary.netRevenue ?? 0;
      if (summary.providerId! == ProviderID.KLIKIT) {
        for (var source in summary.orderSourceSummaries ?? <OrderSourceSummaries>[]) {
          String name = 'Klikit Webshop';
          if (source.orderSource == 'm') {
            name = 'Klikit Add Order';
          }
          summaries.add(
            TemplateSummaryItem(
              name: name,
              amount: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: source.realizedRevenue ?? 0),
            ),
          );
        }
      } else {
        final provider = await getIt.get<BusinessInformationProvider>().findProviderById(summary.providerId!);
        summaries.add(
          TemplateSummaryItem(
            name: provider.title,
            amount: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: summary.realizedRevenue ?? 0),
          ),
        );
      }
    }
    return TemplateSalesSummary(
      totalSales: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: totalSales),
      discount: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: discount),
      netSales: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: netSales),
      summaries: summaries,
    );
  }

  Future<TemplateBrandSummary> _templateBrandSummary(OrderSummary? orderSummary, ZReportCurrency currency) async {
    final summaries = <TemplateSummaryItem>[];
    num totalSales = 0;
    num discount = 0;
    num netSales = 0;
    for (var summary in orderSummary?.brandOrderSummary ?? <BrandOrderSummary>[]) {
      final brand = await getIt.get<BusinessInformationProvider>().findBrandById(summary.brandId!);
      totalSales += summary.realizedRevenue ?? 0;
      discount += summary.discount ?? 0;
      netSales += summary.netRevenue ?? 0;
      summaries.add(
        TemplateSummaryItem(
          name: brand?.title ?? '',
          amount: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: summary.realizedRevenue ?? 0),
        ),
      );
    }
    return TemplateBrandSummary(
      totalSales: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: totalSales),
      discount: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: discount),
      netSales: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: netSales),
      summaries: summaries,
    );
  }

  Future<TemplateItemSummary> _templateItemAndModifierSummary(ItemAndModifierSummary? summaryModel, ZReportCurrency currency) async {
    final summaries = <TemplateSummaryItem>[];
    num totalSales = 0;
    for (var summary in summaryModel?.summary ?? <ItemSummaryItem>[]) {
      totalSales += summary.revenue ?? 0;
      summaries.add(
        TemplateSummaryItem(
          name: summary.title ?? '',
          quantity: summary.quantity ?? 0,
          amount: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: summary.revenue ?? 0),
        ),
      );
    }
    return TemplateItemSummary(
      totalSales: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: totalSales),
      summaries: summaries,
    );
  }

  Future<TemplatePaymentMethodSummary> _templatePaymentMethodSummary(PaymentSummary paymentSummary, ZReportCurrency currency) async {
    final methodSummaries = <TemplateSummaryItem>[];
    num totalSales = 0;
    num discount = 0;
    num netSales = 0;
    for (var methodSummary in paymentSummary.summary ?? <PaymentSummaryItem>[]) {
      totalSales += methodSummary.grossRevenue ?? 0;
      discount += methodSummary.discount ?? 0;
      netSales += methodSummary.netRevenue ?? 0;
      methodSummaries.add(
        TemplateSummaryItem(
          name: methodSummary.paymentMethod ?? '',
          amount: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: methodSummary.grossRevenue ?? 0),
        ),
      );
    }
    return TemplatePaymentMethodSummary(
      totalSales: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: totalSales),
      discount: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: discount),
      netSales: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: netSales),
      summaries: methodSummaries,
    );
  }

  Future<TemplatePaymentChannelSummary> _templatePaymentChannelSummary(
    PaymentSummary summaryModel,
    ZReportCurrency currency,
  ) async {
    final channelSummaries = <TemplateSummaryItem>[];
    num totalSales = 0;
    num discount = 0;
    num netSales = 0;
    for (var methodSummary in summaryModel.summary ?? <PaymentSummaryItem>[]) {
      for (var channelSummary in methodSummary.channelAnalytics ?? <PaymentChannelItem>[]) {
        totalSales += channelSummary.grossRevenue ?? 0;
        discount += channelSummary.discount ?? 0;
        netSales += channelSummary.netRevenue ?? 0;
        channelSummaries.add(
          TemplateSummaryItem(
            name: channelSummary.paymentChannel ?? '',
            amount: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: channelSummary.grossRevenue ?? 0),
          ),
        );
      }
    }
    return TemplatePaymentChannelSummary(
      totalSales: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: totalSales),
      discount: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: discount),
      netSales: _convertPrice(code: currency.code, symbol: currency.symbol, priceInCent: netSales),
      summaries: channelSummaries,
    );
  }
}
