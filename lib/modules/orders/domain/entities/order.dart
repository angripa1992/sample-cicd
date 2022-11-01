import 'cart.dart';

class Orders {
  final int total;
  final int page;
  final int size;
  final List<Order> data;

  Orders(
      {required this.data,
      required this.total,
      required this.page,
      required this.size});
}

class Order {
  final int id;
  final String externalId;
  final String shortId;
  final int providerId;
  final int brandId;
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
  final int vat;
  final String currency;
  final String currencySymbol;
  final int itemCount;
  final int uniqueItemCount;
  final String createdAt;
  final String updatedAt;
  final int userId;
  final String userFirstName;
  final String userLastName;
  final String userProfilePic;
  final String userPhone;
  final String userEmail;
  final List<CartV2> cartV2;
  final String klikitStoreId;
  final int type;
  final bool isFake;
  final bool isFoodpandaApiOrder;
  final String orderComment;
  final String deliveryComment;
  final String foodpandaToken;
  final String klikitComment;
  final bool isManualOrder;
  final int source;
  final int paymentMethod;
  final int paymentStatus;
  final bool autoAccept;
  final bool autoPilot;
  final int autoPilotTime;

  Order({
    required this.id,
    required this.externalId,
    required this.shortId,
    required this.providerId,
    required this.brandId,
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
    required this.vat,
    required this.currency,
    required this.currencySymbol,
    required this.itemCount,
    required this.uniqueItemCount,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.userProfilePic,
    required this.userPhone,
    required this.userEmail,
    required this.cartV2,
    required this.klikitStoreId,
    required this.type,
    required this.isFake,
    required this.isFoodpandaApiOrder,
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
  });

  Order copyWithComment(String klikitComment) {
    return Order(
      id: id,
      externalId: externalId,
      shortId: shortId,
      providerId: providerId,
      brandId: brandId,
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
      vat: vat,
      currency: currency,
      currencySymbol: currencySymbol,
      itemCount: itemCount,
      uniqueItemCount: uniqueItemCount,
      createdAt: createdAt,
      updatedAt: updatedAt,
      userId: userId,
      userFirstName: userFirstName,
      userLastName: userLastName,
      userProfilePic: userProfilePic,
      userPhone: userPhone,
      userEmail: userEmail,
      cartV2: cartV2,
      klikitStoreId: klikitStoreId,
      type: type,
      isFake: isFake,
      isFoodpandaApiOrder: isFoodpandaApiOrder,
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
    );
  }
}
