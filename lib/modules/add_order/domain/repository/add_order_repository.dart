import 'package:dartz/dartz.dart';

import '../../../../core/network/error_handler.dart';
import '../../../menu/domain/entities/menues.dart';
import '../../data/models/billing_request.dart';
import '../entities/billing_response.dart';
import '../entities/item_modifier_group.dart';
import '../entities/order_source.dart';

abstract class AddOrderRepository {
  Future<Either<Failure, MenusData>> fetchMenus(
      {required int branchId, required int brandId});

  Future<Either<Failure, List<ItemModifierGroup>>> fetchModifiers(
      {required int itemId});

  Future<Either<Failure, CartBill>> calculateBill(
      {required BillingRequestModel model});

  Future<Either<Failure, List<AddOrderSourceType>>> fetchSources();
}
