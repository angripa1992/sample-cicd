import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/menu/data/models/prices_model.dart';
import 'package:klikit/modules/menu/data/models/status_model.dart';

import '../../domain/entities/modifiers.dart';
import '../../domain/entities/price.dart';
import '../../domain/entities/status.dart';

part 'modifiers_model.g.dart';

@JsonSerializable()
class ModifiersModel {
  @JsonKey(name: 'modifier_id')
  int? modifierId;
  String? title;
  int? sequence;
  bool? defaultData;
  List<PricesModel>? prices;
  List<StatusesModel>? statuses;
  dynamic meta;

  ModifiersModel({
    this.modifierId,
    this.title,
    this.sequence,
    this.defaultData,
    this.prices,
    this.statuses,
    this.meta,
  });

  factory ModifiersModel.fromJson(Map<String, dynamic> json) =>
      _$ModifiersModelFromJson(json);

  Modifiers toEntity() {
    return Modifiers(
      modifierId: modifierId.orZero(),
      title: title.orEmpty(),
      sequence: sequence.orZero(),
      defaultData: defaultData.orFalse(),
      prices: _prices(),
      statuses: _statuses(),
      meta: meta,
    );
  }

  List<Statuses> _statuses() {
    List<Statuses> statusesData = [];
    if (statuses == null) return statusesData;
    for (var element in statuses!) {
      statusesData.add(element.toEntity());
    }
    return statusesData;
  }

  List<Prices> _prices() {
    List<Prices> pricesData = [];
    if (prices == null) return pricesData;
    for (var element in prices!) {
      pricesData.add(element.toEntity());
    }
    return pricesData;
  }
}
