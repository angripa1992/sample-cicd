import 'dart:convert';
import 'dart:ui';

import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:klikit/app/app_preferences.dart';

import 'language.dart';

class LanguageManager {
  final AppPreferences _appPreferences;
  final _languages = <Language>[];
  final _fallbackLocale = const Locale('en','US');

  LanguageManager(this._appPreferences);

  Future<List<Language>> _fetchLanguages() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      // await remoteConfig.setConfigSettings(
      //   RemoteConfigSettings(
      //     fetchTimeout: const Duration(seconds: 30),
      //     minimumFetchInterval: const Duration(seconds: 0),
      //   ),
      // );
      await remoteConfig.fetchAndActivate();
      final rawData = remoteConfig.getValue('languages').asString();
      print(rawData);
      final List<dynamic> data = jsonDecode(rawData);
      final languages = data.map((e) => Language.fromJson(e)).toList();
      return languages;
    } catch (exception) {
      //ignored
      print(exception);
    }
    return [];
  }

  Future<List<Language>> getSupportedLanguages() async {
    if (_languages.isEmpty) {
      final remoteLanguages = await _fetchLanguages();
      _languages.addAll(remoteLanguages);
    }
    return _languages;
  }

  Future<List<Locale>> getSupportedLocale() async {
    if (_languages.isEmpty) {
      final remoteLanguages = await _fetchLanguages();
      _languages.addAll(remoteLanguages);
    }
    final supportedLocales =  _languages.map((e) => makeLocaleFromLanguage(e)).toList();
    if(supportedLocales.isEmpty){
      return [_fallbackLocale];
    }
    return supportedLocales;
  }

  Future<Locale> getStartLocale() async {
    print(_languages.length);
   try{
     final currentLanguage = _languages.firstWhere((element) => element.code == _appPreferences.languageCode());
     return makeLocaleFromLanguage(currentLanguage);
   }catch (e){
     return _fallbackLocale;
   }
  }

  String currentLanguageCode() {
    return _appPreferences.languageCode();
  }

  Future<void> saveCurrentLanguageCode(String languageCode) {
    return _appPreferences.saveLanguageCode(languageCode);
  }

  Locale makeLocaleFromLanguage(Language language) {
    return Locale(language.code!, language.countryCode);
  }
}
