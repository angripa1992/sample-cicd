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
      'orders': instance.orders,
      'total': instance.total,
      'page': instance.page,
      'size': instance.size,
    };

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: json['id'] as int?,
      externalId: json['external_id'] as String?,
      shortId: json['short_id'] as String?,
      providerId: json['provider_id'] as int?,
      brandId: json['brand_id'] as int?,
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
      vat: json['vat'] as int?,
      currency: json['currency'] as String?,
      currencySymbol: json['currency_symbol'] as String?,
      itemCount: json['item_count'] as int?,
      uniqueItemCount: json['unique_item_count'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      userId: json['user_id'] as int?,
      userFirstName: json['user_first_name'] as String?,
      userLastName: json['user_last_name'] as String?,
      userProfilePic: json['user_profile_pic'] as String?,
      userPhone: json['user_phone'] as String?,
      userEmail: json['user_email'] as String?,
      cart: (json['cart'] as List<dynamic>?)
          ?.map((e) => CartModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      cartV2: (json['cart_v2'] as List<dynamic>?)
          ?.map((e) => CartV2Model.fromJson(e as Map<String, dynamic>))
          .toList(),
      klikitStoreId: json['klikit_store_id'] as String?,
      type: json['type'] as int?,
      isFake: json['is_fake'] as bool?,
      isFoodpandaApiOrder: json['is_foodpanda_api_order'] as bool?,
      orderComment: json['order_comment'] as String?,
      deliveryComment: json['delivery_comment'] as String?,
      foodpandaToken: json['foodpanda_token'] as String?,
      isManualOrder: json['is_manual_order'] as bool?,
      source: json['source'] as int?,
      paymentMethod: json['payment_method'] as int?,
      paymentStatus: json['payment_status'] as int?,
      autoAccept: json['auto_accept'] as bool?,
      autoPilot: json['auto_pilot'] as bool?,
      autoPilotTime: json['auto_pilot_time'] as int?,
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
      'brand_id': instance.brandId,
      'brand_name': instance.brandName,
      'branch_id': instance.branchId,
      'item_price': instance.itemPrice,
      'final_price': instance.finalPrice,
      'merchant_discount': instance.merchantDiscount,
      'provider_discount': instance.providerDiscount,
      'delivery_fee': instance.deliveryFee,
      'additional_fee': instance.additionalFee,
      'currency_symbol': instance.currencySymbol,
      'item_count': instance.itemCount,
      'unique_item_count': instance.uniqueItemCount,
      'created_at': instance.createdAt,
      'updated_at': instance.updatedAt,
      'user_id': instance.userId,
      'user_first_name': instance.userFirstName,
      'user_last_name': instance.userLastName,
      'user_profile_pic': instance.userProfilePic,
      'user_phone': instance.userPhone,
      'user_email': instance.userEmail,
      'cart': instance.cart,
      'cart_v2': instance.cartV2,
      'klikit_store_id': instance.klikitStoreId,
      'is_fake': instance.isFake,
      'is_foodpanda_api_order': instance.isFoodpandaApiOrder,
      'order_comment': instance.orderComment,
      'delivery_comment': instance.deliveryComment,
      'foodpanda_token': instance.foodpandaToken,
      'is_manual_order': instance.isManualOrder,
      'payment_method': instance.paymentMethod,
      'payment_status': instance.paymentStatus,
      'auto_accept': instance.autoAccept,
      'auto_pilot': instance.autoPilot,
      'auto_pilot_time': instance.autoPilotTime,
    };

CartModel _$CartModelFromJson(Map<String, dynamic> json) => CartModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      options: json['options'] as List<dynamic>?,
      quantity: json['quantity'],
      unitPrice: (json['unit_price'] as num?)?.toDouble(),
      parentName: json['parent_name'] as String?,
      vat: json['vat'] as int?,
      image: json['image'] as String?,
      price: json['price'] as int?,
      title: json['title'] as String?,
      groups: json['groups'] as List<dynamic>?,
      itemId: json['item_id'] as int?,
      itemName: json['item_name'] as String?,
      itemFinalPrice: json['item_final_price'] as int?,
    );

Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'quantity': instance.quantity,
      'vat': instance.vat,
      'image': instance.image,
      'price': instance.price,
      'title': instance.title,
      'groups': instance.groups,
      'options': instance.options,
      'unit_price': instance.unitPrice,
      'parent_name': instance.parentName,
      'item_id': instance.itemId,
      'item_name': instance.itemName,
      'item_final_price': instance.itemFinalPrice,
    };

CartV2Model _$CartV2ModelFromJson(Map<String, dynamic> json) => CartV2Model(
      id: json['id'] as String?,
      name: json['name'] as String?,
      image: json['image'] as String?,
      price: json['price'] as String?,
      comment: json['comment'] as String?,
      quantity: json['quantity'] as int?,
      unitPrice: json['unit_price'] as String?,
      modifierGroups: json['modifier_groups'] as List<dynamic>?,
    );

Map<String, dynamic> _$CartV2ModelToJson(CartV2Model instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'price': instance.price,
      'comment': instance.comment,
      'quantity': instance.quantity,
      'unit_price': instance.unitPrice,
      'modifier_groups': instance.modifierGroups,
    };
