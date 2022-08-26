import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () async{
           // final restClient = getIt.get<RestClient>();
            //restClient.request('/brand', Method.GET, null).then((value) => debugPrint("Result ok"));
           // restClient.request('/brand', Method.GET, null).then((value) => debugPrint("Result ok"));
          //  restClient.request('/brand', Method.GET, null).then((value) => debugPrint("Result ok"));
          },
          child: Text('Test Api'),
        ),
      ),
    );
  }
}
