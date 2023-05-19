import 'package:klikit/modules/orders/domain/entities/source.dart';

import 'brand.dart';
import 'cart.dart';

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
  String klikitComment;
  int paymentMethod;
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
    required this.paymentStatus,
    required this.autoAccept,
    required this.autoPilot,
    required this.autoPilotTime,
    required this.orderSource,
    required this.tableNo,
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
        paymentStatus: paymentStatus,
        autoAccept: autoAccept,
        autoPilot: autoPilot,
        autoPilotTime: autoPilotTime,
        orderSource: orderSource.copy(),
        tableNo: tableNo,
      );
}
