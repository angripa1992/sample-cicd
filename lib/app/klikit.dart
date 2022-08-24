import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class Klikit extends StatelessWidget {
  const Klikit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}
