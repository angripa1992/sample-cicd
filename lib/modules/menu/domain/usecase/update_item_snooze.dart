import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/core/utils/usecase.dart';
import 'package:klikit/modules/menu/domain/repository/menu_repository.dart';

import '../entities/menu/menu_out_of_stock.dart';

class UpdateItemSnoozeParam {
  final int menuVersion;
  final int itemId;
  final int businessID;
  final int branchId;
  final int brandId;
  final int duration;
  final bool enabled;
  final int timeZoneOffset;

  UpdateItemSnoozeParam({
    required this.menuVersion,
    required this.itemId,
    required this.businessID,
    required this.branchId,
    required this.brandId,
    required this.duration,
    required this.enabled,
    required this.timeZoneOffset,
  });
}

class UpdateItemSnooze extends UseCase<MenuOutOfStock, UpdateItemSnoozeParam> {
  final MenuRepository _repository;

  UpdateItemSnooze(this._repository);

  @override
  Future<Either<Failure, MenuOutOfStock>> call(UpdateItemSnoozeParam params) {
    return _repository.updateItemSnooze(params);
  }
}
