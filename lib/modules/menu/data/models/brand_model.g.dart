// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brand_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenuBrandModel _$MenuBrandModelFromJson(Map<String, dynamic> json) =>
    MenuBrandModel(
      id: json['id'] as int?,
      businessId: json['business_id'] as int?,
      title: json['title'] as String?,
      logo: json['logo'] as String?,
      banner: json['banner'] as String?,
      qrContent: json['qr_content'] as String?,
      qrLabel: json['qr_label'] as String?,
      isVirtual: json['is_virtual'] as bool?,
      businessTitle: json['business_title'] as String?,
      branchIds:
          (json['branch_ids'] as List<dynamic>?)?.map((e) => e as int).toList(),
      branchTitles: (json['branch_titles'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$MenuBrandModelToJson(MenuBrandModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'business_id': instance.businessId,
      'title': instance.title,
      'logo': instance.logo,
      'banner': instance.banner,
      'qr_content': instance.qrContent,
      'qr_label': instance.qrLabel,
      'is_virtual': instance.isVirtual,
      'business_title': instance.businessTitle,
      'branch_ids': instance.branchIds,
      'branch_titles': instance.branchTitles,
    };
