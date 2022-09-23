import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/orders/domain/entities/busy_mode.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

class CheckBusyMode extends UseCase<BusyModeGetResponse, Map<String, dynamic>> {
  final OrderRepository _orderRepository;

  CheckBusyMode(this._orderRepository);

  @override
  Future<Either<Failure, BusyModeGetResponse>> call(
      Map<String, dynamic> params) {
    return _orderRepository.isBusy(params);
  }
}
