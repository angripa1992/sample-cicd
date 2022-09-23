import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

class FetchOngoingOrder extends UseCase<Orders, Map<String, dynamic>> {
  final OrderRepository _orderRepository;

  FetchOngoingOrder(this._orderRepository);

  @override
  Future<Either<Failure, Orders>> call(Map<String, dynamic> params) {
    return _orderRepository.fetchOrder(params);
  }
}
