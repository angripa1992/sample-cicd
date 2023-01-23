import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../domain/entities/source.dart';

part 'source_model.g.dart';

@JsonSerializable()
class SourcesModel {
  int? id;
  String? name;
  List<SourceModel>? sources;

  SourcesModel({this.id, this.name, this.sources});

  factory SourcesModel.fromJson(Map<String, dynamic> json) =>
      _$SourcesModelFromJson(json);

  Sources toEntity() {
    return Sources(id: id.orZero(), name: name.orEmpty(), sources: _sources());
  }

  List<Source> _sources() {
    final data = <Source>[];
    if (sources != null) {
      for (var source in sources!) {
        data.add(source.toEntity());
      }
    }
    return data;
  }
}

@JsonSerializable()
class SourceModel {
  int? id;
  String? name;
  String? image;

  SourceModel({this.id, this.name, this.image});

  factory SourceModel.fromJson(Map<String, dynamic> json) =>
      _$SourceModelFromJson(json);

  Source toEntity() {
    return Source(
        id: id.orZero(), name: name.orEmpty(), image: image.orEmpty());
  }
}
