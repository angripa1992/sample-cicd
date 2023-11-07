import 'package:klikit/app/session_manager.dart';

class MenuItemModifierRuleModel {
  int? id;
  String? title;
  String? typeTitle;
  int? value;
  int? brandId;
  int? min;
  int? max;

  MenuItemModifierRuleModel({
    this.id,
    this.title,
    this.typeTitle,
    this.value,
    this.brandId,
    this.min,
    this.max,
  });

  MenuItemModifierRuleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    typeTitle = json['type_title'];
    value = json['value'];
    brandId = json['brand_id'];
    min = json['min'];
    max = json['max'];
  }

  Map<String, dynamic> toJsonV1() {
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

  Map<String, dynamic> toJsonV2() {
    final Map<String, dynamic> data = {};
    data['min'] = min;
    data['max'] = max;
    return data;
  }

  Map<String, dynamic> toWebShopJson() {
    final isV2 = SessionManager().menuV2Enabled();
    if (isV2) {
      final Map<String, dynamic> data = {};
      data['min'] = min;
      data['max'] = max;
      data['type_title'] = min == max ? 'exact' : 'range';
      return data;
    } else {
      return toJsonV1();
    }
  }
}
