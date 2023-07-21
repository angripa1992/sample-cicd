import 'package:dio/dio.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../app/constants.dart';
import '../../../app/session_manager.dart';
import 'order_information_provider.dart';

class OrderParameterProvider {
  final OrderInformationProvider _informationProvider;

  OrderParameterProvider(this._informationProvider);

  Future<Map<String, dynamic>> getAllOrderParams(
    List<int>? brandsID,
    List<int>? providersID, {
    int? page,
    int? pageSize,
  }) async {
    final status = [
      OrderStatus.PLACED,
      OrderStatus.ACCEPTED,
      OrderStatus.READY,
      OrderStatus.SCHEDULED,
      OrderStatus.DRIVER_ARRIVED,
      OrderStatus.DRIVER_ASSIGNED,
      OrderStatus.PICKED_UP,
    ];
    return _getParams(
      brandsID,
      providersID,
      status,
      pageSize: pageSize,
      page: page,
    );
  }

  Future<Map<String, dynamic>> getNewOrderParams(
    List<int>? brandsID,
    List<int>? providersID, {
    int? page,
    int? pageSize,
  }) async {
    final status = [OrderStatus.PLACED, OrderStatus.ACCEPTED];
    return _getParams(
      brandsID,
      providersID,
      status,
      pageSize: pageSize,
      page: page,
    );
  }

  Future<Map<String, dynamic>> getScheduleOrderParams(
    List<int>? brandsID,
    List<int>? providersID, {
    int? page,
    int? pageSize,
  }) async {
    final status = [OrderStatus.SCHEDULED];
    return _getParams(
      brandsID,
      providersID,
      status,
      pageSize: pageSize,
      page: page,
    );
  }

  Future<Map<String, dynamic>> getOrderHistoryParam({
    int? page,
    int? pageSize,
    List<int>? brandsID,
    List<int>? providersID,
    List<int>? status,
  }) async {
    return _getParams(
      brandsID,
      providersID,
      status,
      pageSize: pageSize,
      page: page,
    );
  }

  Future<Map<String, dynamic>> getOngoingOrderParams(
    List<int>? brandsID,
    List<int>? providersID, {
    int? page,
    int? pageSize,
  }) async {
    final status = [OrderStatus.READY];
    return _getParams(
      brandsID,
      providersID,
      status,
      pageSize: pageSize,
      page: page,
    );
  }

  Future<Map<String, dynamic>> getOthersOrderParams(
    List<int>? brandsID,
    List<int>? providersID, {
    int? page,
    int? pageSize,
  }) async {
    final status = [
      OrderStatus.DRIVER_ASSIGNED,
      OrderStatus.DRIVER_ARRIVED,
      OrderStatus.PICKED_UP,
    ];
    return _getParams(
      brandsID,
      providersID,
      status,
      pageSize: pageSize,
      page: page,
    );
  }

  Future<Map<String, dynamic>> _getParams(
    List<int>? brandsID,
    List<int>? providersID,
    List<int>? status, {
    int? page,
    int? pageSize,
  }) async {
    final brands = brandsID ?? await _informationProvider.findBrandsIds();
    final providers =
        providersID ?? await _informationProvider.findProvidersIds();
    final branch = SessionManager().currentUserBranchId();
    final params = {
      "page": page ?? 1,
      "size": pageSize ?? 10,
      "filterByBranch": branch,
      "filterByBrand": ListParam<int>(brands, ListFormat.csv),
      "filterByProvider": ListParam<int>(providers, ListFormat.csv),
      "filterByStatus": ListParam<int>(status ?? [], ListFormat.csv),
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
      if (((provider == ProviderID.FOOD_PANDA && order.isFoodpandaApiOrder) ||
              provider == ProviderID.GRAB_FOOD) &&
          order.type == OrderType.PICKUP) {
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
