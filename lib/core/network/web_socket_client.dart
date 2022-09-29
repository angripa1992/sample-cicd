import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  final AppPreferences _appPreferences;
  WebSocket? _channel;
  StreamController<dynamic> streamController =
      StreamController.broadcast(sync: true);

  WebSocketClient(this._appPreferences);

  initWebSocketConnection() async {
    print("============= ws connecting...");
    _channel = await connectWs();
    print("============= ws connection initialized");
    _channel?.done.then((dynamic _) => _onDisconnected());
    broadcastNotifications();
  }

  broadcastNotifications() {
    _channel?.listen((event) {
      streamController.add(event);
      print("============= ws response $event");
    }, onDone: () {
      print("============= ws connecting aborted");
      initWebSocketConnection();
    }, onError: (e) {
      print('============= ws server error: $e');
      initWebSocketConnection();
    });
  }

  Future<WebSocket> connectWs() async {
    final token = _appPreferences.retrieveAccessToken();
    try {
      return await WebSocket.connect(
          'wss://socket.dev.shadowchef.co/socket.io/?token=$token&transport=websocket');
    } catch (e) {
      print("============= Error! can not connect WS $e");
      await Future.delayed(const Duration(milliseconds: 25000));
      return await connectWs();
    }
  }

  void _onDisconnected() {
    initWebSocketConnection();
  }

  void closeWS(){
    _channel?.close();
  }
}
