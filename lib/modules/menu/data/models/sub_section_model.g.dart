// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_section_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubSectionsModel _$SubSectionsModelFromJson(Map<String, dynamic> json) =>
    SubSectionsModel(
      id: json['id'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      enabled: json['enabled'] as bool?,
      hidden: json['hidden'] as bool?,
      alcBeverages: json['alc_beverages'] as bool?,
      statuses: (json['statuses'] as List<dynamic>?)
          ?.map((e) => StatusesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      sequence: json['sequence'] as int?,
      titleV2: json['title_v2'] == null
          ? null
          : TitleV2Model.fromJson(json['title_v2'] as Map<String, dynamic>),
      descriptionV2: json['description_v2'] == null
          ? null
          : DescriptionV2Model.fromJson(
              json['description_v2'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>?)
          ?.map((e) => ItemsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SubSectionsModelToJson(SubSectionsModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'enabled': instance.enabled,
      'hidden': instance.hidden,
      'alc_beverages': instance.alcBeverages,
      'statuses': instance.statuses,
      'sequence': instance.sequence,
      'title_v2': instance.titleV2,
      'description_v2': instance.descriptionV2,
      'items': instance.items,
    };
