class ModifierRuleModel {
  int? id;
  String? title;
  String? typeTitle;
  int? value;
  int? brandId;
  int? min;

  ModifierRuleModel({
    this.id,
    this.title,
    this.typeTitle,
    this.value,
    this.brandId,
    this.min,
  });

  ModifierRuleModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    typeTitle = json['type_title'];
    value = json['value'];
    brandId = json['brand_id'];
    min = json['min'];
  }
}
