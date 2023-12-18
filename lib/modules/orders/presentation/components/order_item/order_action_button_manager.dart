import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../../../app/constants.dart';

class OrderActionButtonManager {
  static final _instance = OrderActionButtonManager._internal();

  factory OrderActionButtonManager() => _instance;

  OrderActionButtonManager._internal();

  bool canAccept(Order order) {
    if (order.isInterceptorOrder || order.status != OrderStatus.PLACED || order.providerId == ProviderID.GO_FOOD) {
      return false;
    } else {
      return true;
    }
  }

  bool canReject(Order order) {
    if (!UserPermissionManager().canCancelOrder() || order.isInterceptorOrder || order.providerId == ProviderID.GO_FOOD) {
      return false;
    } else if (order.status == OrderStatus.PLACED) {
      return true;
    } else if (order.providerId == ProviderID.KLIKIT && (order.status == OrderStatus.ACCEPTED || order.status == OrderStatus.READY)) {
      return true;
    } else {
      return false;
    }
  }

  bool canReady(Order order) {
    if (order.isInterceptorOrder) {
      return false;
    } else if (order.status == OrderStatus.ACCEPTED) {
      return true;
    } else {
      return false;
    }
  }

  bool canDelivery(Order order) {
    if (order.isInterceptorOrder || order.providerId == ProviderID.GO_FOOD || order.isThreePlOrder) {
      return false;
    } else if (order.providerId == ProviderID.KLIKIT && order.status == OrderStatus.READY) {
      return true;
    } else if (order.providerId == ProviderID.GRAB_FOOD && order.status == OrderStatus.READY && order.type == OrderType.PICKUP) {
      return true;
    } else if (order.providerId == ProviderID.FOOD_PANDA && order.status == OrderStatus.READY) {
      return true;
    } else if (order.providerId == ProviderID.WOLT && order.status == OrderStatus.READY && order.type == OrderType.PICKUP) {
      return true;
    } else if (order.providerId == ProviderID.DELIVEROO && order.status == OrderStatus.READY) {
      return true;
    } else if (order.providerId == ProviderID.UBER_EATS && order.status == OrderStatus.READY) {
      return true;
    } else {
      return false;
    }
  }

  bool canFindRider(Order order) {
    if (order.isInterceptorOrder) {
      return false;
    } else if ((order.status == OrderStatus.ACCEPTED || order.status == OrderStatus.READY) && order.isThreePlOrder && order.canFindFulfillmentRider) {
      return true;
    } else {
      return false;
    }
  }

  bool canTrackRider(Order order) {
    return (order.status != OrderStatus.CANCELLED && order.status != OrderStatus.DELIVERED && order.status != OrderStatus.PICKED_UP) && order.fulfillmentTrackingUrl.isNotEmpty;
  }

  bool canUpdateOrder(Order order) {
    final preConditionMatch = order.providerId == ProviderID.KLIKIT && (order.status == OrderStatus.ACCEPTED || order.status == OrderStatus.PLACED);
    if (order.isManualOrder && order.paymentChannel == PaymentChannelID.CREATE_QRIS && !order.canUpdate) {
      return false;
    } else if (preConditionMatch && order.isManualOrder) {
      return true;
    } else if (preConditionMatch && !order.isManualOrder && order.canUpdate) {
      return true;
    } else {
      return false;
    }
  }

  bool canPrint(Order order) {
    return order.status != OrderStatus.PLACED;
  }
}
