import 'package:dio/dio.dart';

import '../../modules/orders/domain/entities/order_status.dart';
import 'order_information_provider.dart';

class OrderParameterProvider {
  final OrderInformationProvider _informationProvider;

  OrderParameterProvider(this._informationProvider);

  Future<Map<String, dynamic>> getNewOrderParams(
    List<int>? brandsID,
    List<int>? providersID, {
    int? pageSize,
  }) async {
    final status = await _informationProvider.getStatusByNames(
      [
        OrderStatusName.PLACED,
        OrderStatusName.ACCEPTED,
      ],
    );
    return _getParams(brandsID, providersID, status, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> getOrderHistoryParam(
    List<int>? brandsID,
    List<int>? providersID, {
    int? pageSize,
  }) async {
    final status = await _informationProvider.getStatusByNames(
      [
        OrderStatusName.CANCELLED,
        OrderStatusName.DELIVERED,
      ],
    );
    return _getParams(brandsID, providersID, status, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> getOngoingOrderParams(
    List<int>? brandsID,
    List<int>? providersID, {
    int? pageSize,
  }) async {
    final status = await _informationProvider.getStatusByNames(
      [
        OrderStatusName.READY,
      ],
    );
    return _getParams(brandsID, providersID, status, pageSize: pageSize);
  }

  Future<Map<String, dynamic>> _getParams(
    List<int>? brandsID,
    List<int>? providersID,
    List<int> status, {
    int? pageSize,
  }) async {
    final brands = brandsID ?? await _informationProvider.getBrandsIds();
    final providers =
        providersID ?? await _informationProvider.getProvidersIds();
    final branch = await _informationProvider.getBranchId();
    return {
      "size": pageSize ?? 1,
      "filterByBranch": branch,
      "filterByBrand": ListParam<int>(brands, ListFormat.csv),
      "filterByProvider": ListParam<int>(providers, ListFormat.csv),
      "filterByStatus": ListParam<int>(status, ListFormat.csv),
    };
  }
}
