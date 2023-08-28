import 'package:dartz/dartz.dart';

import '../../../../core/network/error_handler.dart';
import '../../../menu/domain/entities/menu/menu_branch_info.dart';
import '../../data/models/applied_promo.dart';
import '../../data/models/placed_order_response.dart';
import '../../data/models/request/billing_request.dart';
import '../../data/models/request/place_order_data_request.dart';
import '../entities/cart_bill.dart';
import '../entities/modifier/item_modifier_group.dart';
import '../entities/order_source.dart';

abstract class AddOrderRepository {
  Future<Either<Failure, List<MenuItemModifierGroup>>> fetchModifiers({
    required int itemId,
    required MenuBranchInfo branchInfo,
  });

  Future<Either<Failure, CartBill>> calculateBill(
      {required BillingRequestModel model});

  Future<Either<Failure, PlacedOrderResponse>> placeOrder(
      {required PlaceOrderDataRequestModel body});

  Future<Either<Failure, List<AppliedPromo>>> fetchPromos(
      Map<String, dynamic> params);

  Future<List<AddOrderSourceType>> fetchSources();
}
