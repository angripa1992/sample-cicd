import 'package:klikit/modules/orders/domain/entities/order.dart';

import '../../../../../app/constants.dart';

class OrderActionButtonManager {
  static final _instance = OrderActionButtonManager._internal();

  factory OrderActionButtonManager() => _instance;

  OrderActionButtonManager._internal();

  bool canAccept(Order order) {
    if (order.isInterceptorOrder || order.status != OrderStatus.PLACED) {
      return false;
    } else {
      return true;
    }
  }

  bool canReject(Order order) {
    if (order.isInterceptorOrder) {
      return false;
    } else if (order.providerId == ProviderID.GRAB_FOOD) {
      return false;
    } else if (order.providerId == ProviderID.FOOD_PANDA && order.status == OrderStatus.PLACED) {
      return true;
    } else if (order.providerId == ProviderID.WOLT && order.type == OrderType.DELIVERY) {
      return false;
    } else if (order.providerId == ProviderID.WOLT && order.type == OrderType.PICKUP && order.status == OrderStatus.PLACED) {
      return true;
    } else if (order.providerId == ProviderID.DELIVEROO && order.status == OrderStatus.PLACED) {
      return true;
    } else if (order.status == OrderStatus.PLACED || order.status == OrderStatus.ACCEPTED) {
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

  bool canPickedUp(Order order) {
    if (order.isInterceptorOrder || order.providerId == ProviderID.KLIKIT) {
      return false;
    } else if ((order.providerId == ProviderID.GRAB_FOOD || order.providerId == ProviderID.FOOD_PANDA) && order.type == OrderType.PICKUP && order.status == OrderStatus.READY) {
      return true;
    } else {
      return false;
    }
  }

  bool canDelivery(Order order) {
    if (order.isInterceptorOrder) {
      return false;
    } else if (order.providerId == ProviderID.KLIKIT && order.status == OrderStatus.READY) {
      return true;
    } else if ((order.providerId == ProviderID.FOOD_PANDA) && order.type != OrderType.PICKUP && order.status == OrderStatus.READY) {
      return true;
    } else if (order.providerId == ProviderID.WOLT && order.type == OrderType.PICKUP && order.status == OrderStatus.READY) {
      return true;
    } else {
      return false;
    }
  }

  bool canFindRider(Order order) {
    if (order.isInterceptorOrder) {
      return false;
    } else if (order.status == OrderStatus.ACCEPTED && order.isThreePlOrder && order.canFindFulfillmentRider) {
      return true;
    } else {
      return false;
    }
  }

  bool canUpdateOrder(Order order) {
    return order.providerId == ProviderID.KLIKIT && (order.status == OrderStatus.ACCEPTED || order.status == OrderStatus.PLACED) && order.canUpdate;
  }

  bool canPrint(Order order) {
    return order.status != OrderStatus.PLACED;
  }
}
