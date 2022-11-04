// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'items_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemsModel _$ItemsModelFromJson(Map<String, dynamic> json) => ItemsModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      prices: (json['prices'] as List<dynamic>?)
          ?.map((e) => PricesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      vat: json['vat'] as int?,
      description: json['description'] as String?,
      image: json['image'] as String?,
      enabled: json['enabled'] as bool?,
      hidden: json['hidden'] as bool?,
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => StatusesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sequence: json['sequence'] as int?,
      defaultItemId: json['default_item_id'] as int?,
      stock: json['stock'] == null
          ? null
          : StockModel.fromJson(json['stock'] as Map<String, dynamic>),
      titleV2: json['title_v2'] == null
          ? null
          : TitleV2Model.fromJson(json['title_v2'] as Map<String, dynamic>),
      descriptionV2: json['description_v2'] == null
          ? null
          : DescriptionV2Model.fromJson(
              json['description_v2'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemsModelToJson(ItemsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'prices': instance.prices,
      'vat': instance.vat,
      'description': instance.description,
      'image': instance.image,
      'enabled': instance.enabled,
      'hidden': instance.hidden,
      'statuses': instance.statuses,
      'sequence': instance.sequence,
      'stock': instance.stock,
      'default_item_id': instance.defaultItemId,
      'title_v2': instance.titleV2,
      'description_v2': instance.descriptionV2,
    };
