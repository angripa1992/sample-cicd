import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:klikit/core/route/routes_generator.dart';

import '../../modules/widgets/snackbars.dart';

class NetworkConnectivity {
  final _networkConnectivity = Connectivity();
  bool _isFirst = true;

  NetworkConnectivity() {
    _init();
  }

  void _init() async {
    await _networkConnectivity.checkConnectivity();
    _networkConnectivity.onConnectivityChanged.listen(
      (result) {
        _checkStatus();
      },
    );
  }

  void _checkStatus() {
    hasConnection().then(
      (isOnline) {
        BuildContext? currentContext = RoutesGenerator.navigatorKey.currentState?.context;
        if (isOnline) {
          if (currentContext != null && !_isFirst) {
            showConnectivitySnackBar(currentContext,true);
          }
        } else {
          if (currentContext != null) {
            showConnectivitySnackBar(currentContext,false);
          }
        }
        print('---------is online $isOnline ------------is first $_isFirst');
        _isFirst = false;
      },
    );
  }

  Future<bool> hasConnection() async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      isOnline = false;
    }
    return isOnline;
  }
}
