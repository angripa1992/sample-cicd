import 'package:dartz/dartz.dart';

import '../../../../core/network/error_handler.dart';
import '../../../menu/domain/entities/menues.dart';
import '../entities/item_modifier_group.dart';

abstract class AddOrderRepository {
  Future<Either<Failure, MenusData>> fetchMenus(
      {required int branchId, required int brandId});

  Future<Either<Failure, List<ItemModifierGroup>>> fetchModifiers(
      {required int itemId});
}
