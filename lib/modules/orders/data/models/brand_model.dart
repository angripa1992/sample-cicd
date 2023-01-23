import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/orders/domain/entities/brand.dart';

part 'brand_model.g.dart';

@JsonSerializable()
class BrandModel {
  List<Results>? results;
  int? total;
  int? page;
  int? size;

  BrandModel({this.results, this.total, this.page, this.size});

  factory BrandModel.fromJson(Map<String, dynamic> json) =>
      _$BrandModelFromJson(json);

  Map<String, dynamic> toJson() => _$BrandModelToJson(this);

  Brands toEntity() {
    if (results == null) {
      return Brands([]);
    }
    List<Brand> brands = [];
    for (var brand in results!) {
      brands.add(brand.toEntity());
    }
    return Brands(brands);
  }
}

@JsonSerializable()
class Results {
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
  @JsonKey(name: 'business_title')
  String? businessTitle;
  @JsonKey(name: 'branch_ids')
  List<int>? branchIds;
  @JsonKey(name: 'branch_titles')
  List<String>? branchTitles;
  @JsonKey(name: 'brand_cuisines')
  List<int>? brandCuisines;

  Results({
    this.id,
    this.businessId,
    this.title,
    this.logo,
    this.banner,
    this.qrContent,
    this.qrLabel,
    this.businessTitle,
    this.branchIds,
    this.branchTitles,
    this.brandCuisines,
  });

  factory Results.fromJson(Map<String, dynamic> json) =>
      _$ResultsFromJson(json);

  Map<String, dynamic> toJson() => _$ResultsToJson(this);

  Brand toEntity() {
    return Brand(
      id: id.orZero(),
      businessId: businessId.orZero(),
      title: title.orEmpty(),
      logo: logo.orEmpty(),
      banner: banner.orEmpty(),
      qrContent: qrContent.orEmpty(),
      qrLabel: qrLabel.orEmpty(),
      businessTitle: businessTitle.orEmpty(),
      branchIds: branchIds ?? [],
      branchTitles: branchTitles ?? [],
      brandCuisines: brandCuisines ?? [],
    );
  }
}
