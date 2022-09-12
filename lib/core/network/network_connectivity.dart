import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:klikit/core/route/routes_generator.dart';

import '../../modules/widgets/snackbars.dart';

class NetworkConnectivity {
  final _networkConnectivity = Connectivity();
  bool _isFirstTime = true;

  NetworkConnectivity() {
    _init();
  }

  void _init() async {
    await _networkConnectivity.checkConnectivity();
    _checkStatus();
    _networkConnectivity.onConnectivityChanged.listen(
      (result) {
        print('===============listener called $result');
        if(result == ConnectivityResult.none){
          _showNoInternetSnackbar();
        }else{
          _checkStatus();
        }
      },
    );
  }

  void _checkStatus() {
    hasConnection().then(
      (isOnline) {
        if (isOnline && !_isFirstTime) {
         _showOnlineSnackbar();
        } else {
          _showNoInternetSnackbar();
        }
        print('---------is online $isOnline ----------- is first time $_isFirstTime');
        _isFirstTime = false;
      },
    );
  }

  void _showNoInternetSnackbar(){
    BuildContext? currentContext = RoutesGenerator.navigatorKey.currentState?.context;
    if (currentContext != null) {
      showConnectivitySnackBar(currentContext,false);
    }
  }

  void _showOnlineSnackbar(){
    BuildContext? currentContext = RoutesGenerator.navigatorKey.currentState?.context;
    if (currentContext != null) {
      showConnectivitySnackBar(currentContext,true);
    }
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
