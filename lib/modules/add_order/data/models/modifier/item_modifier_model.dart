import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/add_order/domain/entities/modifier/item_modifier.dart';

import 'item_modifier_group_model.dart';
import 'item_price_model.dart';
import 'item_status_model.dart';

class MenuItemModifierModel {
  int? id;
  int? modifierId;
  int? immgId;
  String? title;
  int? sequence;
  List<MenuItemStatusModel>? statuses;
  List<MenuItemPriceModel>? prices;
  List<MenuItemModifierGroupModel>? groups;

  MenuItemModifierModel({
    this.id,
    this.modifierId,
    this.immgId,
    this.title,
    this.sequence,
    this.statuses,
    this.prices,
    this.groups,
  });

  MenuItemModifierModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modifierId = json['modifier_id'];
    immgId = json['immg_id'];
    title = json['title'];
    sequence = json['sequence'];
    if (json['statuses'] != null) {
      statuses = <MenuItemStatusModel>[];
      json['statuses'].forEach((v) {
        statuses!.add(MenuItemStatusModel.fromJson(v));
      });
    }
    if (json['prices'] != null) {
      prices = <MenuItemPriceModel>[];
      json['prices'].forEach((v) {
        prices!.add(MenuItemPriceModel.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = <MenuItemModifierGroupModel>[];
      json['groups'].forEach((v) {
        groups!.add(MenuItemModifierGroupModel.fromJson(v));
      });
    }
  }

  // AddOrderItemModifier toEntity() {
  //   return AddOrderItemModifier(
  //     id: id.orZero(),
  //     modifierId: modifierId.orZero(),
  //     immgId: immgId.orZero(),
  //     title: title.orEmpty(),
  //     sequence: sequence.orZero(),
  //     statuses: statuses?.map((e) => e.toEntity()).toList() ?? [],
  //     prices: prices?.map((e) => e.toEntity()).toList() ?? [],
  //     groups: groups?.map((e) => e.toEntity()).toList() ?? [],
  //   );
  // }
}
