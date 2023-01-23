import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';

import '../entities/busy_mode.dart';

class UpdateBusyModeStatus
    extends UseCase<BusyModePostResponse, Map<String, dynamic>> {
  final OrderRepository _orderRepository;

  UpdateBusyModeStatus(this._orderRepository);

  @override
  Future<Either<Failure, BusyModePostResponse>> call(
      Map<String, dynamic> params) {
    return _orderRepository.updateBusyMode(params);
  }
}
