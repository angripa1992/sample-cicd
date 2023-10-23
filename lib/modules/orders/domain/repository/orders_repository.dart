import 'package:dartz/dartz.dart';
import 'package:klikit/core/network/error_handler.dart';
import 'package:klikit/modules/orders/data/models/action_success_model.dart';
import 'package:klikit/modules/orders/data/models/order_status_model.dart';
import 'package:klikit/modules/orders/data/models/orders_model.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart' as order;
import 'package:klikit/modules/orders/domain/entities/settings.dart';

import '../../data/models/webshop_order_details_model.dart';
import '../../edit_order/grab_order_update_request_model.dart';
import '../entities/cancellation_reason.dart';

abstract class OrderRepository {
  Future<Either<Failure, List<OrderStatusModel>>> fetchOrderStatus();

  Future<Either<Failure, Settings>> fetchSettings(int id);

  Future<Either<Failure, order.Orders>> fetchOrder(Map<String, dynamic> params);

  Future<order.Order?> fetchOrderById(int id);

  Future<WebShopOrderDetailsModel?> fetchOmsOrderById(String externalID);

  Future<Either<Failure, ActionSuccess>> updateStatus(Map<String, dynamic> params);

  Future<Either<Failure, ActionSuccess>> updatePaymentInfo(Map<String, dynamic> params);

  Future<Either<Failure, ActionSuccess>> addComment(Map<String, dynamic> params, int orderID);

  Future<Either<Failure, ActionSuccess>> deleteComment(int orderID);

  Future<Either<Failure, ActionSuccess>> updateGrabOrder(GrabOrderUpdateRequestModel model);

  Future<Either<Failure, ActionSuccess>> findRider(int id);

  Future<Either<Failure, order.Order>> calculateGrabBill(OrderModel model);

  Future<Either<Failure, List<CancellationReason>>> fetchCancellationReason();

  Future<Either<Failure, ActionSuccess>> updatePrepTime(int orderID,Map<String, dynamic> params);
}
