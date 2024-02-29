import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/add_order/data/models/applied_promo.dart';
import 'package:klikit/modules/add_order/domain/entities/cart_bill.dart';

class WebShopCalculateBillResponse {
  num? subTotal;
  num? subTotalCent;
  num? totalPrice;
  num? totalPriceCent;
  num? discountAmount;
  num? discountAmountCent;
  num? vatPrice;
  num? vatPriceCent;
  num? deliveryFee;
  num? deliveryFeeCent;
  num? additionalFee;
  num? additionalFeeCent;
  num? serviceFee;
  num? serviceFeeCent;
  num? restaurantServiceFee;
  num? restaurantServiceFeeCent;
  num? gatewayFee;
  num? gatewayFeeCent;
  List<WebShopCalculateBillItem>? items;
  num? reservedKlikitFeeCent;
  num? totalPromoDiscount;
  num? totalPromoDiscountCent;
  num? merchantTotalPriceCent;
  num? merchantTotalPrice;
  num? customFee;
  num? rewardPrice;
  num? rewardPriceCent;
  bool? feePaidByCustomer;
  Promo? appliedPromo;
  int? numberOfSeniorCitizen;
  int? numberOfCustomer;

  WebShopCalculateBillResponse({
    this.subTotal,
    this.subTotalCent,
    this.totalPrice,
    this.totalPriceCent,
    this.discountAmount,
    this.discountAmountCent,
    this.vatPrice,
    this.vatPriceCent,
    this.deliveryFee,
    this.deliveryFeeCent,
    this.additionalFee,
    this.additionalFeeCent,
    this.serviceFee,
    this.serviceFeeCent,
    this.restaurantServiceFee,
    this.restaurantServiceFeeCent,
    this.gatewayFee,
    this.gatewayFeeCent,
    this.items,
    this.reservedKlikitFeeCent,
    this.totalPromoDiscount,
    this.totalPromoDiscountCent,
    this.merchantTotalPriceCent,
    this.merchantTotalPrice,
    this.customFee,
    this.feePaidByCustomer,
    this.appliedPromo,
    this.numberOfSeniorCitizen,
    this.numberOfCustomer,
    this.rewardPrice,
    this.rewardPriceCent,
  });

  WebShopCalculateBillResponse.fromJson(Map<String, dynamic> json) {
    subTotal = json['sub_total'];
    subTotalCent = json['sub_total_cent'];
    totalPrice = json['total_price'];
    totalPriceCent = json['total_price_cent'];
    discountAmount = json['discount_amount'];
    discountAmountCent = json['discount_amount_cent'];
    vatPrice = json['vat_price'];
    vatPriceCent = json['vat_price_cent'];
    deliveryFee = json['delivery_fee'];
    deliveryFeeCent = json['delivery_fee_cent'];
    additionalFee = json['additional_fee'];
    additionalFeeCent = json['additional_fee_cent'];
    serviceFee = json['service_fee'];
    serviceFeeCent = json['service_fee_cent'];
    restaurantServiceFee = json['restaurant_service_fee'];
    restaurantServiceFeeCent = json['restaurant_service_fee_cent'];
    gatewayFee = json['gateway_fee'];
    gatewayFeeCent = json['gateway_fee_cent'];
    if (json['items'] != null) {
      items = <WebShopCalculateBillItem>[];
      json['items'].forEach((v) {
        items!.add(WebShopCalculateBillItem.fromJson(v));
      });
    }
    reservedKlikitFeeCent = json['reserved_klikit_fee_cent'];
    totalPromoDiscount = json['total_promo_discount'];
    totalPromoDiscountCent = json['total_promo_discount_cent'];
    merchantTotalPriceCent = json['merchant_total_price_cent'];
    merchantTotalPrice = json['merchant_total_price'];
    customFee = json['custom_fee'];
    feePaidByCustomer = json['fee_paid_by_customer'];
    numberOfSeniorCitizen = json['number_of_senior_citizen'];
    numberOfCustomer = json['number_of_customer'];
    rewardPrice = json['reward_price'];
    rewardPriceCent = json['reward_price_cent'];
    appliedPromo = json['applied_promo'] != null ? Promo.fromJson(json['applied_promo']) : null;
  }

  CartBill toCartBill() {
    return CartBill(
      subTotal: subTotal.orZero(),
      subTotalCent: subTotalCent.orZero(),
      totalPrice: totalPrice.orZero(),
      totalPriceCent: totalPriceCent.orZero(),
      discountAmount: discountAmount.orZero(),
      discountAmountCent: discountAmountCent.orZero(),
      vatPrice: vatPrice.orZero(),
      vatPriceCent: vatPriceCent.orZero(),
      deliveryFee: deliveryFee.orZero(),
      deliveryFeeCent: deliveryFeeCent.orZero(),
      additionalFee: additionalFee.orZero(),
      additionalFeeCent: additionalFeeCent.orZero(),
      serviceFee: serviceFee.orZero(),
      serviceFeeCent: serviceFeeCent.orZero(),
      itemPromoDiscount: 0,
      orderPromoDiscount: totalPromoDiscount.orZero(),
      orderPromoDiscountCent: totalPromoDiscountCent.orZero(),
      totalPromoDiscount: totalPromoDiscount.orZero(),
      manualDiscount: 0,
      items: items?.map((item) => item.toItemBill()).toList() ?? [],
      numberOfSeniorCitizen: numberOfSeniorCitizen.orZero(),
      numberOfSeniorCustomer: numberOfCustomer.orZero(),
      appliedPromo: appliedPromo,
      restaurantServiceFee: restaurantServiceFee.orZero(),
      restaurantServiceFeeCent: restaurantServiceFeeCent.orZero(),
      merchantTotalPriceCent: merchantTotalPriceCent.orZero(),
      merchantTotalPrice: merchantTotalPrice.orZero(),
      feePaidByCustomer: feePaidByCustomer.orFalse(),
      customFee: customFee.orZero(),
      roundOffAmountCent: ZERO,
      roundOffAmount: ZERO,
      rewardPrice: rewardPrice.orZero(),
      rewarPriceCent: rewardPriceCent.orZero(),
    );
  }
}

class WebShopCalculateBillItem {
  int? id;
  num? basePrice;
  num? modifiersPrice;
  num? itemPrice;
  num? discount;
  num? discountedItemPrice;
  num? quantity;
  num? itemFinalPrice;

  WebShopCalculateBillItem({
    this.id,
    this.basePrice,
    this.modifiersPrice,
    this.itemPrice,
    this.discount,
    this.discountedItemPrice,
    this.quantity,
    this.itemFinalPrice,
  });

  WebShopCalculateBillItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    basePrice = json['base_price'];
    modifiersPrice = json['modifiers_price'];
    itemPrice = json['item_price'];
    discount = json['discount'];
    discountedItemPrice = json['discounted_item_price'];
    quantity = json['quantity'];
    itemFinalPrice = json['item_final_price'];
  }

  ItemBill toItemBill() {
    return ItemBill(
      id: id.orZero(),
      basePrice: basePrice.orZero(),
      modifiersPrice: modifiersPrice.orZero(),
      itemPrice: itemPrice.orZero(),
      discount: discount.orZero(),
      promoDiscount: 0,
      promoDiscountCent: 0,
      discountedItemPrice: discountedItemPrice.orZero(),
      quantity: quantity.orZero(),
      itemFinalPrice: itemFinalPrice.orZero(),
      quantityOfPromoItem: 0,
      appliedPromo: null,
    );
  }
}
