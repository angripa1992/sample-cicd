import 'billing_item.dart';

class PlaceOrderDataModel {
  int? branchId;
  int? brandId;
  String? brandName;
  String? currency;
  String? currencySymbol;
  int? source;
  int? type;
  int? paymentMethod;
  int? paymentStatus;
  CustomerInfoModel? user;
  String? tableNo;
  int? itemPrice;
  int? finalPrice;
  int? deliveryFee;
  int? vatAmount;
  int? discountAmount;
  int? additionalFee;
  int? serviceFee;
  List<BillingItem>? cart;
  int? uniqueItems;
  int? totalItems;
  int? currencyId;
  int? discountValue;
  int? discountType;

  PlaceOrderDataModel({
    this.branchId,
    this.brandId,
    this.brandName,
    this.currency,
    this.currencySymbol,
    this.source,
    this.type,
    this.paymentMethod,
    this.paymentStatus,
    this.user,
    this.tableNo,
    this.itemPrice,
    this.finalPrice,
    this.deliveryFee,
    this.vatAmount,
    this.discountAmount,
    this.additionalFee,
    this.serviceFee,
    this.cart,
    this.uniqueItems,
    this.totalItems,
    this.currencyId,
    this.discountValue,
    this.discountType,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['branch_id'] = branchId;
    data['currency'] = currency;
    data['currency_symbol'] = currencySymbol;
    data['source'] = source;
    data['type'] = type;
    data['payment_status'] = paymentStatus;
    data['item_price'] = itemPrice;
    data['final_price'] = finalPrice;
    data['delivery_fee'] = deliveryFee;
    data['vat_amount'] = vatAmount;
    data['discount_amount'] = discountAmount;
    data['additional_fee'] = additionalFee;
    data['service_fee'] = serviceFee;
    data['unique_items'] = uniqueItems;
    data['total_items'] = totalItems;
    data['currency_id'] = currencyId;
    data['discount_value'] = discountValue;
    data['discount_type'] = discountType;
    if (brandId != null) {
      data['brand_id'] = brandId;
    }
    if (brandName != null) {
      data['brand_name'] = brandName;
    }
    if (cart != null) {
      data['cart'] = cart!.map((v) => v.toJson()).toList();
    }
    if (user != null) {
      data['user'] = user!.toJson();
    }
    if (tableNo != null) {
      data['table_no'] = tableNo;
    }
    if (paymentMethod != null) {
      data['payment_method'] = paymentMethod;
    }
    return data;
  }
}

class CustomerInfoModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;

  CustomerInfoModel({this.firstName, this.lastName,this. email,this. phone});

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (firstName != null) data['first_name'] = firstName;
    if (lastName != null) data['last_name'] = lastName;
    if (email != null) data['email'] = email;
    if (phone != null) data['phone'] = phone;
    return data;
  }
}

// class Cart {
//   int? id;
//   String? title;
//   List<Prices>? prices;
//   int? vat;
//   String? description;
//   String? skuId;
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
//   int? unitPrice;
//   List<Groups>? groups;
//   int? quantity;
//   bool? hasModifierGroups;
//   Brand? brand;
//
//   Cart(
//       {id,
//         title,
//         prices,
//         vat,
//         description,
//         skuId,
//         image,
//         enabled,
//         hidden,
//         statuses,
//         sequence,
//         defaultItemId,
//         stock,
//         titleV2,
//         descriptionV2,
//         cartId,
//         itemId,
//         unitPrice,
//         groups,
//         quantity,
//         hasModifierGroups,
//         brand});
//
//   Cart.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     if (json['prices'] != null) {
//       prices = <Prices>[];
//       json['prices'].forEach((v) {
//         prices!.add(new Prices.fromJson(v));
//       });
//     }
//     vat = json['vat'];
//     description = json['description'];
//     skuId = json['sku_id'];
//     image = json['image'];
//     enabled = json['enabled'];
//     hidden = json['hidden'];
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) {
//         statuses!.add(new Statuses.fromJson(v));
//       });
//     }
//     sequence = json['sequence'];
//     defaultItemId = json['default_item_id'];
//     stock = json['stock'] != null ? new Stock.fromJson(json['stock']) : null;
//     titleV2 = json['title_v2'] != null
//         ? new TitleV2.fromJson(json['title_v2'])
//         : null;
//     descriptionV2 = json['description_v2'] != null
//         ? new TitleV2.fromJson(json['description_v2'])
//         : null;
//     cartId = json['cart_id'];
//     itemId = json['item_id'];
//     unitPrice = json['unit_price'];
//     if (json['groups'] != null) {
//       groups = <Groups>[];
//       json['groups'].forEach((v) {
//         groups!.add(new Groups.fromJson(v));
//       });
//     }
//     quantity = json['quantity'];
//     hasModifierGroups = json['has_modifier_groups'];
//     brand = json['brand'] != null ? new Brand.fromJson(json['brand']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['title'] = title;
//     if (prices != null) {
//       data['prices'] = prices!.map((v) => v.toJson()).toList();
//     }
//     data['vat'] = vat;
//     data['description'] = description;
//     data['sku_id'] = skuId;
//     data['image'] = image;
//     data['enabled'] = enabled;
//     data['hidden'] = hidden;
//     if (statuses != null) {
//       data['statuses'] = statuses!.map((v) => v.toJson()).toList();
//     }
//     data['sequence'] = sequence;
//     data['default_item_id'] = defaultItemId;
//     if (stock != null) {
//       data['stock'] = stock!.toJson();
//     }
//     if (titleV2 != null) {
//       data['title_v2'] = titleV2!.toJson();
//     }
//     if (descriptionV2 != null) {
//       data['description_v2'] = descriptionV2!.toJson();
//     }
//     data['cart_id'] = cartId;
//     data['item_id'] = itemId;
//     data['unit_price'] = unitPrice;
//     if (groups != null) {
//       data['groups'] = groups!.map((v) => v.toJson()).toList();
//     }
//     data['quantity'] = quantity;
//     data['has_modifier_groups'] = hasModifierGroups;
//     if (brand != null) {
//       data['brand'] = brand!.toJson();
//     }
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
//   Prices(
//       {providerId, currencyId, code, symbol, price});
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
//     data['provider_id'] = providerId;
//     data['currency_id'] = currencyId;
//     data['code'] = code;
//     data['symbol'] = symbol;
//     data['price'] = price;
//     return data;
//   }
// }
//
// class Statuses {
//   int? providerId;
//   bool? hidden;
//
//   Statuses({providerId, hidden});
//
//   Statuses.fromJson(Map<String, dynamic> json) {
//     providerId = json['provider_id'];
//     hidden = json['hidden'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
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
//   Stock({available, snooze});
//
//   Stock.fromJson(Map<String, dynamic> json) {
//     available = json['available'];
//     snooze = json['snooze'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['available'] = available;
//     data['snooze'] = snooze;
//     return data;
//   }
// }
//
// class TitleV2 {
//   String? en;
//
//   TitleV2({en});
//
//   TitleV2.fromJson(Map<String, dynamic> json) {
//     en = json['en'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['en'] = en;
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
//   Groups(
//       {groupId,
//         title,
//         label,
//         brandId,
//         sequence,
//         titleV2,
//         statuses,
//         rule,
//         modifiers});
//
//   Groups.fromJson(Map<String, dynamic> json) {
//     groupId = json['group_id'];
//     title = json['title'];
//     label = json['label'];
//     brandId = json['brand_id'];
//     sequence = json['sequence'];
//     titleV2 = json['title_v2'] != null
//         ? new TitleV2.fromJson(json['title_v2'])
//         : null;
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) {
//         statuses!.add(new Statuses.fromJson(v));
//       });
//     }
//     rule = json['rule'] != null ? new Rule.fromJson(json['rule']) : null;
//     if (json['modifiers'] != null) {
//       modifiers = <Modifiers>[];
//       json['modifiers'].forEach((v) {
//         modifiers!.add(new Modifiers.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['group_id'] = groupId;
//     data['title'] = title;
//     data['label'] = label;
//     data['brand_id'] = brandId;
//     data['sequence'] = sequence;
//     if (titleV2 != null) {
//       data['title_v2'] = titleV2!.toJson();
//     }
//     if (statuses != null) {
//       data['statuses'] = statuses!.map((v) => v.toJson()).toList();
//     }
//     if (rule != null) {
//       data['rule'] = rule!.toJson();
//     }
//     if (modifiers != null) {
//       data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
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
//   Statuses({providerId, enabled, hidden});
//
//   Statuses.fromJson(Map<String, dynamic> json) {
//     providerId = json['provider_id'];
//     enabled = json['enabled'];
//     hidden = json['hidden'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['provider_id'] = providerId;
//     data['enabled'] = enabled;
//     data['hidden'] = hidden;
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
//
//   Rule(
//       {id,
//         title,
//         typeTitle,
//         value,
//         brandId,
//         titleV2});
//
//   Rule.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     typeTitle = json['type_title'];
//     value = json['value'];
//     brandId = json['brand_id'];
//     titleV2 = json['title_v2'] != null
//         ? new TitleV2.fromJson(json['title_v2'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['title'] = title;
//     data['type_title'] = typeTitle;
//     data['value'] = value;
//     data['brand_id'] = brandId;
//     if (titleV2 != null) {
//       data['title_v2'] = titleV2!.toJson();
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
//   List<Groups>? groups;
//   bool? isSelected;
//   int? modifierQuantity;
//   int? extraPrice;
//   String? selectedTitle;
//
//   Modifiers(
//       {id,
//         modifierId,
//         immgId,
//         title,
//         sequence,
//         titleV2,
//         statuses,
//         prices,
//         groups,
//         isSelected,
//         modifierQuantity,
//         extraPrice,
//         selectedTitle});
//
//   Modifiers.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     modifierId = json['modifier_id'];
//     immgId = json['immg_id'];
//     title = json['title'];
//     sequence = json['sequence'];
//     titleV2 = json['title_v2'] != null
//         ? new TitleV2.fromJson(json['title_v2'])
//         : null;
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) {
//         statuses!.add(new Statuses.fromJson(v));
//       });
//     }
//     if (json['prices'] != null) {
//       prices = <Prices>[];
//       json['prices'].forEach((v) {
//         prices!.add(new Prices.fromJson(v));
//       });
//     }
//     if (json['groups'] != null) {
//       groups = <Groups>[];
//       json['groups'].forEach((v) {
//         groups!.add(new Groups.fromJson(v));
//       });
//     }
//     isSelected = json['is_selected'];
//     modifierQuantity = json['modifier_quantity'];
//     extraPrice = json['extra_price'];
//     selectedTitle = json['selectedTitle'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['modifier_id'] = modifierId;
//     data['immg_id'] = immgId;
//     data['title'] = title;
//     data['sequence'] = sequence;
//     if (titleV2 != null) {
//       data['title_v2'] = titleV2!.toJson();
//     }
//     if (statuses != null) {
//       data['statuses'] = statuses!.map((v) => v.toJson()).toList();
//     }
//     if (prices != null) {
//       data['prices'] = prices!.map((v) => v.toJson()).toList();
//     }
//     if (groups != null) {
//       data['groups'] = groups!.map((v) => v.toJson()).toList();
//     }
//     data['is_selected'] = isSelected;
//     data['modifier_quantity'] = modifierQuantity;
//     data['extra_price'] = extraPrice;
//     data['selectedTitle'] = selectedTitle;
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
//   Groups(
//       {id,
//         groupId,
//         parentImId,
//         title,
//         label,
//         brandId,
//         titleV2,
//         statuses,
//         rule,
//         modifiers});
//
//   Groups.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     groupId = json['group_id'];
//     parentImId = json['parent_im_id'];
//     title = json['title'];
//     label = json['label'];
//     brandId = json['brand_id'];
//     titleV2 = json['title_v2'] != null
//         ? new TitleV2.fromJson(json['title_v2'])
//         : null;
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) {
//         statuses!.add(new Statuses.fromJson(v));
//       });
//     }
//     rule = json['rule'] != null ? new Rule.fromJson(json['rule']) : null;
//     if (json['modifiers'] != null) {
//       modifiers = <Modifiers>[];
//       json['modifiers'].forEach((v) {
//         modifiers!.add(new Modifiers.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['group_id'] = groupId;
//     data['parent_im_id'] = parentImId;
//     data['title'] = title;
//     data['label'] = label;
//     data['brand_id'] = brandId;
//     if (titleV2 != null) {
//       data['title_v2'] = titleV2!.toJson();
//     }
//     if (statuses != null) {
//       data['statuses'] = statuses!.map((v) => v.toJson()).toList();
//     }
//     if (rule != null) {
//       data['rule'] = rule!.toJson();
//     }
//     if (modifiers != null) {
//       data['modifiers'] = modifiers!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class Rule {
//   int? id;
//   String? title;
//   String? typeTitle;
//   int? value;
//   int? min;
//   int? brandId;
//   TitleV2? titleV2;
//
//   Rule(
//       {id,
//         title,
//         typeTitle,
//         value,
//         min,
//         brandId,
//         titleV2});
//
//   Rule.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     typeTitle = json['type_title'];
//     value = json['value'];
//     min = json['min'];
//     brandId = json['brand_id'];
//     titleV2 = json['title_v2'] != null
//         ? new TitleV2.fromJson(json['title_v2'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['title'] = title;
//     data['type_title'] = typeTitle;
//     data['value'] = value;
//     data['min'] = min;
//     data['brand_id'] = brandId;
//     if (titleV2 != null) {
//       data['title_v2'] = titleV2!.toJson();
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
//   String? selectedTitle;
//
//   Modifiers(
//       {id,
//         modifierId,
//         immgId,
//         title,
//         sequence,
//         titleV2,
//         statuses,
//         prices,
//         isSelected,
//         modifierQuantity,
//         extraPrice,
//         groups,
//         selectedTitle});
//
//   Modifiers.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     modifierId = json['modifier_id'];
//     immgId = json['immg_id'];
//     title = json['title'];
//     sequence = json['sequence'];
//     titleV2 = json['title_v2'] != null
//         ? new TitleV2.fromJson(json['title_v2'])
//         : null;
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) {
//         statuses!.add(new Statuses.fromJson(v));
//       });
//     }
//     if (json['prices'] != null) {
//       prices = <Prices>[];
//       json['prices'].forEach((v) {
//         prices!.add(new Prices.fromJson(v));
//       });
//     }
//     isSelected = json['is_selected'];
//     modifierQuantity = json['modifier_quantity'];
//     extraPrice = json['extra_price'];
//     if (json['groups'] != null) {
//       groups = <Null>[];
//       json['groups'].forEach((v) {
//         groups!.add(new Null.fromJson(v));
//       });
//     }
//     selectedTitle = json['selectedTitle'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['modifier_id'] = modifierId;
//     data['immg_id'] = immgId;
//     data['title'] = title;
//     data['sequence'] = sequence;
//     if (titleV2 != null) {
//       data['title_v2'] = titleV2!.toJson();
//     }
//     if (statuses != null) {
//       data['statuses'] = statuses!.map((v) => v.toJson()).toList();
//     }
//     if (prices != null) {
//       data['prices'] = prices!.map((v) => v.toJson()).toList();
//     }
//     data['is_selected'] = isSelected;
//     data['modifier_quantity'] = modifierQuantity;
//     data['extra_price'] = extraPrice;
//     if (groups != null) {
//       data['groups'] = groups!.map((v) => v.toJson()).toList();
//     }
//     data['selectedTitle'] = selectedTitle;
//     return data;
//   }
// }
//
// class Brand {
//   int? id;
//   String? logo;
//   String? title;
//
//   Brand({id, logo, title});
//
//   Brand.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     logo = json['logo'];
//     title = json['title'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = id;
//     data['logo'] = logo;
//     data['title'] = title;
//     return data;
//   }
// }
