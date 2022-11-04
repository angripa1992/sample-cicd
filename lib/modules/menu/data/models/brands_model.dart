import 'package:json_annotation/json_annotation.dart';
import 'package:klikit/app/extensions.dart';

import '../../domain/entities/brand.dart';
import '../../domain/entities/brands.dart';
import 'brand_model.dart';

part 'brands_model.g.dart';

@JsonSerializable()
class MenuBrandsModel {
  List<MenuBrandModel>? results;
  int? total;
  int? page;
  int? size;

  MenuBrandsModel({this.results, this.total, this.page, this.size});

  factory MenuBrandsModel.fromJson(Map<String, dynamic> json) =>
      _$MenuBrandsModelFromJson(json);

  MenuBrands toEntity() {
    return MenuBrands(
      results: _brands(),
      total: total.orZero(),
      page: page.orZero(),
      size: size.orZero(),
    );
  }

  List<MenuBrand> _brands() {
    final List<MenuBrand> brands = [];
    if (results == null) return brands;
    for (var element in results!) {
      brands.add(element.toEntity());
    }
    return brands;
  }
}
