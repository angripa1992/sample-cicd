import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klikit/app/extensions.dart';

import '../../../app/di.dart';
import '../../../app/size_config.dart';
import '../data/models/orders_model.dart';
import '../domain/entities/order.dart';
import '../edit_order/calculate_grab_order_cubit.dart';
import '../edit_order/edit_grab_order.dart';
import '../edit_order/update_grab_order_cubit.dart';

class GrabOrderResolver {
  static final _instance = GrabOrderResolver._internal();

  factory GrabOrderResolver() => _instance;

  GrabOrderResolver._internal();

  void editGrabOrderOrder({
    required BuildContext context,
    required Order order,
    required Function(Order) onGrabEditSuccess,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return MultiBlocProvider(
          providers: [
            BlocProvider<CalculateGrabBillCubit>(create: (_) => getIt.get()),
            BlocProvider<UpdateGrabOrderCubit>(create: (_) => getIt.get()),
          ],
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            extendBody: false,
            body: Container(
              margin: EdgeInsets.only(top: ScreenSizes.statusBarHeight),
              child: EditGrabOrderView(
                order: order,
                onClose: () {
                  Navigator.pop(context);
                },
                onEditSuccess: onGrabEditSuccess,
              ),
            ),
          ),
        );
      },
    );
  }

  OrderModel toModel(Order order) => OrderModel(
        id: order.id,
        source: order.source,
        status: order.status,
        vat: order.vat,
        type: order.type,
        discount: order.discount,
        currency: order.currency,
        externalId: order.externalId,
        shortId: order.shortId,
        providerId: order.providerId,
        brandName: order.brandName,
        branchId: order.branchId,
        itemPrice: order.itemPrice,
        finalPrice: order.finalPrice,
        merchantDiscount: order.merchantDiscount,
        providerDiscount: order.providerDiscount,
        deliveryFee: order.deliveryFee,
        additionalFee: order.additionalFee,
        gatewayFee: order.gatewayFee,
        serviceFee: order.serviceFee,
        customFee: order.customFee,
        currencySymbol: order.currencySymbol,
        itemCount: order.itemCount,
        uniqueItemCount: order.uniqueItemCount,
        scheduledStatus: order.scheduledStatus,
        scheduledTime: order.scheduledTime.notEmptyOrNull(),
        createdAt: order.createdAt,
        updatedAt: order.updatedAt,
        userId: order.userId,
        userFirstName: order.userFirstName,
        userLastName: order.userLastName,
        userProfilePic: order.userProfilePic,
        userPhone: order.userPhone,
        userEmail: order.userEmail,
        brands: order.brands.map((e) => e.toModel()).toList(),
        cartV2: order.cartV2.map((e) => e.toModel()).toList(),
        klikitStoreId: order.klikitStoreId,
        isFake: order.isFake,
        isFoodpandaApiOrder: order.isFoodpandaApiOrder,
        isInterceptorOrder: order.isInterceptorOrder,
        orderComment: order.orderComment,
        deliveryComment: order.deliveryComment,
        foodpandaToken: order.foodpandaToken,
        klikitComment: order.klikitComment.notEmptyOrNull(),
        isManualOrder: order.isManualOrder,
        paymentMethod: order.paymentMethod.notZeroOrNull(),
        paymentChannel: order.paymentChannel.notZeroOrNull(),
        paymentStatus: order.paymentStatus.notZeroOrNull(),
        autoAccept: order.autoAccept,
        autoPilot: order.autoPilot,
        autoPilotTime: order.autoPilotTime,
        tableNo: order.tableNo.notEmptyOrNull(),
        canUpdate: order.canUpdate,
        discountDisplay: order.discountDisplay,
        additionalFeeDisplay: order.additionalFeeDisplay,
        deliveryFeeDisplay: order.deliveryFeeDisplay,
        finalPriceDisplay: order.finalPriceDisplay,
        itemPriceDisplay: order.itemPriceDisplay,
        merchantDiscountDisplay: order.merchantDiscountDisplay,
        providerDiscountDisplay: order.providerDiscountDisplay,
        vatDisplay: order.vatDisplay,
        discountTYpe: order.discountTYpe.notZeroOrNull(),
        discountValue: order.discountValue.notZeroOrNull(),
        identity: order.identity,
        isMixAndMatchOrder: order.isMixAndMatchOrder,
        triggeredTime: order.triggeredTime.notEmptyOrNull(),
        isVatIncluded: order.isVatIncluded,
        isThreePlOrder: order.isThreePlOrder,
        fulfillmentDeliveredTime: order.fulfillmentDeliveredTime,
        fulfillmentExpectedPickupTime: order.fulfillmentExpectedPickupTime,
        fulfillmentPickupPin: order.fulfillmentPickupPin,
        fulfillmentRider: order.fulfillmentRider,
        fulfillmentStatusId: order.fulfillmentStatusId,
        fulfillmentTrackingUrl: order.fulfillmentTrackingUrl,
        canFindFulfillmentRider: order.canFindFulfillmentRider,
        threePlDispatchType: order.threePlDispatchType,
        orderAppliedPromo: order.orderAppliedPromo,
        itemAppliedPromos: order.itemAppliedPromos,
        cancellationReasonId: order.cancellationReasonId,
        cancellationReason: order.cancellationReason,
        restaurantServiceFee: order.restaurantServiceFee,
        pickUpAt: order.estimatedPickUpAt,
        providerSubTotal: order.providerSubTotal,
        providerGrandTotal: order.providerGrandTotal,
        providerAdditionalFee: order.providerAdditionalFee,
        preparationTime: order.preparationTime,
        queueNo: 0,
        pickupType: order.pickupType,
        additionalInfo: order.additionalInfo?.toModel(),
        canCancelRider: order.canCancelRider,
      );
}
