class OrderAppliedPromos {
  final int id;
  final String code;
  final num discount;

  OrderAppliedPromos({
    required this.id,
    required this.code,
    required this.discount,
  });
}

class ItemAppliedPromo {
  final int id;
  final String code;
  final num value;
  final bool isSeniorCitizenPromo;

  ItemAppliedPromo({
    required this.id,
    required this.code,
    required this.value,
    required this.isSeniorCitizenPromo,
  });
}
