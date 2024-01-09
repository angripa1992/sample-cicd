import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/price_calculator.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/core/widgets/filter/filtered_data_mapper.dart';
import 'package:klikit/modules/home/domain/entities/order_summary_overview.dart';
import 'package:klikit/modules/home/domain/entities/summary_data.dart';
import 'package:klikit/modules/home/domain/repository/home_repository.dart';

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
        emit(Success<OrderSummaryOverview>(overviewData));
      },
    );
  }

  OrderSummaryOverview _summaryOverview(OrderSummaryData data) {
    int completed = 0;
    int cancelled = 0;
    num grossValues = 0;
    num discount = 0;
    String currency = '';
    String currencySymbol = '';
    for (var summary in data.summary) {
      completed += summary.completedOrders;
      cancelled += summary.cancelledOrders;
      grossValues += summary.realizedRevenue;
      discount += summary.discount;
      currency = summary.currency;
      currencySymbol = summary.currencySymbol;
    }
    return OrderSummaryOverview(
      completedOrders: completed,
      cancelledOrders: cancelled,
      grossOrderValues: PriceCalculator.formatPrice(price: grossValues, code: currency, symbol: currencySymbol),
      discountValues: PriceCalculator.formatPrice(price: discount, code: currency, symbol: currencySymbol),
    );
  }
}
