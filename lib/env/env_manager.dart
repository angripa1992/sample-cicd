import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../app/enums.dart';
import 'environment_variables.dart';

class EnvManager{
  static final EnvManager _instance = EnvManager._internal();
  factory EnvManager() => _instance;
  EnvManager._internal();

  Future<EnvironmentVariables> fetchEnv(Env env) async{
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
  }

}