class Language {
  int? id;
  String? title;
  String? code;
  String? countryCode;

  Language({this.id, this.title, this.code, this.countryCode});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    code = json['code'];
    countryCode = json['country_code'];
  }
}