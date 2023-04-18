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
      fonts: json['fonts'] == null
          ? null
          : PrinterFontsModel.fromJson(json['fonts'] as Map<String, dynamic>),
      fontId: json['font_id'] as int?,
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
      'font_id': instance.fontId,
      'fonts': instance.fonts,
    };

PrinterFontsModel _$PrinterFontsModelFromJson(Map<String, dynamic> json) =>
    PrinterFontsModel(
      smallFontSize: json['small_font_size'] as num?,
      regularFontSize: json['regular_font_size'] as num?,
      mediumFontSize: json['medium_font_size'] as num?,
      largeFontSize: json['large_font_size'] as num?,
      extraLargeFontSize: json['extra_large_font_size'] as num?,
    );

Map<String, dynamic> _$PrinterFontsModelToJson(PrinterFontsModel instance) =>
    <String, dynamic>{
      'small_font_size': instance.smallFontSize,
      'regular_font_size': instance.regularFontSize,
      'medium_font_size': instance.mediumFontSize,
      'large_font_size': instance.largeFontSize,
      'extra_large_font_size': instance.extraLargeFontSize,
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
      fontId: json['font_id'] as int,
      fonts: json['fonts'] == null
          ? null
          : PrinterFonts.fromJson(json['fonts'] as Map<String, dynamic>),
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
      'font_id': instance.fontId,
      'fonts': instance.fonts,
    };

PrinterFonts _$PrinterFontsFromJson(Map<String, dynamic> json) => PrinterFonts(
      smallFontSize: json['small_font_size'] as num,
      regularFontSize: json['regular_font_size'] as num,
      mediumFontSize: json['medium_font_size'] as num,
      largeFontSize: json['large_font_size'] as num,
      extraLargeFontSize: json['extra_large_font_size'] as num,
    );

Map<String, dynamic> _$PrinterFontsToJson(PrinterFonts instance) =>
    <String, dynamic>{
      'small_font_size': instance.smallFontSize,
      'regular_font_size': instance.regularFontSize,
      'medium_font_size': instance.mediumFontSize,
      'large_font_size': instance.largeFontSize,
      'extra_large_font_size': instance.extraLargeFontSize,
    };
