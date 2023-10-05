import 'package:klikit/modules/add_order/data/models/applied_promo.dart';

class WebShopOrderDetailsModel {
  String? id;
  String? tableNo;
  String? shortId;
  int? menuVersion;
  int? restaurantServiceFee;
  String? identity;
  String? externalId;
  int? businessId;
  int? branchId;
  int? itemPrice;
  int? finalPrice;
  int? discountAmount;
  int? deliveryFee;
  int? additionalFee;
  int? serviceFee;
  int? gatewayFee;
  int? vatAmount;
  String? currency;
  int? currencyId;
  String? currencySymbol;
  int? totalItems;
  int? uniqueItems;
  List<WebShopCartModel>? cart;
  WebShopUserModel? user;
  String? platform;
  int? type;
  Promo? appliedPromo;
  int? numberOfSeniorCitizen;
  int? numberOfCustomer;
  int? orderPromoDiscount;
  String? orderComment;
  String? scheduledDeliveryTime;
  int? scheduledOrderDuration;
  bool? autoAcceptEnabled;
  int? paymentMethod;
  int? paymentStatus;
  int? paymentChannelId;
  String? paymentInvoiceId;
  String? paymentChannel;
  int? status;
  bool? isThreePlOrder;
  dynamic fulfillmentSender;
  dynamic fulfillmentReceiver;
  dynamic fulfillmentMeta;
  dynamic fulfillmentExpectedPickupTime;
  dynamic fulfillmentExpectedDeliveryTime;
  bool? orderAutoAcceptEnabled;

  WebShopOrderDetailsModel({
    this.id,
    this.tableNo,
    this.shortId,
    this.menuVersion,
    this.restaurantServiceFee,
    this.identity,
    this.externalId,
    this.businessId,
    this.branchId,
    this.itemPrice,
    this.finalPrice,
    this.discountAmount,
    this.deliveryFee,
    this.additionalFee,
    this.serviceFee,
    this.gatewayFee,
    this.vatAmount,
    this.currency,
    this.currencyId,
    this.currencySymbol,
    this.totalItems,
    this.uniqueItems,
    this.cart,
    this.user,
    this.platform,
    this.type,
    this.appliedPromo,
    this.numberOfSeniorCitizen,
    this.numberOfCustomer,
    this.orderPromoDiscount,
    this.orderComment,
    this.scheduledDeliveryTime,
    this.scheduledOrderDuration,
    this.autoAcceptEnabled,
    this.paymentMethod,
    this.paymentStatus,
    this.paymentChannelId,
    this.paymentInvoiceId,
    this.paymentChannel,
    this.status,
    this.isThreePlOrder,
    this.fulfillmentSender,
    this.fulfillmentReceiver,
    this.fulfillmentMeta,
    this.fulfillmentExpectedPickupTime,
    this.fulfillmentExpectedDeliveryTime,
    this.orderAutoAcceptEnabled,
  });

  WebShopOrderDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tableNo = json['table_no'];
    shortId = json['short_id'];
    menuVersion = json['menu_version'];
    restaurantServiceFee = json['restaurant_service_fee'];
    identity = json['identity'];
    externalId = json['external_id'];
    businessId = json['business_id'];
    branchId = json['branch_id'];
    itemPrice = json['item_price'];
    finalPrice = json['final_price'];
    discountAmount = json['discount_amount'];
    deliveryFee = json['delivery_fee'];
    additionalFee = json['additional_fee'];
    serviceFee = json['service_fee'];
    gatewayFee = json['gateway_fee'];
    vatAmount = json['vat_amount'];
    currency = json['currency'];
    currencyId = json['currency_id'];
    currencySymbol = json['currency_symbol'];
    totalItems = json['total_items'];
    uniqueItems = json['unique_items'];
    if (json['cart'] != null) {
      cart = <WebShopCartModel>[];
      json['cart'].forEach((v) {
        cart!.add(WebShopCartModel.fromJson(v));
      });
    }
    user = json['user'] != null ? WebShopUserModel.fromJson(json['user']) : null;
    platform = json['platform'];
    type = json['type'];
    appliedPromo = json['applied_promo'] != null ? Promo.fromJson(json['applied_promo']) : null;
    numberOfSeniorCitizen = json['number_of_senior_citizen'];
    numberOfCustomer = json['number_of_customer'];
    orderPromoDiscount = json['order_promo_discount'];
    orderComment = json['order_comment'];
    scheduledDeliveryTime = json['scheduled_delivery_time'];
    scheduledOrderDuration = json['scheduled_order_duration'];
    autoAcceptEnabled = json['auto_accept_enabled'];
    paymentMethod = json['payment_method'];
    paymentStatus = json['payment_status'];
    paymentChannelId = json['payment_channel_id'];
    paymentInvoiceId = json['payment_invoice_id'];
    paymentChannel = json['payment_channel'];
    status = json['status'];
    isThreePlOrder = json['is_three_pl_order'];
    fulfillmentSender = json['fulfillment_sender'];
    fulfillmentReceiver = json['fulfillment_receiver'];
    fulfillmentMeta = json['fulfillment_meta'];
    fulfillmentExpectedPickupTime = json['fulfillment_expected_pickup_time'];
    fulfillmentExpectedDeliveryTime = json['fulfillment_expected_delivery_time'];
    orderAutoAcceptEnabled = json['order_auto_accept_enabled'];
  }
}

class WebShopCartModel {
  int? itemId;
  String? itemName;
  String? image;
  String? title;
  int? quantity;
  int? unitPrice;
  int? price;
  int? itemFinalPrice;
  int? vat;
  num? discountValue;
  int? discountType;
  List<WebShopModifierGroupModel>? groups;
  WebShopMenuBrandModel? brand;
  Promo? appliedPromo;
  int? quantityOfScPromoItem;
  int? promoDiscount;
  String? comment;
  int? klikitId;
  String? klikitName;
  int? klikitPrice;
  String? klikitSkuId;
  String? klikitImage;
  int? klikitSectionId;
  String? klikitSectionName;
  int? klikitCategoryId;
  String? klikitCategoryName;

  WebShopCartModel({
    this.itemId,
    this.itemName,
    this.image,
    this.title,
    this.quantity,
    this.unitPrice,
    this.price,
    this.itemFinalPrice,
    this.vat,
    this.discountValue,
    this.discountType,
    this.groups,
    this.brand,
    this.appliedPromo,
    this.quantityOfScPromoItem,
    this.promoDiscount,
    this.comment,
    this.klikitId,
    this.klikitName,
    this.klikitPrice,
    this.klikitSkuId,
    this.klikitImage,
    this.klikitSectionId,
    this.klikitSectionName,
    this.klikitCategoryId,
    this.klikitCategoryName,
  });

  WebShopCartModel.fromJson(Map<String, dynamic> json) {
    itemId = json['item_id'];
    itemName = json['item_name'];
    image = json['image'];
    title = json['title'];
    quantity = json['quantity'];
    unitPrice = json['unit_price'];
    price = json['price'];
    itemFinalPrice = json['item_final_price'];
    vat = json['vat'];
    discountValue = json['discount_value'];
    discountType = json['discount_type'];
    if (json['groups'] != null) {
      groups = <WebShopModifierGroupModel>[];
      json['groups'].forEach((v) {
        groups!.add(WebShopModifierGroupModel.fromJson(v));
      });
    }
    brand = json['brand'] != null ? WebShopMenuBrandModel.fromJson(json['brand']) : null;
    appliedPromo = json['applied_promo'];
    quantityOfScPromoItem = json['quantity_of_sc_promo_item'];
    promoDiscount = json['promo_discount'];
    comment = json['comment'];
    klikitId = json['klikit_id'];
    klikitName = json['klikit_name'];
    klikitPrice = json['klikit_price'];
    klikitSkuId = json['klikit_sku_id'];
    klikitImage = json['klikit_image'];
    klikitSectionId = json['klikit_section_id'];
    klikitSectionName = json['klikit_section_name'];
    klikitCategoryId = json['klikit_category_id'];
    klikitCategoryName = json['klikit_category_name'];
  }
}

class WebShopModifierGroupModel {
  int? groupId;
  String? title;
  WebShopModifierGroupRuleModel? rule;
  List<WebShopModifierModel>? modifiers;
  int? klikitGroupId;
  String? klikitGroupName;

  WebShopModifierGroupModel({
    this.groupId,
    this.title,
    this.rule,
    this.modifiers,
    this.klikitGroupId,
    this.klikitGroupName,
  });

  WebShopModifierGroupModel.fromJson(Map<String, dynamic> json) {
    groupId = json['group_id'];
    title = json['title'];
    rule = json['rule'] != null ? WebShopModifierGroupRuleModel.fromJson(json['rule']) : null;
    if (json['modifiers'] != null) {
      modifiers = <WebShopModifierModel>[];
      json['modifiers'].forEach((v) {
        modifiers!.add(WebShopModifierModel.fromJson(v));
      });
    }
    klikitGroupId = json['klikit_group_id'];
    klikitGroupName = json['klikit_group_name'];
  }
}

class WebShopModifierGroupRuleModel {
  int? id;
  String? title;
  String? typeTitle;
  int? value;
  int? min;
  int? max;
  int? brandId;

  WebShopModifierGroupRuleModel({
    this.id,
    this.title,
    this.typeTitle,
    this.value,
    this.min,
    this.max,
    this.brandId,
  });

  WebShopModifierGroupRuleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    typeTitle = json['type_title'];
    value = json['value'];
    min = json['min'];
    max = json['max'];
    brandId = json['brand_id'];
  }
}

class WebShopModifierModel {
  int? id;
  int? modifierId;
  String? title;
  int? modifierQuantity;
  bool? isSelected;
  int? extraPrice;
  List<WebShopModifierGroupModel>? groups;
  int? klikitId;
  String? klikitName;
  int? klikitPrice;
  String? klikitSkuId;
  String? klikitImage;
  int? klikitGroupId;
  String? klikitGroupName;

  WebShopModifierModel({
    this.id,
    this.modifierId,
    this.title,
    this.modifierQuantity,
    this.isSelected,
    this.extraPrice,
    this.groups,
    this.klikitId,
    this.klikitName,
    this.klikitPrice,
    this.klikitSkuId,
    this.klikitImage,
    this.klikitGroupId,
    this.klikitGroupName,
  });

  WebShopModifierModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modifierId = json['modifier_id'];
    title = json['title'];
    modifierQuantity = json['modifier_quantity'];
    isSelected = json['is_selected'];
    extraPrice = json['extra_price'];
    if (json['groups'] != null) {
      groups = <WebShopModifierGroupModel>[];
      json['groups'].forEach((v) {
        groups!.add(WebShopModifierGroupModel.fromJson(v));
      });
    }
    klikitId = json['klikit_id'];
    klikitName = json['klikit_name'];
    klikitPrice = json['klikit_price'];
    klikitSkuId = json['klikit_sku_id'];
    klikitImage = json['klikit_image'];
    klikitGroupId = json['klikit_group_id'];
    klikitGroupName = json['klikit_group_name'];
  }
}

class WebShopMenuBrandModel {
  int? id;
  String? title;
  String? logo;

  WebShopMenuBrandModel({this.id, this.title, this.logo});

  WebShopMenuBrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    logo = json['logo'];
  }
}

class WebShopUserModel {
  int? id;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? logo;

  WebShopUserModel({
    this.id,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
    this.logo,
  });

  WebShopUserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    phone = json['phone'];
    email = json['email'];
    logo = json['logo'];
  }
}
