import 'package:dio/dio.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../app/constants.dart';
import 'order_information_provider.dart';

class OrderParameterProvider {
  final OrderInformationProvider _informationProvider;

  OrderParameterProvider(this._informationProvider);

  Future<Map<String, dynamic>> getNewOrderParams(
    List<int>? brandsID,
    List<int>? providersID, {
    int? pageSize,
  }) async {
    final status = [OrderStatus.PLACED, OrderStatus.ACCEPTED];
    return _getParams(brandsID, providersID, status, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> getOrderHistoryParam({
    int? pageSize,
    List<int>? brandsID,
    List<int>? providersID,
    List<int>? status,
  }) async {
    return _getParams(brandsID, providersID, status, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> getOngoingOrderParams(
    List<int>? brandsID,
    List<int>? providersID, {
    int? pageSize,
  }) async {
    final status = [OrderStatus.READY];
    return _getParams(brandsID, providersID, status, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> _getParams(
    List<int>? brandsID,
    List<int>? providersID,
    List<int>? status, {
    int? pageSize,
  }) async {
    final brands = brandsID ?? await _informationProvider.findBrandsIds();
    final providers =
        providersID ?? await _informationProvider.findProvidersIds();
    final branch = await _informationProvider.findBranchId();
    return {
      "size": pageSize ?? 1,
      "filterByBranch": branch,
      "filterByBrand": ListParam<int>(brands, ListFormat.csv),
      "filterByProvider": ListParam<int>(providers, ListFormat.csv),
      "filterByStatus": ListParam<int>(status ?? [], ListFormat.csv),
    };
  }

  Map<String, dynamic> getOrderActionParams(Order order, bool willCancel) {
    final orderStatus = order.status;
    final provider = order.providerId;
    late int status;
    if (willCancel) {
      status = OrderStatus.CANCELLED;
    } else if (orderStatus == OrderStatus.PLACED) {
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
