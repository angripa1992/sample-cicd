import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/common/entities/brand.dart';

class BrandModel {
  List<Results>? results;
  int? total;
  int? page;
  int? size;

  BrandModel({this.results, this.total, this.page, this.size});

  factory BrandModel.fromJson(Map<String, dynamic> json) => BrandModel(
        results: (json['results'] as List<dynamic>?)?.map((e) => Results.fromJson(e as Map<String, dynamic>)).toList(),
        total: json['total'] as int?,
        page: json['page'] as int?,
        size: json['size'] as int?,
      );

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

class Results {
  int? id;
  int? businessId;
  String? title;
  String? logo;
  String? banner;
  String? qrContent;
  String? qrLabel;
  String? businessTitle;
  List<int>? branchIds;
  List<String>? branchTitles;
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

  factory Results.fromJson(Map<String, dynamic> json) => Results(
        id: json['id'] as int?,
        businessId: json['business_id'] as int?,
        title: json['title'] as String?,
        logo: json['logo'] as String?,
        banner: json['banner'] as String?,
        qrContent: json['qr_content'] as String?,
        qrLabel: json['qr_label'] as String?,
        businessTitle: json['business_title'] as String?,
        branchIds: (json['branch_ids'] as List<dynamic>?)?.map((e) => e as int).toList(),
        branchTitles: (json['branch_titles'] as List<dynamic>?)?.map((e) => e as String).toList(),
        brandCuisines: (json['brand_cuisines'] as List<dynamic>?)?.map((e) => e as int).toList(),
      );

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

class CartBrandModel {
  int? id;
  String? title;
  String? logo;

  CartBrandModel({this.id, this.title, this.logo});

  factory CartBrandModel.fromJson(Map<String, dynamic> json) => CartBrandModel(
        id: json['id'] as int?,
        title: json['title'] as String?,
        logo: json['logo'] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'title': title,
        'logo': logo,
      };

  CartBrand toEntity() {
    return CartBrand(id: id.orZero(), title: title.orEmpty(), logo: logo.orEmpty());
  }
}
