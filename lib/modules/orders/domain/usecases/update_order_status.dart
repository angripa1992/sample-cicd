import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

class UpdateOrderStatus extends UseCase<ActionSuccess, Map<String, dynamic>> {
  final OrderRepository _orderRepository;

  UpdateOrderStatus(this._orderRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(Map<String, dynamic> params) {
    return _orderRepository.updateStatus(params);
  }
}
