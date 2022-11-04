import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../domain/entities/brand.dart';

part 'brand_model.g.dart';

@JsonSerializable()
class MenuBrandModel {
  int? id;
  @JsonKey(name: 'business_id')
  int? businessId;
  String? title;
  String? logo;
  String? banner;
  @JsonKey(name: 'qr_content')
  String? qrContent;
  @JsonKey(name: 'qr_label')
  String? qrLabel;
  @JsonKey(name: 'is_virtual')
  bool? isVirtual;
  @JsonKey(name: 'business_title')
  String? businessTitle;
  @JsonKey(name: 'branch_ids')
  List<int>? branchIds;
  @JsonKey(name: 'branch_titles')
  List<String>? branchTitles;

  MenuBrandModel({
    this.id,
    this.businessId,
    this.title,
    this.logo,
    this.banner,
    this.qrContent,
    this.qrLabel,
    this.isVirtual,
    this.businessTitle,
    this.branchIds,
    this.branchTitles,
  });

  factory MenuBrandModel.fromJson(Map<String, dynamic> json) =>
      _$MenuBrandModelFromJson(json);

  MenuBrand toEntity() {
    return MenuBrand(
      id: id.orZero(),
      businessId: businessId.orZero(),
      title: title.orEmpty(),
      logo: logo.orEmpty(),
      banner: banner.orEmpty(),
      qrContent: qrContent.orEmpty(),
      qrLabel: qrLabel.orEmpty(),
      isVirtual: isVirtual ?? false,
      businessTitle: businessTitle.orEmpty(),
      branchIds: branchIds ?? [],
      branchTitles: branchTitles ?? [],
    );
  }
}