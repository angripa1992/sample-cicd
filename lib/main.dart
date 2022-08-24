import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klikit/app/klikit.dart';
import 'package:klikit/environment_variables.dart';
import 'package:klikit/resources/assets.dart';

import 'app/di.dart';

void mainCommon(EnvironmentVariables environmentVariables) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initAppModule();

  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  ).then(
    (_) => runApp(
      EasyLocalization(
        path: AppAssets.translations,
        supportedLocales: const [Locale('en', 'US')],
        fallbackLocale: const Locale('en', 'US'),
        child: const Klikit(),
      ),
    ),
  );
}
