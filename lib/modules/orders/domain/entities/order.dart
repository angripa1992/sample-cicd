import 'package:klikit/modules/orders/domain/entities/rider_info.dart';

import '../../../add_order/data/models/applied_promo.dart';
import '../../../common/entities/brand.dart';
import '../../../common/entities/source.dart';
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
  final int status;
  final int itemPrice;
  final int finalPrice;
  final int discount;
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
  final bool canMarkReady;
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
  final bool canFindFulfillmentRider;
  final bool canMarkAccept;
  final bool canMarkCancel;
  final int threePlDispatchType;
  final int cancellationReasonId;
  final String cancellationReason;
  final int restaurantServiceFee;
  final String estimatedPickUpAt;
  final OrderDeliveryInfo? deliveryInfo;
  final num providerSubTotal;
  final num providerGrandTotal;
  final num providerAdditionalFee;
  final AppliedPromoInfo? orderAppliedPromo;
  final List<AppliedPromoInfo> itemAppliedPromos;
  final List<AppliedPromoItem> appliedPromos;
  final String queueNo;
  final int pickupType;
  final AdditionalInfo? additionalInfo;
  final bool canCancelRider;
  final bool feePaidByCustomer;
  final num mergeFee;
  final num rewardDiscount;
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
    required this.status,
    required this.itemPrice,
    required this.finalPrice,
    required this.discount,
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
    required this.canUpdate,
    required this.canMarkReady,
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
    required this.canMarkCancel,
    required this.canMarkAccept,
    required this.threePlDispatchType,
    required this.orderAppliedPromo,
    required this.itemAppliedPromos,
    required this.cancellationReasonId,
    required this.cancellationReason,
    required this.restaurantServiceFee,
    required this.appliedPromos,
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
  });

  Order copy() => Order(
        id: id,
        externalId: externalId,
        shortId: shortId,
        providerId: providerId,
        brandName: brandName,
        branchId: branchId,
        status: status,
        itemPrice: itemPrice,
        finalPrice: finalPrice,
        discount: discount,
        merchantDiscount: merchantDiscount,
        providerDiscount: providerDiscount,
        deliveryFee: deliveryFee,
        additionalFee: additionalFee,
        gatewayFee: gatewayFee,
        serviceFee: serviceFee,
        customFee: customFee,
        vat: vat,
        currency: currency,
        currencySymbol: currencySymbol,
        itemCount: itemCount,
        uniqueItemCount: uniqueItemCount,
        scheduledStatus: scheduledStatus,
        scheduledTime: scheduledTime,
        createdAt: createdAt,
        updatedAt: updatedAt,
        userId: userId,
        userFirstName: userFirstName,
        userLastName: userLastName,
        userProfilePic: userProfilePic,
        userPhone: userPhone,
        userEmail: userEmail,
        brands: brands.map((e) => e.copy()).toList(),
        cartV1: cartV1.map((e) => e.copy()).toList(),
        cartV2: cartV2.map((e) => e.copy()).toList(),
        klikitStoreId: klikitStoreId,
        type: type,
        isFake: isFake,
        isFoodpandaApiOrder: isFoodpandaApiOrder,
        isInterceptorOrder: isInterceptorOrder,
        orderComment: orderComment,
        deliveryComment: deliveryComment,
        foodpandaToken: foodpandaToken,
        klikitComment: klikitComment,
        isManualOrder: isManualOrder,
        source: source,
        paymentMethod: paymentMethod,
        paymentChannel: paymentChannel,
        paymentStatus: paymentStatus,
        autoAccept: autoAccept,
        autoPilot: autoPilot,
        autoPilotTime: autoPilotTime,
        orderSource: orderSource.copy(),
        tableNo: tableNo,
        canUpdate: canUpdate,
        canMarkReady: canMarkReady,
        discountDisplay: discountDisplay,
        additionalFeeDisplay: additionalFeeDisplay,
        deliveryFeeDisplay: deliveryFeeDisplay,
        finalPriceDisplay: finalPriceDisplay,
        itemPriceDisplay: itemPriceDisplay,
        merchantDiscountDisplay: merchantDiscountDisplay,
        providerDiscountDisplay: providerDiscountDisplay,
        vatDisplay: vatDisplay,
        discountTYpe: discountTYpe,
        discountValue: discountValue,
        identity: identity,
        isMixAndMatchOrder: isMixAndMatchOrder,
        triggeredTime: triggeredTime,
        isVatIncluded: isVatIncluded,
        isThreePlOrder: isThreePlOrder,
        fulfillmentDeliveredTime: fulfillmentDeliveredTime,
        fulfillmentExpectedPickupTime: fulfillmentExpectedPickupTime,
        fulfillmentPickupPin: fulfillmentPickupPin,
        fulfillmentRider: fulfillmentRider,
        fulfillmentStatusId: fulfillmentStatusId,
        fulfillmentTrackingUrl: fulfillmentTrackingUrl,
        canFindFulfillmentRider: canFindFulfillmentRider,
        canMarkAccept: canMarkAccept,
        canMarkCancel: canMarkCancel,
        threePlDispatchType: threePlDispatchType,
        orderAppliedPromo: orderAppliedPromo,
        itemAppliedPromos: itemAppliedPromos,
        cancellationReasonId: cancellationReasonId,
        cancellationReason: cancellationReason,
        restaurantServiceFee: restaurantServiceFee,
        appliedPromos: appliedPromos,
        estimatedPickUpAt: estimatedPickUpAt,
        deliveryInfo: deliveryInfo,
        providerSubTotal: providerSubTotal,
        providerGrandTotal: providerGrandTotal,
        providerAdditionalFee: providerAdditionalFee,
        preparationTime: preparationTime,
        queueNo: queueNo,
        pickupType: pickupType,
        additionalInfo: additionalInfo,
        canCancelRider: canCancelRider,
        feePaidByCustomer: feePaidByCustomer,
        mergeFee: mergeFee,
        rewardDiscount: rewardDiscount,
      );
}
