class TitleV2Model {
  String? en;

  TitleV2Model({this.en});

  TitleV2Model.fromJson(Map<String, dynamic> json) {
    en = json['en'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['en'] = en;
    return data;
  }
}
