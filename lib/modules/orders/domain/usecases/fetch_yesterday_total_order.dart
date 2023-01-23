import 'package:dartz/dartz.dart';

import '../../../../core/network/error_handler.dart';
import '../../../../core/utils/usecase.dart';
import '../entities/order.dart';
import '../repository/orders_repository.dart';

class FetchYesterdayTotalOrders extends UseCase<Orders, Map<String, dynamic>> {
  final OrderRepository _orderRepository;

  FetchYesterdayTotalOrders(this._orderRepository);

  @override
  Future<Either<Failure, Orders>> call(Map<String, dynamic> params) {
    return _orderRepository.fetchOrder(params);
  }
}
