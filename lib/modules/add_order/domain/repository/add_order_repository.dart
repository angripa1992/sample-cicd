import 'package:dartz/dartz.dart';

import '../../../../core/network/error_handler.dart';
import '../../../menu/domain/entities/menu/menu_branch_info.dart';
import '../../data/models/applied_promo.dart';
import '../../data/models/placed_order_response.dart';
import '../../data/models/request/billing_request.dart';
import '../../data/models/request/place_order_data_request.dart';
import '../../data/models/request/webshop_calculate_bill_payload.dart';
import '../../data/models/request/webshop_pace_order_payload.dart';
import '../../data/models/update_webshop_order_response.dart';
import '../entities/cart_bill.dart';
import '../entities/modifier/item_modifier_group.dart';
import '../entities/order_source.dart';

abstract class AddOrderRepository {
  Future<Either<Failure, List<MenuItemModifierGroup>>> fetchModifiers({
    required int itemId,
    required int sectionID,
    required int categoryID,
    required MenuBranchInfo branchInfo,
    required int type,
  });

  Future<Either<Failure, CartBill>> calculateBill({required BillingRequestModel model});

  Future<Either<Failure, PlacedOrderResponse>> placeOrder({required PlaceOrderDataRequestModel body});

  Future<Either<Failure, CartBill>> webShopCalculateBill({required WebShopCalculateBillPayload payload});

  Future<Either<Failure, List<Promo>>> fetchPromos(Map<String, dynamic> params);

  Future<List<AddOrderSourceType>> fetchSources();

  Future<Either<Failure, UpdateWebShopOrderResponse>> updateWebShopOrder(int id, WebShopPlaceOrderPayload payload);
}
