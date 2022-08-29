import 'package:get_it/get_it.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:klikit/core/network/network_connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/network/rest_client.dart';
import '../core/network/token_provider.dart';
import '../environment_variables.dart';

final getIt = GetIt.instance;

Future<void> initAppModule(EnvironmentVariables environmentVariables) async {
  getIt.registerSingleton<EnvironmentVariables>(environmentVariables);
  getIt.registerSingleton<SharedPreferences>(
    await SharedPreferences.getInstance(),
  );
  getIt.registerSingleton<AppPreferences>(AppPreferences(getIt()));
  getIt.registerSingleton<TokenProvider>(TokenProvider(getIt()));
  getIt.registerSingleton<RestClient>(RestClient(getIt()));
  getIt.registerSingleton<NetworkConnectivity>(NetworkConnectivity());
}
