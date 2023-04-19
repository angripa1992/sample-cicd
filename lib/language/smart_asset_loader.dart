import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/di.dart';
import 'package:klikit/app/extensions.dart';
import 'package:path_provider/path_provider.dart' as paths;

import '../environment_variables.dart';

class SmartAssetLoader extends AssetLoader {
  final _envVariables = getIt.get<EnvironmentVariables>();
  final _localCacheDuration = const Duration(days: 1);

  @override
  Future<Map<String, dynamic>?> load(String path, Locale locale) async {
    String localeName = '${locale.languageCode}-${locale.countryCode}';
    String content = EMPTY;

    if (await _localTranslationExists(localeName)) {
      content = await _loadFromLocalFile(localeName);
      debugPrint('translations loaded from local');
    }

    if (content.isEmpty) {
      content = await _loadFromNetwork(localeName);
      debugPrint('translations loaded from network');
    }

    if (content.isEmpty) {
      content = await _loadFromAsset(path, localeName);
      debugPrint('translations loaded from assets');
    }

    return _decodeJson(content);
  }

  Future<bool> _localTranslationExists(String localeName) async {
    final translationFile = await _getFileForLocale(localeName);
    if (!await translationFile.exists()) {
      return false;
    }
    final difference =
        DateTime.now().difference(await translationFile.lastModified());
    if (difference > _localCacheDuration) {
      return false;
    }
    return true;
  }

  Future<String> _loadFromLocalFile(String localeName) async {
    return await (await _getFileForLocale(localeName)).readAsString();
  }

  Future<String> _loadFromAsset(String assetsPath, String localeName) async {
    return await rootBundle.loadString('$assetsPath/$localeName.json');
  }

  Future<String> _loadFromNetwork(String localeName) async {
    final url = '${_envVariables.cdnUrl}/language/nma/$localeName.json';
    try {
      Response<List<int>> response = await Dio().get(
        url,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
        ),
      );
      final content = utf8.decode(response.data!);
      if (_decodeJson(content) != null) {
        await _saveTranslation(localeName, content);
        return content;
      }
    } catch (e) {
      //ignored
    }
    return EMPTY;
  }

  Future<void> _saveTranslation(String localeName, String content) async {
    var file = File(await _getFilenameForLocale(localeName));
    await file.create(recursive: true);
    await file.writeAsString(content);
  }

  Future<String> get _localPath async {
    final directory = await paths.getTemporaryDirectory();
    return directory.path;
  }

  Future<String> _getFilenameForLocale(String localeName) async {
    return '${await _localPath}/translations/$localeName.json';
  }

  Future<File> _getFileForLocale(String localeName) async {
    return File(await _getFilenameForLocale(localeName));
  }

  Map<String, dynamic>? _decodeJson(String content) {
    return json.decode(content);
  }
}
