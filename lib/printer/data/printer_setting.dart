import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../app/constants.dart';

part 'printer_setting.g.dart';

@JsonSerializable()
class PrinterSettingModel {
  @JsonKey(name: 'branch_id')
  int? branchId;
  @JsonKey(name: 'type_id')
  int? typeId;
  @JsonKey(name: 'roll_id')
  int? rollId;
  @JsonKey(name: 'docket_customer_copy_enabled')
  bool? customerCopyEnabled;
  @JsonKey(name: 'docket_kitchen_copy_enabled')
  bool? kitchenCopyEnabled;
  @JsonKey(name: 'docket_customer_copy_count')
  int? customerCopyCount;
  @JsonKey(name: 'docket_kitchen_copy_count')
  int? kitchenCopyCount;

  PrinterSettingModel({
    this.branchId,
    this.typeId,
    this.rollId,
    this.customerCopyEnabled,
    this.kitchenCopyEnabled,
    this.customerCopyCount,
    this.kitchenCopyCount,
  });

  factory PrinterSettingModel.fromJson(Map<String, dynamic> json) =>
      _$PrinterSettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrinterSettingModelToJson(this);

  PrinterSetting toEntity() {
    return PrinterSetting(
      branchId: branchId.orZero(),
      connectionType: typeId ?? ConnectionType.BLUETOOTH,
      paperSize: rollId ?? RollId.mm80,
      customerCopyEnabled: customerCopyEnabled.orFalse(),
      kitchenCopyEnabled: kitchenCopyEnabled.orFalse(),
      customerCopyCount: customerCopyCount.orZero(),
      kitchenCopyCount: kitchenCopyCount.orZero(),
    );
  }
}

@JsonSerializable()
class PrinterSetting {
  @JsonKey(name: 'branch_id')
  int branchId;
  @JsonKey(name: 'type_id')
  int connectionType;
  @JsonKey(name: 'roll_id')
  int paperSize;
  @JsonKey(name: 'docket_customer_copy_enabled')
  bool customerCopyEnabled;
  @JsonKey(name: 'docket_kitchen_copy_enabled')
  bool kitchenCopyEnabled;
  @JsonKey(name: 'docket_customer_copy_count')
  int customerCopyCount;
  @JsonKey(name: 'docket_kitchen_copy_count')
  int kitchenCopyCount;

  PrinterSetting({
    required this.branchId,
    required this.connectionType,
    required this.paperSize,
    required this.customerCopyEnabled,
    required this.kitchenCopyEnabled,
    required this.customerCopyCount,
    required this.kitchenCopyCount,
  });

  factory PrinterSetting.fromJson(Map<String, dynamic> json) =>
      _$PrinterSettingFromJson(json);

  Map<String, dynamic> toJson() => _$PrinterSettingToJson(this);
}
