class ItemBrandRequestModel {
  int? id;
  String? logo;
  String? title;

  ItemBrandRequestModel({this.id, this.logo, this.title});

  Map<String, dynamic> toJsonV1() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['logo'] = logo;
    data['title'] = title;
    return data;
  }

  Map<String, dynamic> toJsonV2() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    return data;
  }
}