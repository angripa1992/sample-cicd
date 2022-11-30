import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/menu/domain/entities/stock.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';

class UpdateItemParam {
  final int itemId;
  final int branchId;
  final int brandId;
  final int duration;
  final bool enabled;
  final int timeZoneOffset;

  UpdateItemParam({
    required this.itemId,
    required this.branchId,
    required this.brandId,
    required this.duration,
    required this.enabled,
    required this.timeZoneOffset,
  });
}

class UpdateItem extends UseCase<Stock, UpdateItemParam> {
  final MenuRepository _repository;

  UpdateItem(this._repository);
  @override
  Future<Either<Failure, Stock>> call(UpdateItemParam params) {
    return _repository.updateItem(params);
  }
}