class CartBill {
  final num subTotal;
  final num subTotalCent;
  final num totalPrice;
  final num totalPriceCent;
  final num discountAmount;
  final num discountAmountCent;
  final num vatPrice;
  final num vatPriceCent;
  final num deliveryFee;
  final num deliveryFeeCent;
  final num additionalFee;
  final num additionalFeeCent;
  final num serviceFee;
  final num serviceFeeCent;
  final List<ItemBill> items;

  CartBill({
    required this.subTotal,
    required this.subTotalCent,
    required this.totalPrice,
    required this.totalPriceCent,
    required this.discountAmount,
    required this.discountAmountCent,
    required this.vatPrice,
    required this.vatPriceCent,
    required this.deliveryFee,
    required this.deliveryFeeCent,
    required this.additionalFee,
    required this.additionalFeeCent,
    required this.serviceFee,
    required this.serviceFeeCent,
    required this.items,
  });
}

class ItemBill {
  final num id;
  final num basePrice;
  final num modifiersPrice;
  final num itemPrice;
  final num discount;
  final num discountedItemPrice;
  final num quantity;
  final num itemFinalPrice;

  ItemBill({
    required this.id,
    required this.basePrice,
    required this.modifiersPrice,
    required this.itemPrice,
    required this.discount,
    required this.discountedItemPrice,
    required this.quantity,
    required this.itemFinalPrice,
  });
}
