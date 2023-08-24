import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../app/enums.dart';
import '../core/network/public_rest_client.dart';
import 'environment_variables.dart';

class EnvManager {
  static final EnvManager _instance = EnvManager._internal();

  factory EnvManager() => _instance;

  EnvManager._internal();

  Future<EnvironmentVariables> fetchEnv(EnvironmentVariables env) async {
    final remoteConfigEnv = await _fetchEnvFromRemoteConfig();
    final mainEnv = remoteConfigEnv ?? env;
    final remoteEnvUrls =
        await _fetchRemoteUrls('${mainEnv.baseUrl}/v1/app/settings');
    if (remoteEnvUrls != null) {
      mainEnv.baseUrl = remoteEnvUrls.urls?.baseUrl ?? mainEnv.baseUrl;
      mainEnv.cdnUrl = remoteEnvUrls.urls?.cdnUrl ?? mainEnv.cdnUrl;
    }
    return mainEnv;
  }

  Future<EnvironmentVariables?> _fetchEnvFromRemoteConfig() async {
    try {
      final remoteConfig = FirebaseRemoteConfig.instance;
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(minutes: 1),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );
      await remoteConfig.fetchAndActivate();
      final rawData = remoteConfig.getValue('env').asString();
      final data = jsonDecode(rawData);
      return EnvironmentVariablesModel.fromJson(data).toEntity();
    } catch (e) {
      return null;
    }
  }

  Future<EnvRemoteUrls?> _fetchRemoteUrls(String url) async {
    try {
      final response = await PublicRestClient().request(
        url,
        Method.GET,
        null,
      );
      return EnvRemoteUrls.fromJson(response);
    } on DioException {
      return null;
    }
  }
}
