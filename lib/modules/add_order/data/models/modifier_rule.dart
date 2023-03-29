import 'package:klikit/app/extensions.dart';
import 'package:klikit/modules/add_order/domain/entities/modifier_rule.dart';

class ModifierRuleModel {
  int? id;
  String? title;
  String? typeTitle;
  int? value;
  int? brandId;
  int? min;
  int? max;

  ModifierRuleModel({
    this.id,
    this.title,
    this.typeTitle,
    this.value,
    this.brandId,
    this.min,
    this.max,
  });

  ModifierRuleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    typeTitle = json['type_title'];
    value = json['value'];
    brandId = json['brand_id'];
    min = json['min'];
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['title'] = title;
    data['type_title'] = typeTitle;
    data['value'] = value;
    data['brand_id'] = brandId;
    data['min'] = min;
    data['max'] = max;
    return data;
  }

  ModifierRule toEntity() {
    return ModifierRule(
      id: id.orZero(),
      title: title.orEmpty(),
      typeTitle: typeTitle.orEmpty(),
      value: value.orZero(),
      brandId: brandId.orZero(),
      min: min.orZero(),
      max: max.orZero(),
    );
  }
}
