class Cart {
  final String id;
  final String name;
  final List<dynamic> options;
  final dynamic quantity;
  final double unitPrice;
  final String parentName;
  final int vat;
  final String image;
  final int price;
  final String title;
  final List<dynamic> groups;
  final int itemId;
  final String itemName;
  final int itemFinalPrice;

  Cart({
    required this.id,
    required this.name,
    required this.options,
    required this.quantity,
    required this.unitPrice,
    required this.parentName,
    required this.vat,
    required this.image,
    required this.price,
    required this.title,
    required this.groups,
    required this.itemId,
    required this.itemName,
    required this.itemFinalPrice,
  });
}

class CartV2 {
  final String id;
  final String name;
  final String image;
  final String price;
  final String comment;
  final int quantity;
  final String unitPrice;
  final List<dynamic> modifierGroups;

  CartV2({
    required this.id,
    required this.name,
    required this.image,
    required this.price,
    required this.comment,
    required this.quantity,
    required this.unitPrice,
    required this.modifierGroups,
  });
}
