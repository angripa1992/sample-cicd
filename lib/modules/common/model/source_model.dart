import 'package:klikit/app/extensions.dart';

import '../entities/source.dart';

class SourcesModel {
  int? id;
  String? name;
  List<SourceModel>? sources;

  SourcesModel({this.id, this.name, this.sources});

  factory SourcesModel.fromJson(Map<String, dynamic> json) => SourcesModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        sources: (json['sources'] as List<dynamic>?)?.map((e) => SourceModel.fromJson(e as Map<String, dynamic>)).toList(),
      );

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

class SourceModel {
  int? id;
  String? name;
  String? image;

  SourceModel({this.id, this.name, this.image});

  factory SourceModel.fromJson(Map<String, dynamic> json) => SourceModel(
        id: json['id'] as int?,
        name: json['name'] as String?,
        image: json['image'] as String?,
      );

  Source toEntity() {
    return Source(id: id.orZero(), name: name.orEmpty(), image: image.orEmpty());
  }
}
