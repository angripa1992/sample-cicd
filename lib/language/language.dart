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

class AppLanguage {
  static const int ENGLISH = 1;
  static const int BAHASA = 2;
  static const int CHINESE_S = 3;
  static const int CHINESE_T = 4;
  static const int THAI = 5;
}
