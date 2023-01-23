import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/orders/domain/entities/provider.dart';

part 'provider_model.g.dart';

@JsonSerializable()
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

  factory ProviderModel.fromJson(Map<String, dynamic> json) =>
      _$ProviderModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProviderModelToJson(this);

  Provider toEntity() {
    return Provider(
        id.orZero(), title.orEmpty(), value.orEmpty(), logo.orEmpty());
  }
}
