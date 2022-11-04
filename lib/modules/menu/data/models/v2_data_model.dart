import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../domain/entities/v2_data.dart';

part 'v2_data_model.g.dart';

@JsonSerializable()
class TitleV2Model {
  String? en;

  TitleV2Model({this.en});

  factory TitleV2Model.fromJson(Map<String, dynamic> json) =>
      _$TitleV2ModelFromJson(json);

  TitleV2 toEntity() {
    return TitleV2(en: en.orEmpty());
  }
}

@JsonSerializable()
class DescriptionV2Model {
  String? en;

  DescriptionV2Model({this.en});

  factory DescriptionV2Model.fromJson(Map<String, dynamic> json) =>
      _$DescriptionV2ModelFromJson(json);

  DescriptionV2 toEntity() {
    return DescriptionV2(en: en.orEmpty());
  }
}
