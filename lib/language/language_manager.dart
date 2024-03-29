import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/language/selected_locale.dart';

import 'language.dart';

class LanguageManager {
  final AppPreferences _appPreferences;
  final _languages = <Language>[Language.fromJson({"id":1,"title":"English","country_code":"US","code":"en"})];
  final _fallbackLocale = const Locale('en', 'US');
  final _fallbackLanguage = Language(id: 1, title: 'English', code: 'en', countryCode: 'US');

  LanguageManager(this._appPreferences);

  // Future<List<Language>> _fetchLanguages() async {
  // try {
  //   final remoteConfig = FirebaseRemoteConfig.instance;
  //   await remoteConfig.setConfigSettings(
  //     RemoteConfigSettings(
  //       fetchTimeout: const Duration(minutes: 1),
  //       minimumFetchInterval: const Duration(hours: 1),
  //     ),
  //   );
  //   await remoteConfig.fetchAndActivate();
  //   final rawData = remoteConfig.getValue('languages').asString();
  //   final List<dynamic> data = jsonDecode(rawData);
  //   final languages = data.map((e) => Language.fromJson(e)).toList();
  //   return languages;
  // } catch (exception) {
  //   return [_fallbackLanguage];
  // }
  // }

  Future<List<Language>> getSupportedLanguages() async {
    // if (_languages.isEmpty) {
    //   final remoteLanguages = await _fetchLanguages();
    //   _languages.addAll(remoteLanguages);
    // }
    return _languages;
  }

  Future<List<Locale>> getSupportedLocale() async {
    // if (_languages.isEmpty) {
    //   final remoteLanguages = await _fetchLanguages();
    //   _languages.addAll(remoteLanguages);
    // }
    final supportedLocales = _languages.map((e) => makeLocaleFromLanguage(e)).toList();
    if (supportedLocales.isEmpty) {
      return [_fallbackLocale];
    }
    return supportedLocales;
  }

  Future<Locale> getStartLocale() async {
    try {
      final currentLanguage = _languages.firstWhere((element) => element.id == currentLanguageId());
      return makeLocaleFromLanguage(currentLanguage);
    } catch (e) {
      return _fallbackLocale;
    }
  }

  int currentLanguageId() {
    return _appPreferences.language();
  }

  Locale getCurrentLocale() {
    try {
      final currentLanguage = _languages.firstWhere((element) => element.id == currentLanguageId());
      return makeLocaleFromLanguage(currentLanguage);
    } catch (e) {
      return _fallbackLocale;
    }
  }
  Future<void> saveCurrentLanguageCode(int id) {
    return _appPreferences.saveLanguage(id);
  }

  Locale makeLocaleFromLanguage(Language language) {
    return Locale(language.code!, language.countryCode);
  }

  void changeLocale({required BuildContext context, required SelectedLocale selectedLocale}) {
    context.setLocale(selectedLocale.locale);
    saveCurrentLanguageCode(selectedLocale.languageId);
  }
}
