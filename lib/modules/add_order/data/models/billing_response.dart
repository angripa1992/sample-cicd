import 'package:klikit/app/extensions.dart';

import '../../domain/entities/cart_bill.dart';
import 'applied_promo.dart';

class CartBillModel {
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
  num? itemPromoDiscount;
  num? orderPromoDiscount;
  num? orderPromoDiscountCent;
  num? totalPromoDiscount;
  num? manualDiscount;
  List<ItemBillModel>? items;
  int? numberOfSeniorCitizen;
  int? numberOfSeniorCustomer;
  Promo? appliedPromo;

  CartBillModel({
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
    this.items,
    this.numberOfSeniorCitizen,
    this.numberOfSeniorCustomer,
    this.appliedPromo,
    this.itemPromoDiscount,
    this.orderPromoDiscount,
    this.orderPromoDiscountCent,
    this.totalPromoDiscount,
    this.manualDiscount,
  });

  CartBillModel.fromJson(Map<String, dynamic> json) {
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
    restaurantServiceFeeCent = json['restaurant_service_fee_cent'];
    restaurantServiceFee = json['restaurant_service_fee'];
    itemPromoDiscount = json['item_promo_discount'];
    orderPromoDiscount = json['order_promo_discount'];
    orderPromoDiscountCent = json['order_promo_discount_cent'];
    totalPromoDiscount = json['total_promo_discount'];
    manualDiscount = json['manual_discount_amount'];
    numberOfSeniorCitizen = json['number_of_senior_citizen'];
    numberOfSeniorCustomer = json['number_of_customer'];
    appliedPromo = json['applied_promo'] != null ? Promo.fromJson(json['applied_promo']) : null;
    if (json['items'] != null) {
      items = <ItemBillModel>[];
      json['items'].forEach((v) {
        items!.add(ItemBillModel.fromJson(v));
      });
    }
  }

  CartBill toEntity() => CartBill(
        subTotal: subTotal ?? ZERO,
        subTotalCent: subTotalCent ?? ZERO,
        totalPrice: totalPrice ?? ZERO,
        totalPriceCent: totalPriceCent ?? ZERO,
        discountAmount: discountAmount ?? ZERO,
        discountAmountCent: discountAmountCent ?? ZERO,
        vatPrice: vatPrice ?? ZERO,
        vatPriceCent: vatPriceCent ?? ZERO,
        deliveryFee: deliveryFee ?? ZERO,
        deliveryFeeCent: deliveryFeeCent ?? ZERO,
        additionalFee: additionalFee ?? ZERO,
        additionalFeeCent: additionalFeeCent ?? ZERO,
        serviceFee: serviceFee ?? ZERO,
        serviceFeeCent: serviceFeeCent ?? ZERO,
        itemPromoDiscount: itemPromoDiscount ?? ZERO,
        orderPromoDiscount: orderPromoDiscount ?? ZERO,
        orderPromoDiscountCent: orderPromoDiscountCent ?? ZERO,
        totalPromoDiscount: totalPromoDiscount ?? ZERO,
        manualDiscount: manualDiscount ?? ZERO,
        items: items?.map((e) => e.toEntity()).toList() ?? [],
        numberOfSeniorCitizen: numberOfSeniorCitizen ?? ZERO,
        numberOfSeniorCustomer: numberOfSeniorCustomer ?? ZERO,
        appliedPromo: appliedPromo,
        restaurantServiceFee: restaurantServiceFee.orZero(),
        restaurantServiceFeeCent: restaurantServiceFeeCent.orZero(),
        merchantTotalPriceCent: ZERO,
        merchantTotalPrice: ZERO,
        feePaidByCustomer: false,
      );
}

class ItemBillModel {
  num? id;
  num? basePrice;
  num? modifiersPrice;
  num? itemPrice;
  num? discount;
  num? promoDiscount;
  num? promoDiscountCent;
  num? discountedItemPrice;
  num? quantity;
  num? itemFinalPrice;
  int? quantityOfPromoItem;
  Promo? appliedPromo;

  ItemBillModel({
    this.id,
    this.basePrice,
    this.modifiersPrice,
    this.itemPrice,
    this.discount,
    this.discountedItemPrice,
    this.quantity,
    this.itemFinalPrice,
    this.quantityOfPromoItem,
    this.appliedPromo,
    this.promoDiscount,
    this.promoDiscountCent,
  });

  ItemBillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    basePrice = json['base_price'];
    modifiersPrice = json['modifiers_price'];
    itemPrice = json['item_price'];
    discount = json['discount'];
    promoDiscount = json['promo_discount'];
    promoDiscountCent = json['promo_discount_cent'];
    discountedItemPrice = json['discounted_item_price'];
    quantity = json['quantity'];
    itemFinalPrice = json['item_final_price'];
    quantityOfPromoItem = json['quantity_of_sc_promo_item'];
    appliedPromo = json['applied_promo'] != null ? Promo.fromJson(json['applied_promo']) : null;
  }

  ItemBill toEntity() => ItemBill(
        id: id ?? ZERO,
        basePrice: basePrice ?? ZERO,
        modifiersPrice: modifiersPrice ?? ZERO,
        itemPrice: itemPrice ?? ZERO,
        discount: discount ?? ZERO,
        promoDiscount: promoDiscount ?? ZERO,
        promoDiscountCent: promoDiscountCent ?? ZERO,
        discountedItemPrice: discountedItemPrice ?? ZERO,
        quantity: quantity ?? ZERO,
        itemFinalPrice: itemFinalPrice ?? ZERO,
        quantityOfPromoItem: quantityOfPromoItem ?? ZERO,
        appliedPromo: appliedPromo,
      );
}
