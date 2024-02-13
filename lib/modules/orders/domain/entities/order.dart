import 'package:klikit/app/constants.dart';
import 'package:klikit/app/user_permission_manager.dart';
import 'package:klikit/modules/add_order/data/models/applied_promo.dart';
import 'package:klikit/modules/common/entities/brand.dart';
import 'package:klikit/modules/common/entities/source.dart';
import 'package:klikit/modules/orders/domain/entities/rider_info.dart';

import 'additional_info.dart';
import 'cart.dart';
import 'delicery_info.dart';

class Orders {
  final int total;
  final int page;
  final int size;
  final List<Order> data;

  Orders({
    required this.data,
    required this.total,
    required this.page,
    required this.size,
  });
}

class Order {
  final int id;
  final String externalId;
  final String shortId;
  final int providerId;
  final String brandName;
  final int branchId;
  final String paymentInvoiceId;
  final int status;
  final int itemPrice;
  final int finalPrice;
  final int discount;
  final int customerDiscount;
  final int merchantDiscount;
  final int providerDiscount;
  final int deliveryFee;
  final int additionalFee;
  final int gatewayFee;
  final int serviceFee;
  final double customFee;
  final int vat;
  final String currency;
  final String currencySymbol;
  final int itemCount;
  final int uniqueItemCount;
  final int scheduledStatus;
  final String scheduledTime;
  final String createdAt;
  final String updatedAt;
  final int userId;
  final String userFirstName;
  final String userLastName;
  final String userProfilePic;
  final String userPhone;
  final String userEmail;
  final List<CartBrand> brands;
  final List<CartV1> cartV1;
  final List<CartV2> cartV2;
  final String klikitStoreId;
  final int type;
  final bool isFake;
  final bool isFoodpandaApiOrder;
  final bool isInterceptorOrder;
  final String orderComment;
  final String deliveryComment;
  final String foodpandaToken;
  final bool isManualOrder;
  final int source;
  final bool autoAccept;
  final bool autoPilot;
  final int autoPilotTime;
  final OrderSource orderSource;
  final String tableNo;
  final String discountDisplay;
  final String additionalFeeDisplay;
  final String deliveryFeeDisplay;
  final String finalPriceDisplay;
  final String itemPriceDisplay;
  final String merchantDiscountDisplay;
  final String providerDiscountDisplay;
  final String vatDisplay;
  final int discountTYpe;
  final num discountValue;
  final String identity;
  final bool isMixAndMatchOrder;
  final String triggeredTime;
  final bool isVatIncluded;
  final bool isThreePlOrder;
  final String fulfillmentDeliveredTime;
  final String fulfillmentExpectedPickupTime;
  final String fulfillmentPickupPin;
  final RiderInfo? fulfillmentRider;
  final int fulfillmentStatusId;
  final String fulfillmentTrackingUrl;
  final int threePlDispatchType;
  final int restaurantServiceFee;
  final String estimatedPickUpAt;
  final OrderDeliveryInfo? deliveryInfo;
  final num providerSubTotal;
  final num providerGrandTotal;
  final num providerAdditionalFee;
  final AppliedPromoInfo? orderAppliedPromo;
  final List<AppliedPromoInfo> itemAppliedPromos;
  final List<AppliedPromoItem> promos;
  final String queueNo;
  final int pickupType;
  final AdditionalInfo? additionalInfo;
  final bool feePaidByCustomer;
  final num mergeFee;
  final num rewardDiscount;
  final num roundOffAmount;
  final num providerRoundOffAmount;
  final bool gatewayFeePaidByCustomer;
  final bool serviceFeePaidByCustomer;
  final int cancellationReasonId;
  final String cancellationReason;
  final bool canFindFulfillmentRider;
  final bool canCancelRider;
  final bool canCancel;
  final bool canAccept;
  final bool canReady;
  final bool canDeliver;
  bool canUpdate;
  num preparationTime;
  String klikitComment;
  int paymentMethod;
  int paymentChannel;
  int paymentStatus;

  Order({
    required this.id,
    required this.externalId,
    required this.shortId,
    required this.providerId,
    required this.brandName,
    required this.branchId,
    required this.paymentInvoiceId,
    required this.status,
    required this.itemPrice,
    required this.finalPrice,
    required this.discount,
    required this.customerDiscount,
    required this.merchantDiscount,
    required this.providerDiscount,
    required this.deliveryFee,
    required this.additionalFee,
    required this.gatewayFee,
    required this.serviceFee,
    required this.customFee,
    required this.vat,
    required this.currency,
    required this.currencySymbol,
    required this.itemCount,
    required this.uniqueItemCount,
    required this.scheduledStatus,
    required this.scheduledTime,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.userProfilePic,
    required this.userPhone,
    required this.userEmail,
    required this.brands,
    required this.cartV1,
    required this.cartV2,
    required this.klikitStoreId,
    required this.type,
    required this.isFake,
    required this.isFoodpandaApiOrder,
    required this.isInterceptorOrder,
    required this.orderComment,
    required this.deliveryComment,
    required this.foodpandaToken,
    required this.klikitComment,
    required this.isManualOrder,
    required this.source,
    required this.paymentMethod,
    required this.paymentChannel,
    required this.paymentStatus,
    required this.autoAccept,
    required this.autoPilot,
    required this.autoPilotTime,
    required this.orderSource,
    required this.tableNo,
    required this.discountDisplay,
    required this.additionalFeeDisplay,
    required this.deliveryFeeDisplay,
    required this.finalPriceDisplay,
    required this.itemPriceDisplay,
    required this.merchantDiscountDisplay,
    required this.providerDiscountDisplay,
    required this.vatDisplay,
    required this.discountTYpe,
    required this.discountValue,
    required this.identity,
    required this.isMixAndMatchOrder,
    required this.triggeredTime,
    required this.isVatIncluded,
    required this.isThreePlOrder,
    required this.fulfillmentDeliveredTime,
    required this.fulfillmentExpectedPickupTime,
    required this.fulfillmentPickupPin,
    required this.fulfillmentRider,
    required this.fulfillmentStatusId,
    required this.fulfillmentTrackingUrl,
    required this.canFindFulfillmentRider,
    required this.threePlDispatchType,
    required this.orderAppliedPromo,
    required this.itemAppliedPromos,
    required this.cancellationReasonId,
    required this.cancellationReason,
    required this.restaurantServiceFee,
    required this.promos,
    required this.estimatedPickUpAt,
    required this.deliveryInfo,
    required this.providerSubTotal,
    required this.providerGrandTotal,
    required this.providerAdditionalFee,
    required this.preparationTime,
    required this.queueNo,
    required this.pickupType,
    required this.additionalInfo,
    required this.canCancelRider,
    required this.feePaidByCustomer,
    required this.mergeFee,
    required this.rewardDiscount,
    required this.roundOffAmount,
    required this.providerRoundOffAmount,
    required this.gatewayFeePaidByCustomer,
    required this.serviceFeePaidByCustomer,
    required this.canUpdate,
    required this.canAccept,
    required this.canReady,
    required this.canCancel,
    required this.canDeliver,
  });

  bool canAcceptOrder() => canAccept;

  bool canCancelOrder() => UserPermissionManager().canCancelOrder() && canCancel;

  bool canReadyOrder() => canReady;

  bool canDeliveryOrder() => canDeliver;

  bool canFindRider() {
    if (isInterceptorOrder) {
      return false;
    } else if ((status == OrderStatus.ACCEPTED || status == OrderStatus.READY) && isThreePlOrder && canFindFulfillmentRider) {
      return true;
    } else {
      return false;
    }
  }

  bool canTrackRider() {
    return (status != OrderStatus.CANCELLED && status != OrderStatus.DELIVERED && status != OrderStatus.PICKED_UP) && fulfillmentTrackingUrl.isNotEmpty;
  }

  bool canUpdateOrder() {
    if (UserPermissionManager().isBizOwner()) {
      return false;
    } else if (isManualOrder && paymentChannel == PaymentChannelID.CREATE_QRIS && !canUpdate) {
      return false;
    } else {
      return canUpdate;
    }
  }

  bool canPrint() {
    return status != OrderStatus.PLACED && !UserPermissionManager().isBizOwner();
  }
}
