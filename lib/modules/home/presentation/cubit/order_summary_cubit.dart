import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/core/utils/price_calculator.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/core/widgets/filter/filtered_data_mapper.dart';
import 'package:klikit/modules/home/domain/entities/order_summary_overview.dart';
import 'package:klikit/modules/home/domain/entities/summary_data.dart';
import 'package:klikit/modules/home/domain/repository/home_repository.dart';
import 'package:klikit/resources/strings.dart';

class OrderSummaryCubit extends Cubit<ResponseState> {
  final HomeRepository _repository;

  OrderSummaryCubit(this._repository) : super(Empty());

  void fetchOrderSummaryData(HomeFilteredData? data) async {
    emit(Loading());
    final params = await FilteredDataMapper().homeFilterDataMap(data);
    final response = await _repository.fetchSummary(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (data) {
        final overviewData = _summaryOverview(data);
        emit(Success<List<OrderSummaryOverview>>(overviewData));
      },
    );
  }

  List<OrderSummaryOverview> _summaryOverview(OrderSummaryData data) {
    int completed = 0;
    int cancelled = 0;
    num grossValues = 0;
    num discount = 0;
    num netRevenue = 0;
    num lostRevenue = 0;
    String currency = '';
    String currencySymbol = '';
    for (var summary in data.summary) {
      completed += summary.completedOrders;
      cancelled += summary.cancelledOrders;
      grossValues += summary.realizedRevenue;
      discount += summary.discount;
      netRevenue += summary.netRevenue;
      lostRevenue += summary.lostRevenue;
      currency = summary.currency;
      currencySymbol = summary.currencySymbol;
    }
    return [
      OrderSummaryOverview(
        label: AppStrings.completed_orders.tr(),
        value: completed.toString(),
        tooltipMessage: AppStrings.completed_orders_tooltip.tr(),
        comparisonData: data.metrics.orderComparison.completedOrders,
      ),
      OrderSummaryOverview(
        label: AppStrings.cancelled_orders.tr(),
        value: cancelled.toString(),
        tooltipMessage: AppStrings.cancelled_orders_tooltip.tr(),
        comparisonData: data.metrics.orderComparison.cancelledOrders,
      ),
      OrderSummaryOverview(
        label: AppStrings.gross_order_value.tr(),
        value: PriceCalculator.formatCompactPrice(price: grossValues / 100, code: currency, symbol: currencySymbol),
        tooltipMessage: AppStrings.gross_order_value_tooltip.tr(),
        comparisonData: data.metrics.orderComparison.realizedRevenue,
      ),
      OrderSummaryOverview(
        label: AppStrings.discount_value.tr(),
        value: PriceCalculator.formatCompactPrice(price: discount / 100, code: currency, symbol: currencySymbol),
        tooltipMessage: AppStrings.discount_value_tooltip.tr(),
        comparisonData: data.metrics.orderComparison.discount,
      ),
      if (UserPermissionManager().isBizOwner())
        OrderSummaryOverview(
          label: AppStrings.net_order_value.tr(),
          value: PriceCalculator.formatCompactPrice(price: netRevenue / 100, code: currency, symbol: currencySymbol),
          tooltipMessage: AppStrings.net_order_value_tooltip.tr(),
          comparisonData: data.metrics.orderComparison.netRevenue,
        ),
      if (UserPermissionManager().isBizOwner())
        OrderSummaryOverview(
          label: AppStrings.lost_revenue.tr(),
          value: PriceCalculator.formatCompactPrice(price: lostRevenue / 100, code: currency, symbol: currencySymbol),
          tooltipMessage: AppStrings.lost_revenue_tooltip.tr(),
          comparisonData: data.metrics.orderComparison.lostRevenue,
        )
    ];
  }
}
