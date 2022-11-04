// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brands_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuBrandsModel _$MenuBrandsModelFromJson(Map<String, dynamic> json) =>
    MenuBrandsModel(
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => MenuBrandModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
      page: json['page'] as int?,
      size: json['size'] as int?,
    );

Map<String, dynamic> _$MenuBrandsModelToJson(MenuBrandsModel instance) =>
    <String, dynamic>{
      'results': instance.results,
      'total': instance.total,
      'page': instance.page,
      'size': instance.size,
    };
