import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/orders/domain/entities/settings.dart';

part 'settings_model.g.dart';

@JsonSerializable()
class SettingsModel {
  @JsonKey(name: 'branch_id')
  int? branchId;
  @JsonKey(name: 'type_id')
  int? typeId;

  SettingsModel({this.branchId, this.typeId});

  factory SettingsModel.fromJson(Map<String, dynamic> json) =>
      _$SettingsModelFromJson(json);

  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);

  Settings toEntity() {
    return Settings(
      branchId: branchId.orZero(),
      typeId: typeId.orZero(),
    );
  }
}
