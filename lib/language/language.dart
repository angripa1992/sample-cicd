import 'package:klikit/app/extensions.dart';
import 'package:klikit/resources/asset_resolver/image_resource.dart';
import 'package:klikit/resources/asset_resolver/svg_image_resource.dart';
import 'package:klikit/resources/resource_resolver.dart';

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

  List<ImageResource> getFlagResources() {
    List<ImageResource> list = [];
    if (countryCode.isNotNullOrEmpty()) {
      switch (countryCode) {
        case 'US':
          list.add(SVGImageResource('$iconBasePath/ic_flag_US.svg'));
          break;
        case 'ID':
          list.add(SVGImageResource('$iconBasePath/ic_flag_ID.svg'));
          break;
        case 'CHS':
          list.add(SVGImageResource('$iconBasePath/ic_flag_CN.svg'));
          break;
        case 'TW':
          list.add(SVGImageResource('$iconBasePath/ic_flag_CN.svg'));
          list.add(SVGImageResource('$iconBasePath/ic_flag_TW.svg'));
          break;
        case 'TH':
          list.add(SVGImageResource('$iconBasePath/ic_flag_TH.svg'));
          break;
        case 'JP':
          list.add(SVGImageResource('$iconBasePath/ic_flag_JP.svg'));
          break;
        default:
          break;
      }
    }
    return list;
  }
}

class AppLanguage {
  static const int ENGLISH = 1;
  static const int BAHASA = 2;
  static const int CHINESE_S = 3;
  static const int CHINESE_T = 4;
  static const int THAI = 5;
}
