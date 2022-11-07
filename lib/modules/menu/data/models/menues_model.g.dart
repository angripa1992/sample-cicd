// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'menues_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MenusDataModel _$MenusDataModelFromJson(Map<String, dynamic> json) =>
    MenusDataModel(
      sections: (json['sections'] as List<dynamic>?)
          ?.map((e) => SectionsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$MenusDataModelToJson(MenusDataModel instance) =>
    <String, dynamic>{
      'sections': instance.sections,
    };
