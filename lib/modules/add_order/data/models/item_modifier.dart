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
}
