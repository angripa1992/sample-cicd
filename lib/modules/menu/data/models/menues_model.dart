import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/modules/menu/data/models/sections_model.dart';
import 'package:klikit/modules/menu/domain/entities/menues.dart';

import '../../domain/entities/sections.dart';
import 'branch_info_model.dart';

part 'menues_model.g.dart';

@JsonSerializable()
class MenusDataModel {
  // @JsonKey(name: 'branch_info')
  // BranchInfoModel? branchInfo;
  List<SectionsModel>? sections;

  MenusDataModel({this.sections});

  factory MenusDataModel.fromJson(Map<String, dynamic> json) =>
      _$MenusDataModelFromJson(json);

  MenusData toEntity() {
    return MenusData(
      sections: _sections(),
    );
  }

  List<Sections> _sections() {
    List<Sections> sectionsData = [];
    if (sections == null) return sectionsData;
    for (var element in sections!) {
      sectionsData.add(element.toEntity());
    }
    return sectionsData;
  }
}
