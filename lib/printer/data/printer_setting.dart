import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/printer/data/dockets_fonts.dart';

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
  @JsonKey(name: 'sticker_printer_enabled')
  bool? stickerPrinterEnabled;
  @JsonKey(name: 'docket_customer_copy_enabled')
  bool? customerCopyEnabled;
  @JsonKey(name: 'docket_kitchen_copy_enabled')
  bool? kitchenCopyEnabled;
  @JsonKey(name: 'docket_customer_copy_count')
  int? customerCopyCount;
  @JsonKey(name: 'docket_kitchen_copy_count')
  int? kitchenCopyCount;
  @JsonKey(name: 'font_id')
  int? fontId;
  PrinterFontsModel? fonts;

  PrinterSettingModel({
    this.branchId,
    this.typeId,
    this.rollId,
    this.customerCopyEnabled,
    this.kitchenCopyEnabled,
    this.customerCopyCount,
    this.kitchenCopyCount,
    this.fonts,
    this.fontId,
  });

  factory PrinterSettingModel.fromJson(Map<String, dynamic> json) =>
      _$PrinterSettingModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrinterSettingModelToJson(this);

  PrinterSetting toEntity() {
    return PrinterSetting(
      branchId: branchId.orZero(),
      type: typeId ?? CType.BLE,
      paperSize: rollId ?? RollId.mm80,
      stickerPrinterEnabled: stickerPrinterEnabled.orFalse(),
      customerCopyEnabled: customerCopyEnabled.orFalse(),
      kitchenCopyEnabled: kitchenCopyEnabled.orFalse(),
      customerCopyCount: customerCopyCount.orZero(),
      kitchenCopyCount: kitchenCopyCount.orZero(),
      fonts: fonts?.toEntity() ??
          PrinterFonts(
            smallFontSize: NormalFontSize.small,
            regularFontSize: NormalFontSize.regular,
            mediumFontSize: NormalFontSize.medium,
            largeFontSize: NormalFontSize.large,
            extraLargeFontSize: NormalFontSize.extraLarge,
          ),
      fontId: fontId ?? PrinterFontSize.normal,
    );
  }
}

@JsonSerializable()
class PrinterFontsModel {
  @JsonKey(name: 'small_font_size')
  num? smallFontSize;
  @JsonKey(name: 'regular_font_size')
  num? regularFontSize;
  @JsonKey(name: 'medium_font_size')
  num? mediumFontSize;
  @JsonKey(name: 'large_font_size')
  num? largeFontSize;
  @JsonKey(name: 'extra_large_font_size')
  num? extraLargeFontSize;

  PrinterFontsModel({
    this.smallFontSize,
    this.regularFontSize,
    this.mediumFontSize,
    this.largeFontSize,
    this.extraLargeFontSize,
  });

  factory PrinterFontsModel.fromJson(Map<String, dynamic> json) =>
      _$PrinterFontsModelFromJson(json);

  Map<String, dynamic> toJson() => _$PrinterFontsModelToJson(this);

  PrinterFonts toEntity() {
    return PrinterFonts(
      smallFontSize: smallFontSize ?? NormalFontSize.small,
      regularFontSize: regularFontSize ?? NormalFontSize.regular,
      mediumFontSize: mediumFontSize ?? NormalFontSize.medium,
      largeFontSize: largeFontSize ?? NormalFontSize.large,
      extraLargeFontSize: extraLargeFontSize ?? NormalFontSize.extraLarge,
    );
  }
}

@JsonSerializable()
class PrinterSetting {
  @JsonKey(name: 'branch_id')
  int branchId;
  @JsonKey(name: 'type_id')
  int type;
  @JsonKey(name: 'roll_id')
  int paperSize;
  @JsonKey(name: 'sticker_printer_enabled')
  bool stickerPrinterEnabled;
  @JsonKey(name: 'docket_customer_copy_enabled')
  bool customerCopyEnabled;
  @JsonKey(name: 'docket_kitchen_copy_enabled')
  bool kitchenCopyEnabled;
  @JsonKey(name: 'docket_customer_copy_count')
  int customerCopyCount;
  @JsonKey(name: 'docket_kitchen_copy_count')
  int kitchenCopyCount;
  @JsonKey(name: 'font_id')
  int fontId;
  PrinterFonts? fonts;

  PrinterSetting({
    required this.branchId,
    required this.type,
    required this.paperSize,
    required this.stickerPrinterEnabled,
    required this.customerCopyEnabled,
    required this.kitchenCopyEnabled,
    required this.customerCopyCount,
    required this.kitchenCopyCount,
    required this.fontId,
    required this.fonts,
  });

  factory PrinterSetting.fromJson(Map<String, dynamic> json) =>
      _$PrinterSettingFromJson(json);

  Map<String, dynamic> toJson() => _$PrinterSettingToJson(this);
}

@JsonSerializable()
class PrinterFonts {
  @JsonKey(name: 'small_font_size')
  num smallFontSize;
  @JsonKey(name: 'regular_font_size')
  num regularFontSize;
  @JsonKey(name: 'medium_font_size')
  num mediumFontSize;
  @JsonKey(name: 'large_font_size')
  num largeFontSize;
  @JsonKey(name: 'extra_large_font_size')
  num extraLargeFontSize;

  PrinterFonts({
    required this.smallFontSize,
    required this.regularFontSize,
    required this.mediumFontSize,
    required this.largeFontSize,
    required this.extraLargeFontSize,
  });

  factory PrinterFonts.fromJson(Map<String, dynamic> json) =>
      _$PrinterFontsFromJson(json);

  Map<String, dynamic> toJson() => _$PrinterFontsToJson(this);

  static PrinterFonts fromId(int fontId) {
    switch (fontId) {
      case PrinterFontSize.small:
        return PrinterFonts(
          smallFontSize: SmallFontSize.small,
          regularFontSize: SmallFontSize.regular,
          mediumFontSize: SmallFontSize.medium,
          largeFontSize: SmallFontSize.large,
          extraLargeFontSize: SmallFontSize.extraLarge,
        );
      case PrinterFontSize.large:
        return PrinterFonts(
          smallFontSize: LargeFontSize.small,
          regularFontSize: LargeFontSize.regular,
          mediumFontSize: LargeFontSize.medium,
          largeFontSize: LargeFontSize.large,
          extraLargeFontSize: LargeFontSize.extraLarge,
        );
      case PrinterFontSize.huge:
        return PrinterFonts(
          smallFontSize: ExtraLargeFontSize.small,
          regularFontSize: ExtraLargeFontSize.regular,
          mediumFontSize: ExtraLargeFontSize.medium,
          largeFontSize: ExtraLargeFontSize.large,
          extraLargeFontSize: ExtraLargeFontSize.extraLarge,
        );
      default:
        return PrinterFonts(
          smallFontSize: NormalFontSize.small,
          regularFontSize: NormalFontSize.regular,
          mediumFontSize: NormalFontSize.medium,
          largeFontSize: NormalFontSize.large,
          extraLargeFontSize: NormalFontSize.extraLarge,
        );
    }
  }
}
