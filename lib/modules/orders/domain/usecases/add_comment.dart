import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

class AddComment extends UseCase<ActionSuccess, AddCommentParams> {
  final OrderRepository _orderRepository;

  AddComment(this._orderRepository);

  @override
  Future<Either<Failure, ActionSuccess>> call(AddCommentParams params) {
    return _orderRepository.addComment(params.param, params.orderID);
  }
}

class AddCommentParams {
  final Map<String, dynamic> param;
  final int orderID;

  AddCommentParams(this.param, this.orderID);
}
