import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/core/provider/date_time_provider.dart';
import 'package:klikit/core/utils/response_state.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../../app/session_manager.dart';
import '../../domain/usecases/fetch_yesterday_total_order.dart';
import '../../../common/business_information_provider.dart';

class YesterdayTotalOrderCubit extends Cubit<ResponseState> {
  final FetchYesterdayTotalOrders _fetchTotalOrders;
  final BusinessInformationProvider _informationProvider;

  YesterdayTotalOrderCubit(this._fetchTotalOrders, this._informationProvider)
      : super(Empty());

  void fetchTotalOrder() async {
    emit(Loading());
    final status = [
      OrderStatus.CANCELLED,
      OrderStatus.DELIVERED,
      OrderStatus.PICKED_UP
    ];
    final brands = await _informationProvider.fetchBrandsIds();
    final providers = await _informationProvider.findProvidersIds();
    final branch = SessionManager().branchId();
    final timeZone = await DateTimeFormatter.timeZone();
    final params = {
      "start": DateTimeFormatter.yesterday(),
      "end": DateTimeFormatter.today(),
      "timezone": timeZone,
      "filterByBranch": branch,
      "filterByBrand": ListParam<int>(brands, ListFormat.csv),
      "filterByProvider": ListParam<int>(providers, ListFormat.csv),
      "filterByStatus": ListParam<int>(status, ListFormat.csv),
    };
    final response = await _fetchTotalOrders(params);
    response.fold(
      (failure) {
        emit(Failed(failure));
      },
      (orders) {
        emit(Success<Orders>(orders));
      },
    );
  }
}
