import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:klikit/core/route/routes.dart';
import 'package:klikit/resources/strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: (){
            Navigator.of(context).pushNamed(Routes.contactSupport);
          },
          child: Text(AppStrings.contact_support.tr()),
        ),
      ),
    );
  }
}
