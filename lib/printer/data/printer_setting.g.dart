// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'printer_setting.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrinterSettingModel _$PrinterSettingModelFromJson(Map<String, dynamic> json) =>
    PrinterSettingModel(
      branchId: json['branch_id'] as int?,
      typeId: json['type_id'] as int?,
      rollId: json['roll_id'] as int?,
      customerCopyEnabled: json['docket_customer_copy_enabled'] as bool?,
      kitchenCopyEnabled: json['docket_kitchen_copy_enabled'] as bool?,
      customerCopyCount: json['docket_customer_copy_count'] as int?,
      kitchenCopyCount: json['docket_kitchen_copy_count'] as int?,
    );

Map<String, dynamic> _$PrinterSettingModelToJson(
        PrinterSettingModel instance) =>
    <String, dynamic>{
      'branch_id': instance.branchId,
      'type_id': instance.typeId,
      'roll_id': instance.rollId,
      'docket_customer_copy_enabled': instance.customerCopyEnabled,
      'docket_kitchen_copy_enabled': instance.kitchenCopyEnabled,
      'docket_customer_copy_count': instance.customerCopyCount,
      'docket_kitchen_copy_count': instance.kitchenCopyCount,
    };

PrinterSetting _$PrinterSettingFromJson(Map<String, dynamic> json) =>
    PrinterSetting(
      branchId: json['branch_id'] as int,
      connectionType: json['type_id'] as int,
      paperSize: json['roll_id'] as int,
      customerCopyEnabled: json['docket_customer_copy_enabled'] as bool,
      kitchenCopyEnabled: json['docket_kitchen_copy_enabled'] as bool,
      customerCopyCount: json['docket_customer_copy_count'] as int,
      kitchenCopyCount: json['docket_kitchen_copy_count'] as int,
    );

Map<String, dynamic> _$PrinterSettingToJson(PrinterSetting instance) =>
    <String, dynamic>{
      'branch_id': instance.branchId,
      'type_id': instance.connectionType,
      'roll_id': instance.paperSize,
      'docket_customer_copy_enabled': instance.customerCopyEnabled,
      'docket_kitchen_copy_enabled': instance.kitchenCopyEnabled,
      'docket_customer_copy_count': instance.customerCopyCount,
      'docket_kitchen_copy_count': instance.kitchenCopyCount,
    };
