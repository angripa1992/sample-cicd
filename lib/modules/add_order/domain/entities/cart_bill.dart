import '../../data/models/applied_promo.dart';

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
  final num itemPromoDiscount;
  final num orderPromoDiscount;
  final num orderPromoDiscountCent;
  final num totalPromoDiscount;
  final num manualDiscount;
  final List<ItemBill> items;
  final int numberOfSeniorCitizen;
  final int numberOfSeniorCustomer;
  final Promo? appliedPromo;
  final num restaurantServiceFee;
  final num restaurantServiceFeeCent;

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
    required this.itemPromoDiscount,
    required this.orderPromoDiscount,
    required this.orderPromoDiscountCent,
    required this.totalPromoDiscount,
    required this.manualDiscount,
    required this.items,
    required this.numberOfSeniorCitizen,
    required this.numberOfSeniorCustomer,
    required this.appliedPromo,
    required this.restaurantServiceFee,
    required this.restaurantServiceFeeCent,
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
  final num promoDiscount;
  final num promoDiscountCent;
  final num itemFinalPrice;
  final int quantityOfPromoItem;
  final Promo? appliedPromo;

  ItemBill({
    required this.id,
    required this.basePrice,
    required this.modifiersPrice,
    required this.itemPrice,
    required this.discount,
    required this.promoDiscount,
    required this.promoDiscountCent,
    required this.discountedItemPrice,
    required this.quantity,
    required this.itemFinalPrice,
    required this.quantityOfPromoItem,
    required this.appliedPromo,
  });
}
