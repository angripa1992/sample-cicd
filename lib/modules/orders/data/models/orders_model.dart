import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/orders/domain/entities/cart.dart';

import '../../domain/entities/order.dart';

part 'orders_model.g.dart';

@JsonSerializable()
class OrdersModel {
  List<OrderModel>? orders;
  int? total;
  int? page;
  int? size;

  OrdersModel({this.orders, this.total, this.page, this.size});

  factory OrdersModel.fromJson(Map<String, dynamic> json) =>
      _$OrdersModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrdersModelToJson(this);

  Orders toEntity() {
    if (orders == null) {
      return Orders(
        data: [],
        total: 0,
        page: 0,
        size: 0,
      );
    }
    List<Order> orderList = [];
    for (var order in orders!) {
      orderList.add(order.toEntity());
    }
    return Orders(
      data: orderList,
      total: total.orZero(),
      page: page.orZero(),
      size: size.orZero(),
    );
  }
}

@JsonSerializable()
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
  @JsonKey(name: 'brand_id')
  int? brandId;
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
  @JsonKey(name: 'currency_symbol')
  String? currencySymbol;
  @JsonKey(name: 'item_count')
  int? itemCount;
  @JsonKey(name: 'unique_item_count')
  int? uniqueItemCount;
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
  List<CartModel>? cart;
  @JsonKey(name: 'cart_v2')
  List<CartV2Model>? cartV2;
  @JsonKey(name: 'klikit_store_id')
  String? klikitStoreId;
  @JsonKey(name: 'is_fake')
  bool? isFake;
  @JsonKey(name: 'is_foodpanda_api_order')
  bool? isFoodpandaApiOrder;
  @JsonKey(name: 'order_comment')
  String? orderComment;
  @JsonKey(name: 'delivery_comment')
  String? deliveryComment;
  @JsonKey(name: 'foodpanda_token')
  String? foodpandaToken;
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

  OrderModel(
      {this.id,
      this.externalId,
      this.shortId,
      this.providerId,
      this.brandId,
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
      this.vat,
      this.currency,
      this.currencySymbol,
      this.itemCount,
      this.uniqueItemCount,
      this.createdAt,
      this.updatedAt,
      this.userId,
      this.userFirstName,
      this.userLastName,
      this.userProfilePic,
      this.userPhone,
      this.userEmail,
      this.cart,
      this.cartV2,
      this.klikitStoreId,
      this.type,
      this.isFake,
      this.isFoodpandaApiOrder,
      this.orderComment,
      this.deliveryComment,
      this.foodpandaToken,
      this.isManualOrder,
      this.source,
      this.paymentMethod,
      this.paymentStatus,
      this.autoAccept,
      this.autoPilot,
      this.autoPilotTime});

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  Order toEntity() {
    return Order(
      id: id.orZero(),
      externalId: externalId.orEmpty(),
      shortId: shortId.orEmpty(),
      providerId: providerId.orZero(),
      brandId: brandId.orZero(),
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
      userId: userId.orZero(),
      userFirstName: userFirstName.orEmpty(),
      userLastName: userLastName.orEmpty(),
      userProfilePic: userProfilePic.orEmpty(),
      userPhone: userPhone.orEmpty(),
      userEmail: userEmail.orEmpty(),
      cart: toCartListEntity(),
      cartV2: toCartV2ListEntity(),
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
    );
  }

  List<Cart> toCartListEntity() {
    if (cart == null) {
      return [];
    }
    List<Cart> carts = [];
    for (var item in cart!) {
      carts.add(item.toEntity());
    }
    return carts;
  }

  List<CartV2> toCartV2ListEntity() {
    if (cartV2 == null) {
      return [];
    }
    List<CartV2> carts = [];
    for (var item in cartV2!) {
      carts.add(item.toEntity());
    }
    return carts;
  }
}

@JsonSerializable()
class CartModel {
  String? id;
  String? name;
  dynamic quantity;
  int? vat;
  String? image;
  int? price;
  String? title;
  List<dynamic>? groups;
  List<dynamic>? options;
  @JsonKey(name: 'unit_price')
  dynamic unitPrice;
  @JsonKey(name: 'parent_name')
  String? parentName;
  @JsonKey(name: 'item_id')
  int? itemId;
  @JsonKey(name: 'item_name')
  String? itemName;
  @JsonKey(name: 'item_final_price')
  int? itemFinalPrice;

  CartModel({
    this.id,
    this.name,
    this.options,
    this.quantity,
    this.unitPrice,
    this.parentName,
    this.vat,
    this.image,
    this.price,
    this.title,
    this.groups,
    this.itemId,
    this.itemName,
    this.itemFinalPrice,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) =>
      _$CartModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartModelToJson(this);

  Cart toEntity() {
    return Cart(
      id: id.orEmpty(),
      name: name.orEmpty(),
      options: options ?? [],
      quantity: quantity,
      unitPrice: unitPrice,
      parentName: parentName.orEmpty(),
      vat: vat.orZero(),
      image: image.orEmpty(),
      price: price.orZero(),
      title: title.orEmpty(),
      groups: groups ?? [],
      itemId: itemId.orZero(),
      itemName: itemName.orEmpty(),
      itemFinalPrice: itemFinalPrice.orZero(),
    );
  }
}

@JsonSerializable()
class CartV2Model {
  String? id;
  String? name;
  String? image;
  String? price;
  String? comment;
  int? quantity;
  @JsonKey(name: 'unit_price')
  String? unitPrice;
  @JsonKey(name: 'modifier_groups')
  List<dynamic>? modifierGroups;

  CartV2Model({
    this.id,
    this.name,
    this.image,
    this.price,
    this.comment,
    this.quantity,
    this.unitPrice,
    this.modifierGroups,
  });

  factory CartV2Model.fromJson(Map<String, dynamic> json) =>
      _$CartV2ModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartV2ModelToJson(this);

  CartV2 toEntity() {
    return CartV2(
      id: id.orEmpty(),
      name: name.orEmpty(),
      image: image.orEmpty(),
      price: price.orEmpty(),
      comment: comment.orEmpty(),
      quantity: quantity.orZero(),
      unitPrice: unitPrice.orEmpty(),
      modifierGroups: modifierGroups ?? [],
    );
  }
}
