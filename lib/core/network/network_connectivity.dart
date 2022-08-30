import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkConnectivity{
  final _networkConnectivity = Connectivity();
  final StreamController<bool> _controller = StreamController.broadcast();
  Stream<bool> get connectivityStream => _controller.stream;

  void init() async{
    await _networkConnectivity.checkConnectivity();
    _checkStatus();
    _networkConnectivity.onConnectivityChanged.listen((result) {
     _checkStatus();
    });
  }

  void _checkStatus() async{
    final isOnline = await hasConnection();
    _controller.sink.add(isOnline);
  }

  Future<bool> hasConnection() async{
    bool isOnline = false;
    try{
      final result = await InternetAddress.lookup('google.com');
      isOnline = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    }on SocketException catch (_){
      isOnline = false;
    }
    return isOnline;
  }

  void disposeConnectivityStream() => _controller.close();
}