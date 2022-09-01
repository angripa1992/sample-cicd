import 'dart:io';

import 'package:flutter/material.dart';
import 'package:klikit/app/constants.dart';
import 'package:klikit/resources/colors.dart';
import 'package:klikit/resources/styles.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  bool _isLoading = true;
  final _key = UniqueKey();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      WebView.platform = AndroidWebView();
    }
  }

  @override
  Widget build(BuildContext context) {
    final url = ModalRoute.of(context)!.settings.arguments as String;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          flexibleSpace: getAppBarBackground(),
        ),
        body: Stack(
          children: [
            WebView(
              key: _key,
              initialUrl: url,
              javascriptMode: JavascriptMode.unrestricted,
              onPageFinished: (String url) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
            Visibility(
              visible: _isLoading,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.purpleBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
