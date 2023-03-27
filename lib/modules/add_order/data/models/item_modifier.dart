import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/add_order/domain/entities/item_modifier.dart';

import 'item_modifier_group.dart';
import 'item_price.dart';
import 'item_status.dart';

class ItemModifierModel {
  int? id;
  int? modifierId;
  int? immgId;
  String? title;
  int? sequence;
  List<ItemStatusModel>? statuses;
  List<ItemPriceModel>? prices;
  List<ItemModifierGroupModel>? groups;

  ItemModifierModel({
    this.id,
    this.modifierId,
    this.immgId,
    this.title,
    this.sequence,
    this.statuses,
    this.prices,
    this.groups,
  });

  ItemModifierModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    modifierId = json['modifier_id'];
    immgId = json['immg_id'];
    title = json['title'];
    sequence = json['sequence'];
    if (json['statuses'] != null) {
      statuses = <ItemStatusModel>[];
      json['statuses'].forEach((v) {
        statuses!.add(ItemStatusModel.fromJson(v));
      });
    }
    if (json['prices'] != null) {
      prices = <ItemPriceModel>[];
      json['prices'].forEach((v) {
        prices!.add(ItemPriceModel.fromJson(v));
      });
    }
    if (json['groups'] != null) {
      groups = <ItemModifierGroupModel>[];
      json['groups'].forEach((v) {
        groups!.add(ItemModifierGroupModel.fromJson(v));
      });
    }
  }

  ItemModifier toEntity() {
    return ItemModifier(
      id: id.orZero(),
      modifierId: modifierId.orZero(),
      immgId: immgId.orZero(),
      title: title.orEmpty(),
      sequence: sequence.orZero(),
      statuses: statuses?.map((e) => e.toEntity()).toList() ?? [],
      prices: prices?.map((e) => e.toEntity()).toList() ?? [],
      groups: groups?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}
