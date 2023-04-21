import 'package:klikit/app/extensions.dart';

import '../../domain/entities/order_source.dart';

class AddOrderSourcesModel {
  int? id;
  String? name;
  List<AddOrderSourceModel>? sources;

  AddOrderSourcesModel({this.id, this.name, this.sources});

  AddOrderSourcesModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    if (json['sources'] != null) {
      sources = <AddOrderSourceModel>[];
      json['sources'].forEach((v) {
        sources!.add(AddOrderSourceModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    if (sources != null) {
      data['sources'] = sources!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  AddOrderSourceType toEntity() => AddOrderSourceType(
        id: id.orZero(),
        name: name.orEmpty(),
        sources: sources?.map((e) => e.toEntity()).toList() ?? [],
      );
}

class AddOrderSourceModel {
  int? id;
  String? name;
  String? image;

  AddOrderSourceModel({this.id, this.name, this.image});

  AddOrderSourceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['image'] = image;
    return data;
  }

  AddOrderSource toEntity() => AddOrderSource(
        id: id.orZero(),
        name: name.orEmpty(),
        image: image.orEmpty(),
      );
}
