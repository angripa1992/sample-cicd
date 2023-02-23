// class ManualOrder {
//   int? branchId;
//   int? brandId;
//   String? brandName;
//   String? currency;
//   String? currencySymbol;
//   int? source;
//   int? type;
//   int? paymentStatus;
//   User? user;
//   int? itemPrice;
//   int? finalPrice;
//   int? deliveryFee;
//   int? vatAmount;
//   int? discountAmount;
//   int? additionalFee;
//   List<Cart>? cart;
//   int? uniqueItems;
//   int? totalItems;
//   int? currencyId;
//   int? discountValue;
//   int? discountType;
//
//   ManualOrder({this.branchId, this.brandId, this.brandName, this.currency, this.currencySymbol, this.source, this.type, this.paymentStatus, this.user, this.itemPrice, this.finalPrice, this.deliveryFee, this.vatAmount, this.discountAmount, this.additionalFee, this.cart, this.uniqueItems, this.totalItems, this.currencyId, this.discountValue, this.discountType});
//
//   ManualOrder.fromJson(Map<String, dynamic> json) {
//     branchId = json['branch_id'];
//     brandId = json['brand_id'];
//     brandName = json['brand_name'];
//     currency = json['currency'];
//     currencySymbol = json['currency_symbol'];
//     source = json['source'];
//     type = json['type'];
//     paymentStatus = json['payment_status'];
//     user = json['user'] != null ? new User.fromJson(json['user']) : null;
//     itemPrice = json['item_price'];
//     finalPrice = json['final_price'];
//     deliveryFee = json['delivery_fee'];
//     vatAmount = json['vat_amount'];
//     discountAmount = json['discount_amount'];
//     additionalFee = json['additional_fee'];
//     if (json['cart'] != null) {
//       cart = <Cart>[];
//       json['cart'].forEach((v) { cart!.add(new Cart.fromJson(v)); });
//     }
//     uniqueItems = json['unique_items'];
//     totalItems = json['total_items'];
//     currencyId = json['currency_id'];
//     discountValue = json['discount_value'];
//     discountType = json['discount_type'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['branch_id'] = this.branchId;
//     data['brand_id'] = this.brandId;
//     data['brand_name'] = this.brandName;
//     data['currency'] = this.currency;
//     data['currency_symbol'] = this.currencySymbol;
//     data['source'] = this.source;
//     data['type'] = this.type;
//     data['payment_status'] = this.paymentStatus;
//     if (this.user != null) {
//       data['user'] = this.user!.toJson();
//     }
//     data['item_price'] = this.itemPrice;
//     data['final_price'] = this.finalPrice;
//     data['delivery_fee'] = this.deliveryFee;
//     data['vat_amount'] = this.vatAmount;
//     data['discount_amount'] = this.discountAmount;
//     data['additional_fee'] = this.additionalFee;
//     if (this.cart != null) {
//       data['cart'] = this.cart!.map((v) => v.toJson()).toList();
//     }
//     data['unique_items'] = this.uniqueItems;
//     data['total_items'] = this.totalItems;
//     data['currency_id'] = this.currencyId;
//     data['discount_value'] = this.discountValue;
//     data['discount_type'] = this.discountType;
//     return data;
//   }
// }
//
// class User {
//
// User.fromJson(Map<String, dynamic> json) {
// }
//
// Map<String, dynamic> toJson() {
//   final Map<String, dynamic> data = new Map<String, dynamic>();
//   return data;
// }
// }
//
// class Cart {
//   int? id;
//   String? title;
//   List<Prices>? prices;
//   int? vat;
//   String? description;
//   String? image;
//   bool? enabled;
//   bool? hidden;
//   List<Statuses>? statuses;
//   int? sequence;
//   int? defaultItemId;
//   Stock? stock;
//   TitleV2? titleV2;
//   TitleV2? descriptionV2;
//   String? cartId;
//   int? itemId;
//   double? unitPrice;
//   List<Groups>? groups;
//   int? quantity;
//   bool? hasModifierGroups;
//
//   Cart({this.id, this.title, this.prices, this.vat, this.description, this.image, this.enabled, this.hidden, this.statuses, this.sequence, this.defaultItemId, this.stock, this.titleV2, this.descriptionV2, this.cartId, this.itemId, this.unitPrice, this.groups, this.quantity, this.hasModifierGroups});
//
//   Cart.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     if (json['prices'] != null) {
//       prices = <Prices>[];
//       json['prices'].forEach((v) { prices!.add(new Prices.fromJson(v)); });
//     }
//     vat = json['vat'];
//     description = json['description'];
//     image = json['image'];
//     enabled = json['enabled'];
//     hidden = json['hidden'];
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) { statuses!.add(new Statuses.fromJson(v)); });
//     }
//     sequence = json['sequence'];
//     defaultItemId = json['default_item_id'];
//     stock = json['stock'] != null ? new Stock.fromJson(json['stock']) : null;
//     titleV2 = json['title_v2'] != null ? new TitleV2.fromJson(json['title_v2']) : null;
//     descriptionV2 = json['description_v2'] != null ? new TitleV2.fromJson(json['description_v2']) : null;
//     cartId = json['cart_id'];
//     itemId = json['item_id'];
//     unitPrice = json['unit_price'];
//     if (json['groups'] != null) {
//       groups = <Groups>[];
//       json['groups'].forEach((v) { groups!.add(new Groups.fromJson(v)); });
//     }
//     quantity = json['quantity'];
//     hasModifierGroups = json['has_modifier_groups'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     if (this.prices != null) {
//       data['prices'] = this.prices!.map((v) => v.toJson()).toList();
//     }
//     data['vat'] = this.vat;
//     data['description'] = this.description;
//     data['image'] = this.image;
//     data['enabled'] = this.enabled;
//     data['hidden'] = this.hidden;
//     if (this.statuses != null) {
//       data['statuses'] = this.statuses!.map((v) => v.toJson()).toList();
//     }
//     data['sequence'] = this.sequence;
//     data['default_item_id'] = this.defaultItemId;
//     if (this.stock != null) {
//       data['stock'] = this.stock!.toJson();
//     }
//     if (this.titleV2 != null) {
//       data['title_v2'] = this.titleV2!.toJson();
//     }
//     if (this.descriptionV2 != null) {
//       data['description_v2'] = this.descriptionV2!.toJson();
//     }
//     data['cart_id'] = this.cartId;
//     data['item_id'] = this.itemId;
//     data['unit_price'] = this.unitPrice;
//     if (this.groups != null) {
//       data['groups'] = this.groups!.map((v) => v.toJson()).toList();
//     }
//     data['quantity'] = this.quantity;
//     data['has_modifier_groups'] = this.hasModifierGroups;
//     return data;
//   }
// }
//
// class Prices {
//   int? providerId;
//   int? currencyId;
//   String? code;
//   String? symbol;
//   double? price;
//
//   Prices({this.providerId, this.currencyId, this.code, this.symbol, this.price});
//
//   Prices.fromJson(Map<String, dynamic> json) {
//     providerId = json['provider_id'];
//     currencyId = json['currency_id'];
//     code = json['code'];
//     symbol = json['symbol'];
//     price = json['price'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['provider_id'] = this.providerId;
//     data['currency_id'] = this.currencyId;
//     data['code'] = this.code;
//     data['symbol'] = this.symbol;
//     data['price'] = this.price;
//     return data;
//   }
// }
//
// class Statuses {
//   int? providerId;
//   bool? hidden;
//
//   Statuses({this.providerId, this.hidden});
//
//   Statuses.fromJson(Map<String, dynamic> json) {
//     providerId = json['provider_id'];
//     hidden = json['hidden'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['provider_id'] = providerId;
//     data['hidden'] = hidden;
//     return data;
//   }
// }
//
// class Stock {
//   bool? available;
//   Null? snooze;
//
//   Stock({this.available, this.snooze});
//
//   Stock.fromJson(Map<String, dynamic> json) {
//     available = json['available'];
//     snooze = json['snooze'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['available'] = this.available;
//     data['snooze'] = this.snooze;
//     return data;
//   }
// }
//
// class TitleV2 {
//   String? en;
//
//   TitleV2({this.en});
//
//   TitleV2.fromJson(Map<String, dynamic> json) {
//     en = json['en'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['en'] = this.en;
//     return data;
//   }
// }
//
// class Groups {
//   int? groupId;
//   String? title;
//   String? label;
//   int? brandId;
//   int? sequence;
//   TitleV2? titleV2;
//   List<Statuses>? statuses;
//   Rule? rule;
//   List<Modifiers>? modifiers;
//
//   Groups({this.groupId, this.title, this.label, this.brandId, this.sequence, this.titleV2, this.statuses, this.rule, this.modifiers});
//
//   Groups.fromJson(Map<String, dynamic> json) {
//     groupId = json['group_id'];
//     title = json['title'];
//     label = json['label'];
//     brandId = json['brand_id'];
//     sequence = json['sequence'];
//     titleV2 = json['title_v2'] != null ? new TitleV2.fromJson(json['title_v2']) : null;
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) { statuses!.add(new Statuses.fromJson(v)); });
//     }
//     rule = json['rule'] != null ? new Rule.fromJson(json['rule']) : null;
//     if (json['modifiers'] != null) {
//       modifiers = <Modifiers>[];
//       json['modifiers'].forEach((v) { modifiers!.add(new Modifiers.fromJson(v)); });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['group_id'] = this.groupId;
//     data['title'] = this.title;
//     data['label'] = this.label;
//     data['brand_id'] = this.brandId;
//     data['sequence'] = this.sequence;
//     if (this.titleV2 != null) {
//       data['title_v2'] = this.titleV2!.toJson();
//     }
//     if (this.statuses != null) {
//       data['statuses'] = this.statuses!.map((v) => v.toJson()).toList();
//     }
//     if (this.rule != null) {
//       data['rule'] = this.rule!.toJson();
//     }
//     if (this.modifiers != null) {
//       data['modifiers'] = this.modifiers!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Statuses {
//   int? providerId;
//   bool? enabled;
//   bool? hidden;
//
//   Statuses({this.providerId, this.enabled, this.hidden});
//
//   Statuses.fromJson(Map<String, dynamic> json) {
//     providerId = json['provider_id'];
//     enabled = json['enabled'];
//     hidden = json['hidden'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['provider_id'] = this.providerId;
//     data['enabled'] = this.enabled;
//     data['hidden'] = this.hidden;
//     return data;
//   }
// }
//
// class Rule {
//   int? id;
//   String? title;
//   String? typeTitle;
//   int? value;
//   int? brandId;
//   TitleV2? titleV2;
//   int? min;
//
//   Rule({this.id, this.title, this.typeTitle, this.value, this.brandId, this.titleV2, this.min});
//
//   Rule.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     typeTitle = json['type_title'];
//     value = json['value'];
//     brandId = json['brand_id'];
//     titleV2 = json['title_v2'] != null ? new TitleV2.fromJson(json['title_v2']) : null;
//     min = json['min'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['type_title'] = this.typeTitle;
//     data['value'] = this.value;
//     data['brand_id'] = this.brandId;
//     if (this.titleV2 != null) {
//       data['title_v2'] = this.titleV2!.toJson();
//     }
//     data['min'] = this.min;
//     return data;
//   }
// }
//
// class Modifiers {
//   int? id;
//   int? modifierId;
//   int? immgId;
//   String? title;
//   int? sequence;
//   TitleV2? titleV2;
//   List<Statuses>? statuses;
//   List<Prices>? prices;
//   List<Groups>? groups;
//   bool? isSelected;
//   int? modifierQuantity;
//   int? extraPrice;
//   String? selectedTitle;
//
//   Modifiers({this.id, this.modifierId, this.immgId, this.title, this.sequence, this.titleV2, this.statuses, this.prices, this.groups, this.isSelected, this.modifierQuantity, this.extraPrice, this.selectedTitle});
//
//   Modifiers.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     modifierId = json['modifier_id'];
//     immgId = json['immg_id'];
//     title = json['title'];
//     sequence = json['sequence'];
//     titleV2 = json['title_v2'] != null ? new TitleV2.fromJson(json['title_v2']) : null;
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) { statuses!.add(new Statuses.fromJson(v)); });
//     }
//     if (json['prices'] != null) {
//       prices = <Prices>[];
//       json['prices'].forEach((v) { prices!.add(new Prices.fromJson(v)); });
//     }
//     if (json['groups'] != null) {
//       groups = <Groups>[];
//       json['groups'].forEach((v) { groups!.add(new Groups.fromJson(v)); });
//     }
//     isSelected = json['is_selected'];
//     modifierQuantity = json['modifier_quantity'];
//     extraPrice = json['extra_price'];
//     selectedTitle = json['selectedTitle'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['modifier_id'] = this.modifierId;
//     data['immg_id'] = this.immgId;
//     data['title'] = this.title;
//     data['sequence'] = this.sequence;
//     if (this.titleV2 != null) {
//       data['title_v2'] = this.titleV2!.toJson();
//     }
//     if (this.statuses != null) {
//       data['statuses'] = this.statuses!.map((v) => v.toJson()).toList();
//     }
//     if (this.prices != null) {
//       data['prices'] = this.prices!.map((v) => v.toJson()).toList();
//     }
//     if (this.groups != null) {
//       data['groups'] = this.groups!.map((v) => v.toJson()).toList();
//     }
//     data['is_selected'] = this.isSelected;
//     data['modifier_quantity'] = this.modifierQuantity;
//     data['extra_price'] = this.extraPrice;
//     data['selectedTitle'] = this.selectedTitle;
//     return data;
//   }
// }
//
// class Prices {
//   int? providerId;
//   int? currencyId;
//   String? code;
//   String? symbol;
//   int? price;
//
//   Prices({this.providerId, this.currencyId, this.code, this.symbol, this.price});
//
//   Prices.fromJson(Map<String, dynamic> json) {
//     providerId = json['provider_id'];
//     currencyId = json['currency_id'];
//     code = json['code'];
//     symbol = json['symbol'];
//     price = json['price'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['provider_id'] = this.providerId;
//     data['currency_id'] = this.currencyId;
//     data['code'] = this.code;
//     data['symbol'] = this.symbol;
//     data['price'] = this.price;
//     return data;
//   }
// }
//
// class Groups {
//   int? id;
//   int? groupId;
//   int? parentImId;
//   String? title;
//   String? label;
//   int? brandId;
//   TitleV2? titleV2;
//   List<Statuses>? statuses;
//   Rule? rule;
//   List<Modifiers>? modifiers;
//
//   Groups({this.id, this.groupId, this.parentImId, this.title, this.label, this.brandId, this.titleV2, this.statuses, this.rule, this.modifiers});
//
//   Groups.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     groupId = json['group_id'];
//     parentImId = json['parent_im_id'];
//     title = json['title'];
//     label = json['label'];
//     brandId = json['brand_id'];
//     titleV2 = json['title_v2'] != null ? new TitleV2.fromJson(json['title_v2']) : null;
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) { statuses!.add(new Statuses.fromJson(v)); });
//     }
//     rule = json['rule'] != null ? new Rule.fromJson(json['rule']) : null;
//     if (json['modifiers'] != null) {
//       modifiers = <Modifiers>[];
//       json['modifiers'].forEach((v) { modifiers!.add(new Modifiers.fromJson(v)); });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['group_id'] = this.groupId;
//     data['parent_im_id'] = this.parentImId;
//     data['title'] = this.title;
//     data['label'] = this.label;
//     data['brand_id'] = this.brandId;
//     if (this.titleV2 != null) {
//       data['title_v2'] = this.titleV2!.toJson();
//     }
//     if (this.statuses != null) {
//       data['statuses'] = this.statuses!.map((v) => v.toJson()).toList();
//     }
//     if (this.rule != null) {
//       data['rule'] = this.rule!.toJson();
//     }
//     if (this.modifiers != null) {
//       data['modifiers'] = this.modifiers!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Modifiers {
//   int? id;
//   int? modifierId;
//   int? immgId;
//   String? title;
//   int? sequence;
//   TitleV2? titleV2;
//   List<Statuses>? statuses;
//   List<Prices>? prices;
//   bool? isSelected;
//   int? modifierQuantity;
//   int? extraPrice;
//   List<Null>? groups;
//
//   Modifiers({this.id, this.modifierId, this.immgId, this.title, this.sequence, this.titleV2, this.statuses, this.prices, this.isSelected, this.modifierQuantity, this.extraPrice, this.groups});
//
//   Modifiers.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     modifierId = json['modifier_id'];
//     immgId = json['immg_id'];
//     title = json['title'];
//     sequence = json['sequence'];
//     titleV2 = json['title_v2'] != null ? TitleV2.fromJson(json['title_v2']) : null;
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) { statuses!.add(new Statuses.fromJson(v)); });
//     }
//     if (json['prices'] != null) {
//       prices = <Prices>[];
//       json['prices'].forEach((v) { prices!.add(new Prices.fromJson(v)); });
//     }
//     isSelected = json['is_selected'];
//     modifierQuantity = json['modifier_quantity'];
//     extraPrice = json['extra_price'];
//     if (json['groups'] != null) {
//       groups = <Null>[];
//       json['groups'].forEach((v) { groups!.add(new Null.fromJson(v)); });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['modifier_id'] = this.modifierId;
//     data['immg_id'] = this.immgId;
//     data['title'] = this.title;
//     data['sequence'] = this.sequence ;
//     if (this.titleV2 != null) {
//       data['title_v2'] = this.titleV2!.toJson();
//     }
//     if (this.statuses != null) {
//       data['statuses'] = this.statuses!.map((v) => v.toJson()).toList();
//     }
//     if (this.prices != null) {
//       data['prices'] = this.prices!.map((v) => v.toJson()).toList();
//     }
//     data['is_selected'] = this.isSelected;
//     data['modifier_quantity'] = this.modifierQuantity;
//     data['extra_price'] = this.extraPrice;
//     if (this.groups != null) {
//       data['groups'] = this.groups!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Cart {
//   int? id;
//   String? title;
//   List<Prices>? prices;
//   int? vat;
//   String? description;
//   String? image;
//   bool? enabled;
//   bool? hidden;
//   List<Statuses>? statuses;
//   int? sequence;
//   int? defaultItemId;
//   Stock? stock;
//   TitleV2? titleV2;
//   TitleV2? descriptionV2;
//   String? cartId;
//   int? itemId;
//   double? unitPrice;
//   List<Groups>? groups;
//   int? quantity;
//   bool? hasModifierGroups;
//
//   Cart({this.id, this.title, this.prices, this.vat, this.description, this.image, this.enabled, this.hidden, this.statuses, this.sequence, this.defaultItemId, this.stock, this.titleV2, this.descriptionV2, this.cartId, this.itemId, this.unitPrice, this.groups, this.quantity, this.hasModifierGroups});
//
//   Cart.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     if (json['prices'] != null) {
//       prices = <Prices>[];
//       json['prices'].forEach((v) { prices!.add(new Prices.fromJson(v)); });
//     }
//     vat = json['vat'];
//     description = json['description'];
//     image = json['image'];
//     enabled = json['enabled'];
//     hidden = json['hidden'];
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) { statuses!.add(new Statuses.fromJson(v)); });
//     }
//     sequence = json['sequence'];
//     defaultItemId = json['default_item_id'];
//     stock = json['stock'] != null ? new Stock.fromJson(json['stock']) : null;
//     titleV2 = json['title_v2'] != null ? new TitleV2.fromJson(json['title_v2']) : null;
//     descriptionV2 = json['description_v2'] != null ? new TitleV2.fromJson(json['description_v2']) : null;
//     cartId = json['cart_id'];
//     itemId = json['item_id'];
//     unitPrice = json['unit_price'];
//     if (json['groups'] != null) {
//       groups = <Groups>[];
//       json['groups'].forEach((v) { groups!.add(new Groups.fromJson(v)); });
//     }
//     quantity = json['quantity'];
//     hasModifierGroups = json['has_modifier_groups'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     if (this.prices != null) {
//       data['prices'] = this.prices!.map((v) => v.toJson()).toList();
//     }
//     data['vat'] = this.vat;
//     data['description'] = this.description;
//     data['image'] = this.image;
//     data['enabled'] = this.enabled;
//     data['hidden'] = this.hidden;
//     if (this.statuses != null) {
//       data['statuses'] = this.statuses!.map((v) => v.toJson()).toList();
//     }
//     data['sequence'] = this.sequence;
//     data['default_item_id'] = this.defaultItemId;
//     if (this.stock != null) {
//       data['stock'] = this.stock!.toJson();
//     }
//     if (this.titleV2 != null) {
//       data['title_v2'] = this.titleV2!.toJson();
//     }
//     if (this.descriptionV2 != null) {
//       data['description_v2'] = this.descriptionV2!.toJson();
//     }
//     data['cart_id'] = this.cartId;
//     data['item_id'] = this.itemId;
//     data['unit_price'] = this.unitPrice;
//     if (this.groups != null) {
//       data['groups'] = this.groups!.map((v) => v.toJson()).toList();
//     }
//     data['quantity'] = this.quantity;
//     data['has_modifier_groups'] = this.hasModifierGroups;
//     return data;
//   }
// }
