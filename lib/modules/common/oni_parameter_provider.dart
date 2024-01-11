import 'package:dio/dio.dart';
import 'package:klikit/core/widgets/filter/filter_data.dart';
import 'package:klikit/core/widgets/filter/filtered_data_mapper.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../app/constants.dart';
import '../../core/provider/date_time_provider.dart';

class OniParameterProvider {
  static final _instance = OniParameterProvider._internal();

  factory OniParameterProvider() => _instance;

  OniParameterProvider._internal();

  Future<Map<String, dynamic>> allOrder({required OniFilteredData? filteredData, int? page, int? pageSize}) async {
    final status = [
      OrderStatus.PLACED,
      OrderStatus.ACCEPTED,
      OrderStatus.READY,
      OrderStatus.SCHEDULED,
      OrderStatus.DRIVER_ARRIVED,
      OrderStatus.DRIVER_ASSIGNED,
      OrderStatus.PICKED_UP,
    ];
    return _getParams(filteredData: filteredData, status: status, page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> newOrder({
    required OniFilteredData? filteredData,
    int? page,
    int? pageSize,
  }) async {
    final status = [OrderStatus.PLACED, OrderStatus.ACCEPTED];
    return _getParams(filteredData: filteredData, status: status, page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> scheduleOrder({
    required OniFilteredData? filteredData,
    int? page,
    int? pageSize,
  }) async {
    final status = [OrderStatus.SCHEDULED];
    return _getParams(filteredData: filteredData, status: status, page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> historyOrder({
    required OniFilteredData? filteredData,
    int? page,
    int? pageSize,
  }) async {
    final status = await FilteredDataMapper().extractStatusIDs(filteredData?.statuses);
    final params = await _getParams(filteredData: filteredData, status: status, page: page, pageSize: pageSize);
    final startDate = filteredData?.dateFilteredData?.dateTimeRange?.start ?? DateTime.now();
    final endDate = filteredData?.dateFilteredData?.dateTimeRange?.end ?? DateTime.now();
    params['start'] = DateTimeFormatter.getDate(startDate);
    params['end'] = DateTimeFormatter.getDate(endDate.add(const Duration(days: 1)));
    params['timezone'] = await DateTimeFormatter.timeZone();
    return params;
  }

  Future<Map<String, dynamic>> ongoingOrder({
    required OniFilteredData? filteredData,
    int? page,
    int? pageSize,
  }) async {
    final status = [OrderStatus.READY];
    return _getParams(filteredData: filteredData, status: status, page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> othersOrder({
    required OniFilteredData? filteredData,
    int? page,
    int? pageSize,
  }) async {
    final status = [
      OrderStatus.DRIVER_ASSIGNED,
      OrderStatus.DRIVER_ARRIVED,
      OrderStatus.PICKED_UP,
    ];
    return _getParams(filteredData: filteredData, status: status, page: page, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> _getParams({
    required OniFilteredData? filteredData,
    required List<int> status,
    int? page,
    int? pageSize,
  }) async {
    final brands = await FilteredDataMapper().extractBrandIDs(filteredData?.brands);
    final branches = await FilteredDataMapper().extractBranchIDs(filteredData?.branches);
    final providers = await FilteredDataMapper().extractProviderIDs(filteredData?.providers);
    final params = {
      "page": page ?? 1,
      "size": pageSize ?? 10,
      "filterByBranch": ListParam<int>(branches, ListFormat.csv),
      "filterByBrand": ListParam<int>(brands, ListFormat.csv),
      "filterByProvider": ListParam<int>(providers, ListFormat.csv),
      "filterByStatus": ListParam<int>(status, ListFormat.csv),
    };
    return params;
  }

  Map<String, dynamic> getOrderActionParams(Order order) {
    final orderStatus = order.status;
    final provider = order.providerId;
    late int status;
    if (orderStatus == OrderStatus.PLACED) {
      status = OrderStatus.ACCEPTED;
    } else if (orderStatus == OrderStatus.ACCEPTED) {
      status = OrderStatus.READY;
    } else if (orderStatus == OrderStatus.READY) {
      if (((provider == ProviderID.FOOD_PANDA && order.isFoodpandaApiOrder) || provider == ProviderID.GRAB_FOOD) && order.type == OrderType.PICKUP) {
        status = OrderStatus.PICKED_UP;
      } else {
        status = OrderStatus.DELIVERED;
      }
    } else {
      status = OrderStatus.DELIVERED;
    }
    return {
      'status': status,
      'id': order.id,
    };
  }
}
