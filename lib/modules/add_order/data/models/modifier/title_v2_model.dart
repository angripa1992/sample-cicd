class MenuItemTitleV2Model {
  String? en;

  MenuItemTitleV2Model({this.en});

  MenuItemTitleV2Model.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['en'] = en;
    return data;
  }
}
