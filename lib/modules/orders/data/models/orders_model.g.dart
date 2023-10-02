// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'orders_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrdersModel _$OrdersModelFromJson(Map<String, dynamic> json) => OrdersModel(
      orders: (json['orders'] as List<dynamic>?)
          ?.map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
      page: json['page'] as int?,
      size: json['size'] as int?,
    );

Map<String, dynamic> _$OrdersModelToJson(OrdersModel instance) =>
    <String, dynamic>{
      'orders': instance.orders?.map((e) => e.toJson()).toList(),
      'total': instance.total,
      'page': instance.page,
      'size': instance.size,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as int?,
      externalId: json['external_id'] as String?,
      shortId: json['short_id'] as String?,
      providerId: json['provider_id'] as int?,
      brandName: json['brand_name'] as String?,
      branchId: json['branch_id'] as int?,
      status: json['status'] as int?,
      itemPrice: json['item_price'] as int?,
      finalPrice: json['final_price'] as int?,
      discount: json['discount'] as int?,
      merchantDiscount: json['merchant_discount'] as int?,
      providerDiscount: json['provider_discount'] as int?,
      deliveryFee: json['delivery_fee'] as int?,
      additionalFee: json['additional_fee'] as int?,
      gatewayFee: json['gateway_fee'] as int?,
      serviceFee: json['service_fee'] as int?,
      vat: json['vat'] as int?,
      currency: json['currency'] as String?,
      currencySymbol: json['currency_symbol'] as String?,
      itemCount: json['item_count'] as int?,
      uniqueItemCount: json['unique_item_count'] as int?,
      scheduledStatus: json['scheduled_status'] as int?,
      scheduledTime: json['scheduled_time'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      userId: json['user_id'] as int?,
      userFirstName: json['user_first_name'] as String?,
      userLastName: json['user_last_name'] as String?,
      userProfilePic: json['user_profile_pic'] as String?,
      userPhone: json['user_phone'] as String?,
      userEmail: json['user_email'] as String?,
      brands: (json['brands'] as List<dynamic>?)
          ?.map((e) => CartBrandModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      cartV2: (json['cart_v2'] as List<dynamic>?)
          ?.map((e) => CartV2Model.fromJson(e as Map<String, dynamic>))
          .toList(),
      cartV1: (json['cart'] as List<dynamic>?)
          ?.map((e) => CartV1Model.fromJson(e as Map<String, dynamic>))
          .toList(),
      klikitStoreId: json['klikit_store_id'] as String?,
      type: json['type'] as int?,
      isFake: json['is_fake'] as bool?,
      isFoodpandaApiOrder: json['is_foodpanda_api_order'] as bool?,
      isInterceptorOrder: json['is_interceptor_order'] as bool?,
      orderComment: json['order_comment'] as String?,
      deliveryComment: json['delivery_comment'] as String?,
      foodpandaToken: json['foodpanda_token'] as String?,
      klikitComment: json['klikit_comment'] as String?,
      isManualOrder: json['is_manual_order'] as bool?,
      source: json['source'] as int?,
      paymentMethod: json['payment_method'] as int?,
      paymentChannel: json['payment_channel_id'] as int?,
      paymentStatus: json['payment_status'] as int?,
      autoAccept: json['auto_accept'] as bool?,
      autoPilot: json['auto_pilot'] as bool?,
      autoPilotTime: json['auto_pilot_time'] as int?,
      tableNo: json['table_no'] as String?,
      canUpdate: json['can_update'] as bool?,
      canMarkReady: json['can_mark_ready'] as bool?,
      discountDisplay: json['discount_display'] as String?,
      additionalFeeDisplay: json['additional_fee_display'] as String?,
      deliveryFeeDisplay: json['delivery_fee_display'] as String?,
      finalPriceDisplay: json['final_price_display'] as String?,
      itemPriceDisplay: json['item_price_display'] as String?,
      merchantDiscountDisplay: json['merchant_discount_display'] as String?,
      providerDiscountDisplay: json['provider_discount_display'] as String?,
      vatDisplay: json['vat_display'] as String?,
      discountTYpe: json['discount_type'] as int?,
      discountValue: json['discount_value'] as num?,
      identity: json['identity'] as String?,
      isMixAndMatchOrder: json['is_mix_and_match_order'] as bool?,
      triggeredTime: json['triggered_time'] as String?,
      isVatIncluded: json['is_vat_included'] as bool?,
      isThreePlOrder: json['is_three_pl_order'] as bool?,
      fulfillmentDeliveredTime:
          json['fulfillment_delivered_at_time'] as String?,
      fulfillmentExpectedPickupTime:
          json['fulfillment_expected_pickup_time'] as String?,
      fulfillmentPickupPin: json['fulfillment_pickup_pin'] as String?,
      fulfillmentRider: json['fulfillment_rider'] == null
          ? null
          : RiderInfo.fromJson(
              json['fulfillment_rider'] as Map<String, dynamic>),
      fulfillmentStatusId: json['fulfillment_status_id'] as int?,
      fulfillmentTrackingUrl: json['fulfillment_tracking_url'] as String?,
      canFindFulfillmentRider: json['can_find_fulfillment_rider'] as bool?,
      canMarkAccept: json['can_mark_accept'] as bool?,
      canMarkCancel: json['can_mark_cancel'] as bool?,
      threePlDispatchType: json['three_pl_dispatch_type'] as int?,
      orderAppliedPromo: json['order_applied_promo'] == null
          ? null
          : OrderAppliedPromo.fromJson(
              json['order_applied_promo'] as Map<String, dynamic>),
      itemAppliedPromos: (json['item_applied_promos'] as List<dynamic>?)
          ?.map((e) => OrderAppliedPromo.fromJson(e as Map<String, dynamic>))
          .toList(),
      cancellationReasonId: json['cancellation_reason_id'] as int?,
      cancellationReason: json['cancellation_reason'] as String?,
      restaurantServiceFee: json['restaurant_service_fee'] as int?,
      promos: (json['promos'] as List<dynamic>?)
          ?.map(
              (e) => OrderAppliedPromoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pickUpAt: json['estimated_pickup_at'] as String?,
      deliveryInfo: json['delivery_info'] == null
          ? null
          : DeliveryInfoModel.fromJson(
              json['delivery_info'] as Map<String, dynamic>),
      providerSubTotal: json['provider_sub_total'] as num?,
      providerGrandTotal: json['provider_grand_total'] as num?,
      providerAdditionalFee: json['provider_additional_fee'] as num?,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source': instance.source,
      'status': instance.status,
      'vat': instance.vat,
      'type': instance.type,
      'discount': instance.discount,
      'currency': instance.currency,
      'external_id': instance.externalId,
      'short_id': instance.shortId,
      'provider_id': instance.providerId,
      'brand_name': instance.brandName,
      'branch_id': instance.branchId,
      'item_price': instance.itemPrice,
      'final_price': instance.finalPrice,
      'merchant_discount': instance.merchantDiscount,
      'provider_discount': instance.providerDiscount,
      'delivery_fee': instance.deliveryFee,
      'additional_fee': instance.additionalFee,
      'gateway_fee': instance.gatewayFee,
      'service_fee': instance.serviceFee,
      'currency_symbol': instance.currencySymbol,
      'item_count': instance.itemCount,
      'unique_item_count': instance.uniqueItemCount,
      'scheduled_status': instance.scheduledStatus,
      'scheduled_time': instance.scheduledTime,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'user_id': instance.userId,
      'user_first_name': instance.userFirstName,
      'user_last_name': instance.userLastName,
      'user_profile_pic': instance.userProfilePic,
      'user_phone': instance.userPhone,
      'user_email': instance.userEmail,
      'brands': instance.brands?.map((e) => e.toJson()).toList(),
      'cart': instance.cartV1?.map((e) => e.toJson()).toList(),
      'cart_v2': instance.cartV2?.map((e) => e.toJson()).toList(),
      'klikit_store_id': instance.klikitStoreId,
      'is_fake': instance.isFake,
      'is_foodpanda_api_order': instance.isFoodpandaApiOrder,
      'is_vat_included': instance.isVatIncluded,
      'is_interceptor_order': instance.isInterceptorOrder,
      'order_comment': instance.orderComment,
      'delivery_comment': instance.deliveryComment,
      'foodpanda_token': instance.foodpandaToken,
      'klikit_comment': instance.klikitComment,
      'is_manual_order': instance.isManualOrder,
      'payment_method': instance.paymentMethod,
      'payment_channel_id': instance.paymentChannel,
      'payment_status': instance.paymentStatus,
      'auto_accept': instance.autoAccept,
      'auto_pilot': instance.autoPilot,
      'auto_pilot_time': instance.autoPilotTime,
      'table_no': instance.tableNo,
      'can_update': instance.canUpdate,
      'can_mark_ready': instance.canMarkReady,
      'discount_display': instance.discountDisplay,
      'additional_fee_display': instance.additionalFeeDisplay,
      'delivery_fee_display': instance.deliveryFeeDisplay,
      'final_price_display': instance.finalPriceDisplay,
      'item_price_display': instance.itemPriceDisplay,
      'merchant_discount_display': instance.merchantDiscountDisplay,
      'provider_discount_display': instance.providerDiscountDisplay,
      'vat_display': instance.vatDisplay,
      'discount_type': instance.discountTYpe,
      'discount_value': instance.discountValue,
      'identity': instance.identity,
      'is_mix_and_match_order': instance.isMixAndMatchOrder,
      'triggered_time': instance.triggeredTime,
      'is_three_pl_order': instance.isThreePlOrder,
      'fulfillment_delivered_at_time': instance.fulfillmentDeliveredTime,
      'fulfillment_expected_pickup_time':
          instance.fulfillmentExpectedPickupTime,
      'fulfillment_pickup_pin': instance.fulfillmentPickupPin,
      'fulfillment_rider': instance.fulfillmentRider?.toJson(),
      'fulfillment_status_id': instance.fulfillmentStatusId,
      'fulfillment_tracking_url': instance.fulfillmentTrackingUrl,
      'can_find_fulfillment_rider': instance.canFindFulfillmentRider,
      'can_mark_accept': instance.canMarkAccept,
      'can_mark_cancel': instance.canMarkCancel,
      'three_pl_dispatch_type': instance.threePlDispatchType,
      'order_applied_promo': instance.orderAppliedPromo?.toJson(),
      'item_applied_promos':
          instance.itemAppliedPromos?.map((e) => e.toJson()).toList(),
      'cancellation_reason_id': instance.cancellationReasonId,
      'cancellation_reason': instance.cancellationReason,
      'estimated_pickup_at': instance.pickUpAt,
      'restaurant_service_fee': instance.restaurantServiceFee,
      'promos': instance.promos?.map((e) => e.toJson()).toList(),
      'delivery_info': instance.deliveryInfo?.toJson(),
      'provider_sub_total': instance.providerSubTotal,
      'provider_grand_total': instance.providerGrandTotal,
      'provider_additional_fee': instance.providerAdditionalFee,
    };

CartV2Model _$CartV2ModelFromJson(Map<String, dynamic> json) => CartV2Model(
      id: json['id'] as String?,
      externalId: json['external_id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      price: json['price'] as String?,
      comment: json['comment'] as String?,
      quantity: json['quantity'] as int?,
      brand: json['brand'] == null
          ? null
          : CartBrandModel.fromJson(json['brand'] as Map<String, dynamic>),
      unitPrice: json['unit_price'] as String?,
      modifierGroups: (json['modifier_groups'] as List<dynamic>?)
          ?.map((e) => e == null
              ? null
              : ModifierGroupsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      unitPriceDisplay: json['unit_price_display'] as String?,
      priceDisplay: json['price_display'] as String?,
      modifierGroupPrice: json['modifier_group_price'] as String?,
    );

Map<String, dynamic> _$CartV2ModelToJson(CartV2Model instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'comment': instance.comment,
      'quantity': instance.quantity,
      'brand': instance.brand?.toJson(),
      'modifier_group_price': instance.modifierGroupPrice,
      'external_id': instance.externalId,
      'price_display': instance.priceDisplay,
      'unit_price': instance.unitPrice,
      'unit_price_display': instance.unitPriceDisplay,
      'modifier_groups':
          instance.modifierGroups?.map((e) => e?.toJson()).toList(),
    };

ModifierGroupsModel _$ModifierGroupsModelFromJson(Map<String, dynamic> json) =>
    ModifierGroupsModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      modifiers: (json['modifiers'] as List<dynamic>?)
          ?.map((e) => ModifiersModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModifierGroupsModelToJson(
        ModifierGroupsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'modifiers': instance.modifiers?.map((e) => e.toJson()).toList(),
    };

ModifiersModel _$ModifiersModelFromJson(Map<String, dynamic> json) =>
    ModifiersModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      price: json['price'] as String?,
      quantity: json['quantity'] as int?,
      unitPrice: json['unit_price'] as String?,
      modifierGroups: (json['modifier_groups'] as List<dynamic>?)
          ?.map((e) => ModifierGroupsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      priceDisplay: json['price_display'] as String?,
      unitPriceDisplay: json['unit_price_display'] as String?,
    );

Map<String, dynamic> _$ModifiersModelToJson(ModifiersModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'price_display': instance.priceDisplay,
      'unit_price_display': instance.unitPriceDisplay,
      'modifier_groups':
          instance.modifierGroups?.map((e) => e.toJson()).toList(),
    };

CartV1Model _$CartV1ModelFromJson(Map<String, dynamic> json) => CartV1Model(
      itemId: json['item_id'] as int?,
      discountType: json['discount_type'] as int?,
      discountValue: json['discount_value'] as num?,
      quantityOfScPromoItem: json['quantity_of_sc_promo_item'] as int?,
    )..appliedPromo = json['applied_promo'] == null
        ? null
        : ItemAppliedPromoModel.fromJson(
            json['applied_promo'] as Map<String, dynamic>);

Map<String, dynamic> _$CartV1ModelToJson(CartV1Model instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'discount_type': instance.discountType,
      'discount_value': instance.discountValue,
      'applied_promo': instance.appliedPromo?.toJson(),
      'quantity_of_sc_promo_item': instance.quantityOfScPromoItem,
    };

OrderAppliedPromoModel _$OrderAppliedPromoModelFromJson(
        Map<String, dynamic> json) =>
    OrderAppliedPromoModel(
      id: json['id'] as int?,
      code: json['code'] as String?,
      discount: json['discount'] as num?,
    );

Map<String, dynamic> _$OrderAppliedPromoModelToJson(
        OrderAppliedPromoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'discount': instance.discount,
    };

ItemAppliedPromoModel _$ItemAppliedPromoModelFromJson(
        Map<String, dynamic> json) =>
    ItemAppliedPromoModel(
      id: json['id'] as int?,
      code: json['code'] as String?,
      value: json['value'] as num?,
      isSeniorCitizenPromo: json['is_senior_citizen_promo'] as bool?,
    );

Map<String, dynamic> _$ItemAppliedPromoModelToJson(
        ItemAppliedPromoModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'code': instance.code,
      'value': instance.value,
      'is_senior_citizen_promo': instance.isSeniorCitizenPromo,
    };

DeliveryInfoModel _$DeliveryInfoModelFromJson(Map<String, dynamic> json) =>
    DeliveryInfoModel(
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      keywords: json['keywords'] as String?,
      lastName: json['last_name'] as String?,
      firstName: json['first_name'] as String?,
      instruction: json['instruction'] as String?,
    );

Map<String, dynamic> _$DeliveryInfoModelToJson(DeliveryInfoModel instance) =>
    <String, dynamic>{
      'email': instance.email,
      'phone': instance.phone,
      'address': instance.address,
      'keywords': instance.keywords,
      'last_name': instance.lastName,
      'first_name': instance.firstName,
      'instruction': instance.instruction,
    };
