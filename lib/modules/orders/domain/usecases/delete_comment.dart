import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

class DeleteComment extends UseCase<ActionSuccess, int> {
  final OrderRepository _orderRepository;

  DeleteComment(this._orderRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(int params) {
    return _orderRepository.deleteComment(params);
  }
}
