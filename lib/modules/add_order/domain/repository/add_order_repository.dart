import 'package:dartz/dartz.dart';

import '../../../../core/network/error_handler.dart';
import '../../../menu/domain/entities/menues.dart';
import '../../data/models/applied_promo.dart';
import '../../data/models/billing_request.dart';
import '../../data/models/place_order_data.dart';
import '../../data/models/placed_order_response.dart';
import '../entities/billing_response.dart';
import '../entities/item_modifier_group.dart';
import '../entities/order_source.dart';

abstract class AddOrderRepository {
  Future<Either<Failure, MenusData>> fetchMenus({required int branchId, required int brandId});

  Future<Either<Failure, List<ItemModifierGroup>>> fetchModifiers({required int itemId});

  Future<Either<Failure, CartBill>> calculateBill({required BillingRequestModel model});

  Future<Either<Failure, PlacedOrderResponse>> placeOrder({required PlaceOrderDataModel body});

  Future<Either<Failure, List<AppliedPromo>>> fetchPromos(Map<String,dynamic> params);

  Future<List<AddOrderSourceType>> fetchSources();
}
