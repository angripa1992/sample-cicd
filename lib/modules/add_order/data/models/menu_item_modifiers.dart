// class MenuItemModifiers {
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
//   MenuItemModifiers(
//       {this.groupId,
//         this.title,
//         this.label,
//         this.brandId,
//         this.sequence,
//         this.titleV2,
//         this.statuses,
//         this.rule,
//         this.modifiers});
//
//   MenuItemModifiers.fromJson(Map<String, dynamic> json) {
//     groupId = json['group_id'];
//     title = json['title'];
//     label = json['label'];
//     brandId = json['brand_id'];
//     sequence = json['sequence'];
//     titleV2 = json['title_v2'] != null
//         ?  TitleV2.fromJson(json['title_v2'])
//         : null;
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) {
//         statuses!.add( Statuses.fromJson(v));
//       });
//     }
//     rule = json['rule'] != null ?  Rule.fromJson(json['rule']) : null;
//     if (json['modifiers'] != null) {
//       modifiers = <Modifiers>[];
//       json['modifiers'].forEach((v) {
//         modifiers!.add(Modifiers.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  <String, dynamic>{};
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
//     final Map<String, dynamic> data =  <String, dynamic>{};
//     data['en'] = en;
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
//     final Map<String, dynamic> data =  Map<String, dynamic>();
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
//
//   Rule(
//       {this.id,
//         this.title,
//         this.typeTitle,
//         this.value,
//         this.brandId,
//         this.titleV2});
//
//   Rule.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     typeTitle = json['type_title'];
//     value = json['value'];
//     brandId = json['brand_id'];
//     titleV2 = json['title_v2'] != null
//         ?  TitleV2.fromJson(json['title_v2'])
//         : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
//     data['id'] = this.id;
//     data['title'] = this.title;
//     data['type_title'] = this.typeTitle;
//     data['value'] = this.value;
//     data['brand_id'] = this.brandId;
//     if (this.titleV2 != null) {
//       data['title_v2'] = this.titleV2!.toJson();
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
//
//   Modifiers(
//       {this.id,
//         this.modifierId,
//         this.immgId,
//         this.title,
//         this.sequence,
//         this.titleV2,
//         this.statuses,
//         this.prices,
//         this.groups});
//
//   Modifiers.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     modifierId = json['modifier_id'];
//     immgId = json['immg_id'];
//     title = json['title'];
//     sequence = json['sequence'];
//     titleV2 = json['title_v2'] != null
//         ?  TitleV2.fromJson(json['title_v2'])
//         : null;
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) {
//         statuses!.add( Statuses.fromJson(v));
//       });
//     }
//     if (json['prices'] != null) {
//       prices = <Prices>[];
//       json['prices'].forEach((v) {
//         prices!.add( Prices.fromJson(v));
//       });
//     }
//     if (json['groups'] != null) {
//       groups = <Groups>[];
//       json['groups'].forEach((v) {
//         groups!.add( Groups.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  <String, dynamic>{};
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
//       {this.providerId, this.currencyId, this.code, this.symbol, this.price});
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
//     final Map<String, dynamic> data =  Map<String, dynamic>();
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
//   Groups(
//       {this.id,
//         this.groupId,
//         this.parentImId,
//         this.title,
//         this.label,
//         this.brandId,
//         this.titleV2,
//         this.statuses,
//         this.rule,
//         this.modifiers});
//
//   Groups.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     groupId = json['group_id'];
//     parentImId = json['parent_im_id'];
//     title = json['title'];
//     label = json['label'];
//     brandId = json['brand_id'];
//     titleV2 = json['title_v2'] != null
//         ?  TitleV2.fromJson(json['title_v2'])
//         : null;
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) {
//         statuses!.add( Statuses.fromJson(v));
//       });
//     }
//     rule = json['rule'] != null ?  Rule.fromJson(json['rule']) : null;
//     if (json['modifiers'] != null) {
//       modifiers = <Modifiers>[];
//       json['modifiers'].forEach((v) {
//         modifiers!.add( Modifiers.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
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
// class Rule {
//   int? id;
//   String? title;
//   String? typeTitle;
//   int? value;
//   int? brandId;
//   TitleV2? titleV2;
//   int? min;
//
//   Rule(
//       {this.id,
//         this.title,
//         this.typeTitle,
//         this.value,
//         this.brandId,
//         this.titleV2,
//         this.min});
//
//   Rule.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     title = json['title'];
//     typeTitle = json['type_title'];
//     value = json['value'];
//     brandId = json['brand_id'];
//     titleV2 = json['title_v2'] != null
//         ?  TitleV2.fromJson(json['title_v2'])
//         : null;
//     min = json['min'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  Map<String, dynamic>();
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
//
//   Modifiers(
//       {this.id,
//         this.modifierId,
//         this.immgId,
//         this.title,
//         this.sequence,
//         this.titleV2,
//         this.statuses,
//         this.prices});
//
//   Modifiers.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     modifierId = json['modifier_id'];
//     immgId = json['immg_id'];
//     title = json['title'];
//     sequence = json['sequence'];
//     titleV2 = json['title_v2'] != null
//         ?  TitleV2.fromJson(json['title_v2'])
//         : null;
//     if (json['statuses'] != null) {
//       statuses = <Statuses>[];
//       json['statuses'].forEach((v) {
//         statuses!.add( Statuses.fromJson(v));
//       });
//     }
//     if (json['prices'] != null) {
//       prices = <Prices>[];
//       json['prices'].forEach((v) {
//         prices!.add( Prices.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data =  <String, dynamic>{};
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
//     return data;
//   }
// }
