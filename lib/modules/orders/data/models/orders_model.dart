import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/orders/domain/entities/cart.dart';

import '../../domain/entities/order.dart';
import '../../domain/entities/rider_info.dart';
import '../../domain/entities/source.dart';
import 'brand_model.dart';

part 'orders_model.g.dart';

@JsonSerializable(explicitToJson: true)
class OrdersModel {
  List<OrderModel>? orders;
  int? total;
  int? page;
  int? size;

  OrdersModel({this.orders, this.total, this.page, this.size});

  factory OrdersModel.fromJson(Map<String, dynamic> json) =>
      _$OrdersModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersModelToJson(this);

  Orders emptyObject() {
    return Orders(
      data: [],
      total: 0,
      page: 0,
      size: 0,
    );
  }

  Orders toEntity(List<Order> ordersWithSource) {
    return Orders(
      data: ordersWithSource,
      total: total.orZero(),
      page: page.orZero(),
      size: size.orZero(),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class OrderModel {
  int? id;
  int? source;
  int? status;
  int? vat;
  int? type;
  int? discount;
  String? currency;
  @JsonKey(name: 'external_id')
  String? externalId;
  @JsonKey(name: 'short_id')
  String? shortId;
  @JsonKey(name: 'provider_id')
  int? providerId;
  @JsonKey(name: 'brand_name')
  String? brandName;
  @JsonKey(name: 'branch_id')
  int? branchId;
  @JsonKey(name: 'item_price')
  int? itemPrice;
  @JsonKey(name: 'final_price')
  int? finalPrice;
  @JsonKey(name: 'merchant_discount')
  int? merchantDiscount;
  @JsonKey(name: 'provider_discount')
  int? providerDiscount;
  @JsonKey(name: 'delivery_fee')
  int? deliveryFee;
  @JsonKey(name: 'additional_fee')
  int? additionalFee;
  @JsonKey(name: 'gateway_fee')
  int? gatewayFee;
  @JsonKey(name: 'service_fee')
  int? serviceFee;
  @JsonKey(name: 'currency_symbol')
  String? currencySymbol;
  @JsonKey(name: 'item_count')
  int? itemCount;
  @JsonKey(name: 'unique_item_count')
  int? uniqueItemCount;
  @JsonKey(name: 'scheduled_status')
  int? scheduledStatus;
  @JsonKey(name: 'scheduled_time')
  String? scheduledTime;
  @JsonKey(name: 'created_at')
  String? createdAt;
  @JsonKey(name: 'updated_at')
  String? updatedAt;
  @JsonKey(name: 'user_id')
  int? userId;
  @JsonKey(name: 'user_first_name')
  String? userFirstName;
  @JsonKey(name: 'user_last_name')
  String? userLastName;
  @JsonKey(name: 'user_profile_pic')
  String? userProfilePic;
  @JsonKey(name: 'user_phone')
  String? userPhone;
  @JsonKey(name: 'user_email')
  String? userEmail;
  List<CartBrandModel>? brands;
  @JsonKey(name: 'cart')
  List<CartV1Model>? cartV1;
  @JsonKey(name: 'cart_v2')
  List<CartV2Model>? cartV2;
  @JsonKey(name: 'klikit_store_id')
  String? klikitStoreId;
  @JsonKey(name: 'is_fake')
  bool? isFake;
  @JsonKey(name: 'is_foodpanda_api_order')
  bool? isFoodpandaApiOrder;
  @JsonKey(name: 'is_vat_included')
  bool? isVatIncluded;
  @JsonKey(name: 'is_interceptor_order')
  bool? isInterceptorOrder;
  @JsonKey(name: 'order_comment')
  String? orderComment;
  @JsonKey(name: 'delivery_comment')
  String? deliveryComment;
  @JsonKey(name: 'foodpanda_token')
  String? foodpandaToken;
  @JsonKey(name: 'klikit_comment')
  String? klikitComment;
  @JsonKey(name: 'is_manual_order')
  bool? isManualOrder;
  @JsonKey(name: 'payment_method')
  int? paymentMethod;
  @JsonKey(name: 'payment_status')
  int? paymentStatus;
  @JsonKey(name: 'auto_accept')
  bool? autoAccept;
  @JsonKey(name: 'auto_pilot')
  bool? autoPilot;
  @JsonKey(name: 'auto_pilot_time')
  int? autoPilotTime;
  @JsonKey(name: 'table_no')
  String? tableNo;
  @JsonKey(name: 'can_update')
  bool? canUpdate;
  @JsonKey(name: 'can_mark_ready')
  bool? canMarkReady;
  @JsonKey(name: 'discount_display')
  String? discountDisplay;
  @JsonKey(name: 'additional_fee_display')
  String? additionalFeeDisplay;
  @JsonKey(name: 'delivery_fee_display')
  String? deliveryFeeDisplay;
  @JsonKey(name: 'final_price_display')
  String? finalPriceDisplay;
  @JsonKey(name: 'item_price_display')
  String? itemPriceDisplay;
  @JsonKey(name: 'merchant_discount_display')
  String? merchantDiscountDisplay;
  @JsonKey(name: 'provider_discount_display')
  String? providerDiscountDisplay;
  @JsonKey(name: 'vat_display')
  String? vatDisplay;
  @JsonKey(name: 'discount_type')
  int? discountTYpe;
  @JsonKey(name: 'discount_value')
  int? discountValue;
  @JsonKey(name: 'identity')
  String? identity;
  @JsonKey(name: 'is_mix_and_match_order')
  bool? isMixAndMatchOrder;
  @JsonKey(name: 'triggered_time')
  String? triggeredTime;
  @JsonKey(name: 'is_three_pl_order')
  bool? isThreePlOrder;
  @JsonKey(name: 'fulfillment_delivered_at_time')
  String? fulfillmentDeliveredTime;
  @JsonKey(name: 'fulfillment_expected_pickup_time')
  String? fulfillmentExpectedPickupTime;
  @JsonKey(name: 'fulfillment_pickup_pin')
  String? fulfillmentPickupPin;
  @JsonKey(name: 'fulfillment_rider')
  RiderInfo? fulfillmentRider;
  @JsonKey(name: 'fulfillment_status_id')
  int? fulfillmentStatusId;
  @JsonKey(name: 'fulfillment_tracking_url')
  String? fulfillmentTrackingUrl;

  OrderModel({
    this.id,
    this.externalId,
    this.shortId,
    this.providerId,
    this.brandName,
    this.branchId,
    this.status,
    this.itemPrice,
    this.finalPrice,
    this.discount,
    this.merchantDiscount,
    this.providerDiscount,
    this.deliveryFee,
    this.additionalFee,
    this.gatewayFee,
    this.serviceFee,
    this.vat,
    this.currency,
    this.currencySymbol,
    this.itemCount,
    this.uniqueItemCount,
    this.scheduledStatus,
    this.scheduledTime,
    this.createdAt,
    this.updatedAt,
    this.userId,
    this.userFirstName,
    this.userLastName,
    this.userProfilePic,
    this.userPhone,
    this.userEmail,
    this.brands,
    this.cartV2,
    this.cartV1,
    this.klikitStoreId,
    this.type,
    this.isFake,
    this.isFoodpandaApiOrder,
    this.isInterceptorOrder,
    this.orderComment,
    this.deliveryComment,
    this.foodpandaToken,
    this.klikitComment,
    this.isManualOrder,
    this.source,
    this.paymentMethod,
    this.paymentStatus,
    this.autoAccept,
    this.autoPilot,
    this.autoPilotTime,
    this.tableNo,
    this.canUpdate,
    this.canMarkReady,
    this.discountDisplay,
    this.additionalFeeDisplay,
    this.deliveryFeeDisplay,
    this.finalPriceDisplay,
    this.itemPriceDisplay,
    this.merchantDiscountDisplay,
    this.providerDiscountDisplay,
    this.vatDisplay,
    this.discountTYpe,
    this.discountValue,
    this.identity,
    this.isMixAndMatchOrder,
    this.triggeredTime,
    this.isVatIncluded,
    this.isThreePlOrder,
    this.fulfillmentDeliveredTime,
    this.fulfillmentExpectedPickupTime,
    this.fulfillmentPickupPin,
    this.fulfillmentRider,
    this.fulfillmentStatusId,
    this.fulfillmentTrackingUrl,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  Order toEntity({required OrderSource orderSource}) {
    return Order(
      id: id.orZero(),
      externalId: externalId.orEmpty(),
      shortId: shortId.orEmpty(),
      providerId: providerId.orZero(),
      brandName: brandName.orEmpty(),
      branchId: branchId.orZero(),
      status: status.orZero(),
      itemPrice: itemPrice.orZero(),
      finalPrice: finalPrice.orZero(),
      discount: discount.orZero(),
      merchantDiscount: merchantDiscount.orZero(),
      providerDiscount: providerDiscount.orZero(),
      deliveryFee: deliveryFee.orZero(),
      additionalFee: additionalFee.orZero(),
      vat: vat.orZero(),
      currency: currency.orEmpty(),
      currencySymbol: currencySymbol.orEmpty(),
      itemCount: itemCount.orZero(),
      uniqueItemCount: uniqueItemCount.orZero(),
      createdAt: createdAt.orEmpty(),
      updatedAt: updatedAt.orEmpty(),
      userId: userId.orZero(),
      userFirstName: userFirstName.orEmpty(),
      userLastName: userLastName.orEmpty(),
      userProfilePic: userProfilePic.orEmpty(),
      userPhone: userPhone.orEmpty(),
      userEmail: userEmail.orEmpty(),
      cartV1: cartV1?.map((e) => e.toEntity()).toList() ?? [],
      cartV2: cartV2?.map((e) => e.toEntity()).toList() ?? [],
      brands: brands?.map((e) => e.toEntity()).toList() ?? [],
      klikitStoreId: klikitStoreId.orEmpty(),
      type: type.orZero(),
      isFake: isFake ?? false,
      isFoodpandaApiOrder: isFoodpandaApiOrder ?? false,
      orderComment: orderComment.orEmpty(),
      deliveryComment: deliveryComment.orEmpty(),
      foodpandaToken: foodpandaToken.orEmpty(),
      isManualOrder: isManualOrder ?? false,
      source: source.orZero(),
      paymentMethod: paymentMethod.orZero(),
      paymentStatus: paymentStatus.orZero(),
      autoAccept: autoAccept ?? false,
      autoPilot: autoPilot ?? false,
      autoPilotTime: autoPilotTime.orZero(),
      klikitComment: klikitComment.orEmpty(),
      isInterceptorOrder: isInterceptorOrder.orFalse(),
      orderSource: orderSource,
      scheduledStatus: scheduledStatus.orZero(),
      scheduledTime: scheduledTime.orEmpty(),
      gatewayFee: gatewayFee.orZero(),
      serviceFee: serviceFee.orZero(),
      tableNo: tableNo.orEmpty(),
      canMarkReady: canMarkReady.orFalse(),
      canUpdate: canUpdate.orFalse(),
      discountDisplay: discountDisplay.orEmpty(),
      additionalFeeDisplay: additionalFeeDisplay.orEmpty(),
      deliveryFeeDisplay: deliveryFeeDisplay.orEmpty(),
      finalPriceDisplay: finalPriceDisplay.orEmpty(),
      itemPriceDisplay: itemPriceDisplay.orEmpty(),
      merchantDiscountDisplay: merchantDiscountDisplay.orEmpty(),
      providerDiscountDisplay: providerDiscountDisplay.orEmpty(),
      vatDisplay: vatDisplay.orEmpty(),
      discountTYpe: discountTYpe.orZero(),
      discountValue: discountValue.orZero(),
      identity: identity.orEmpty(),
      isMixAndMatchOrder: isMixAndMatchOrder.orFalse(),
      triggeredTime: triggeredTime.orEmpty(),
      isVatIncluded: isVatIncluded.orFalse(),
      isThreePlOrder: isThreePlOrder.orFalse(),
      fulfillmentDeliveredTime: fulfillmentDeliveredTime.orEmpty(),
      fulfillmentExpectedPickupTime: fulfillmentExpectedPickupTime.orEmpty(),
      fulfillmentPickupPin: fulfillmentPickupPin.orEmpty(),
      fulfillmentRider: fulfillmentRider,
      fulfillmentStatusId: fulfillmentStatusId.orZero(),
      fulfillmentTrackingUrl: fulfillmentTrackingUrl.orEmpty(),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CartV2Model {
  String? id;
  String? name;
  String? image;
  String? price;
  String? comment;
  int? quantity;
  CartBrandModel? brand;
  @JsonKey(name: 'modifier_group_price')
  String? modifierGroupPrice;
  @JsonKey(name: 'external_id')
  String? externalId;
  @JsonKey(name: 'price_display')
  String? priceDisplay;
  @JsonKey(name: 'unit_price')
  String? unitPrice;
  @JsonKey(name: 'unit_price_display')
  String? unitPriceDisplay;
  @JsonKey(name: 'modifier_groups')
  List<ModifierGroupsModel>? modifierGroups;

  CartV2Model({
    this.id,
    this.externalId,
    this.name,
    this.image,
    this.price,
    this.comment,
    this.quantity,
    this.brand,
    this.unitPrice,
    this.modifierGroups,
    this.unitPriceDisplay,
    this.priceDisplay,
    this.modifierGroupPrice,
  });

  factory CartV2Model.fromJson(Map<String, dynamic> json) =>
      _$CartV2ModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartV2ModelToJson(this);

  CartV2 toEntity() {
    return CartV2(
      id: id.orEmpty(),
      externalId: externalId.orEmpty(),
      name: name.orEmpty(),
      image: image.orEmpty(),
      price: price.orEmpty(),
      comment: comment.orEmpty(),
      quantity: quantity.orZero(),
      unitPrice: unitPrice.orEmpty(),
      unitPriceDisplay: unitPriceDisplay.orEmpty(),
      priceDisplay: priceDisplay.orEmpty(),
      modifierGroups: modifierGroups?.map((e) => e.toEntity()).toList() ?? [],
      cartBrand: brand!.toEntity(),
      modifierGroupPrice: modifierGroupPrice.orEmpty(),
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ModifierGroupsModel {
  String? id;
  String? name;
  List<ModifiersModel>? modifiers;

  ModifierGroupsModel({this.id, this.name, this.modifiers});

  factory ModifierGroupsModel.fromJson(Map<String, dynamic> json) =>
      _$ModifierGroupsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModifierGroupsModelToJson(this);

  ModifierGroups toEntity() {
    return ModifierGroups(
      id: id.orEmpty(),
      name: name.orEmpty(),
      modifiers: modifiers?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

@JsonSerializable(explicitToJson: true)
class ModifiersModel {
  String? id;
  String? name;
  String? price;
  int? quantity;
  @JsonKey(name: 'unit_price')
  String? unitPrice;
  @JsonKey(name: 'price_display')
  String? priceDisplay;
  @JsonKey(name: 'unit_price_display')
  String? unitPriceDisplay;
  @JsonKey(name: 'modifier_groups')
  List<ModifierGroupsModel>? modifierGroups;

  ModifiersModel({
    this.id,
    this.name,
    this.price,
    this.quantity,
    this.unitPrice,
    this.modifierGroups,
    this.priceDisplay,
    this.unitPriceDisplay,
  });

  factory ModifiersModel.fromJson(Map<String, dynamic> json) =>
      _$ModifiersModelFromJson(json);

  Map<String, dynamic> toJson() => _$ModifiersModelToJson(this);

  Modifiers toEntity() {
    return Modifiers(
      id: id.orEmpty(),
      name: name.orEmpty(),
      price: price.orEmpty(),
      quantity: quantity.orZero(),
      unitPrice: unitPrice.orEmpty(),
      unitPriceDisplay: unitPriceDisplay.orEmpty(),
      priceDisplay: priceDisplay.orEmpty(),
      modifierGroups: modifierGroups?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}

@JsonSerializable(explicitToJson: true)
class CartV1Model {
  @JsonKey(name: 'item_id')
  int? itemId;
  @JsonKey(name: 'discount_type')
  int? discountType;
  @JsonKey(name: 'discount_value')
  num? discountValue;

  CartV1Model({
    this.itemId,
    this.discountType,
    this.discountValue,
  });

  factory CartV1Model.fromJson(Map<String, dynamic> json) =>
      _$CartV1ModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartV1ModelToJson(this);

  CartV1 toEntity() => CartV1(
        itemId.orZero(),
        discountType.orZero(),
        discountValue ?? ZERO,
      );
}
