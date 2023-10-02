import 'package:klikit/app/extensions.dart';

import '../entities/provider.dart';

class ProviderModel {
  int? id;
  String? title;
  String? value;
  String? logo;

  ProviderModel({
    this.id,
    this.title,
    this.value,
    this.logo,
  });

  factory ProviderModel.fromJson(Map<String, dynamic> json) => ProviderModel(
        id: json['id'] as int?,
        title: json['title'] as String?,
        value: json['value'] as String?,
        logo: json['logo'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'value': value,
        'logo': logo,
      };

  Provider toEntity() {
    return Provider(
      id.orZero(),
      title.orEmpty(),
      value.orEmpty(),
      logo.orEmpty(),
    );
  }
}
