import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/menu/data/models/status_model.dart';
import 'package:klikit/modules/menu/data/models/v2_data_model.dart';

import '../../domain/entities/items.dart';
import '../../domain/entities/status.dart';
import '../../domain/entities/sub_section.dart';
import 'items_model.dart';

part 'sub_section_model.g.dart';

@JsonSerializable()
class SubSectionsModel {
  int? id;
  String? title;
  String? description;
  bool? enabled;
  bool? hidden;
  @JsonKey(name: 'alc_beverages')
  bool? alcBeverages;
  List<StatusesModel>? statuses;
  int? sequence;
  @JsonKey(name: 'title_v2')
  TitleV2Model? titleV2;
  @JsonKey(name: 'description_v2')
  DescriptionV2Model? descriptionV2;
  List<ItemsModel>? items;

  SubSectionsModel({
    this.id,
    this.title,
    this.description,
    this.enabled,
    this.hidden,
    this.alcBeverages,
    this.statuses,
    this.sequence,
    this.titleV2,
    this.descriptionV2,
    this.items,
  });

  factory SubSectionsModel.fromJson(Map<String, dynamic> json) =>
      _$SubSectionsModelFromJson(json);

  SubSections toEntity() {
    return SubSections(
      id: id.orZero(),
      title: title.orEmpty(),
      description: description.orEmpty(),
      enabled: enabled.orFalse(),
      hidden: hidden.orFalse(),
      alcBeverages: alcBeverages.orFalse(),
      statuses: _statuses(),
      sequence: sequence.orZero(),
      titleV2: titleV2?.toEntity() ?? TitleV2Model().toEntity(),
      descriptionV2:
          descriptionV2?.toEntity() ?? DescriptionV2Model().toEntity(),
      items: _items(),
    );
  }

  List<MenuItems> _items() {
    List<MenuItems> itemsData = [];
    if (items == null) return itemsData;
    for (var element in items!) {
      itemsData.add(element.toEntity());
    }
    return itemsData;
  }

  List<Statuses> _statuses() {
    List<Statuses> statusesData = [];
    if (statuses == null) return statusesData;
    for (var element in statuses!) {
      statusesData.add(element.toEntity());
    }
    return statusesData;
  }
}
