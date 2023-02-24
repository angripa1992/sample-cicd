// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BrandModel _$BrandModelFromJson(Map<String, dynamic> json) => BrandModel(
      results: (json['results'] as List<dynamic>?)
          ?.map((e) => Results.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
      page: json['page'] as int?,
      size: json['size'] as int?,
    );

Map<String, dynamic> _$BrandModelToJson(BrandModel instance) =>
    <String, dynamic>{
      'results': instance.results,
      'total': instance.total,
      'page': instance.page,
      'size': instance.size,
    };

Results _$ResultsFromJson(Map<String, dynamic> json) => Results(
      id: json['id'] as int?,
      businessId: json['business_id'] as int?,
      title: json['title'] as String?,
      logo: json['logo'] as String?,
      banner: json['banner'] as String?,
      qrContent: json['qr_content'] as String?,
      qrLabel: json['qr_label'] as String?,
      businessTitle: json['business_title'] as String?,
      branchIds:
          (json['branch_ids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      branchTitles: (json['branch_titles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      brandCuisines: (json['brand_cuisines'] as List<dynamic>?)
          ?.map((e) => e as int)
          .toList(),
    );

Map<String, dynamic> _$ResultsToJson(Results instance) => <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'title': instance.title,
      'logo': instance.logo,
      'banner': instance.banner,
      'qr_content': instance.qrContent,
      'qr_label': instance.qrLabel,
      'business_title': instance.businessTitle,
      'branch_ids': instance.branchIds,
      'branch_titles': instance.branchTitles,
      'brand_cuisines': instance.brandCuisines,
    };

CartBrandModel _$CartBrandModelFromJson(Map<String, dynamic> json) =>
    CartBrandModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      logo: json['logo'] as String?,
    );

Map<String, dynamic> _$CartBrandModelToJson(CartBrandModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'logo': instance.logo,
    };
