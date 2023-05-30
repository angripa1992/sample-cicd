import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/modules/menu/data/models/sections_model.dart';
import 'package:klikit/modules/menu/domain/entities/menues.dart';

import '../../domain/entities/sections.dart';

part 'menues_model.g.dart';

@JsonSerializable()
class MenusDataModel {
  List<SectionsModel>? sections;

  MenusDataModel({this.sections});

  factory MenusDataModel.fromJson(Map<String, dynamic> json) =>
      _$MenusDataModelFromJson(json);

  MenusData toEntity() {
    return MenusData(
      sections: sections?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}
