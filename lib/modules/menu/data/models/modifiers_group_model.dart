import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/menu/data/models/status_model.dart';
import 'package:klikit/modules/menu/domain/entities/modifiers_group.dart';

import '../../domain/entities/modifiers.dart';
import '../../domain/entities/status.dart';
import 'modifiers_model.dart';

part 'modifiers_group_model.g.dart';

@JsonSerializable()
class ModifiersGroupModel {
  @JsonKey(name: 'group_id')
  int? groupId;
  String? title;
  bool? defaultData;
  List<StatusesModel>? statuses;
  List<ModifiersModel>? modifiers;

  ModifiersGroupModel({
    this.groupId,
    this.title,
    this.defaultData,
    this.statuses,
    this.modifiers,
  });

  factory ModifiersGroupModel.fromJson(Map<String, dynamic> json) =>
      _$ModifiersGroupModelFromJson(json);

  ModifiersGroup toEntity() {
    return ModifiersGroup(
      groupId: groupId.orZero(),
      title: title.orEmpty(),
      defaultData: defaultData.orFalse(),
      statuses: _statuses(),
      modifiers: _modifiers(),
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

  List<Modifiers> _modifiers() {
    List<Modifiers> modifiersData = [];
    if (modifiers == null) return modifiersData;
    for (var element in modifiers!) {
      modifiersData.add(element.toEntity());
    }
    return modifiersData;
  }
}
