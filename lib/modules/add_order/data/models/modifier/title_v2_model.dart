class AddOrderTitleV2Model {
  String? en;

  AddOrderTitleV2Model({this.en});

  AddOrderTitleV2Model.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['en'] = en;
    return data;
  }
}