class ItemBrandModel {
  int? id;
  String? logo;
  String? title;

  ItemBrandModel({this.id, this.logo, this.title});

  ItemBrandModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    logo = json['logo'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['logo'] = logo;
    data['title'] = title;
    return data;
  }
}