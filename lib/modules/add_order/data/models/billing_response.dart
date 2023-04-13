import 'package:klikit/app/extensions.dart';

import '../../domain/entities/billing_response.dart';

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
  List<ItemBillModel>? items;

  CartBillModel(
      {this.subTotal,
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
      this.items});

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
        items: items?.map((e) => e.toEntity()).toList() ?? [],
      );
}

class ItemBillModel {
  num? id;
  num? basePrice;
  num? modifiersPrice;
  num? itemPrice;
  num? discount;
  num? discountedItemPrice;
  num? quantity;
  num? itemFinalPrice;

  ItemBillModel({
    this.id,
    this.basePrice,
    this.modifiersPrice,
    this.itemPrice,
    this.discount,
    this.discountedItemPrice,
    this.quantity,
    this.itemFinalPrice,
  });

  ItemBillModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    basePrice = json['base_price'];
    modifiersPrice = json['modifiers_price'];
    itemPrice = json['item_price'];
    discount = json['discount'];
    discountedItemPrice = json['discounted_item_price'];
    quantity = json['quantity'];
    itemFinalPrice = json['item_final_price'];
  }

  ItemBill toEntity() => ItemBill(
        id: id ?? ZERO,
        basePrice: basePrice ?? ZERO,
        modifiersPrice: modifiersPrice ?? ZERO,
        itemPrice: itemPrice ?? ZERO,
        discount: discount ?? ZERO,
        discountedItemPrice: discountedItemPrice ?? ZERO,
        quantity: quantity ?? ZERO,
        itemFinalPrice: itemFinalPrice ?? ZERO,
      );
}
