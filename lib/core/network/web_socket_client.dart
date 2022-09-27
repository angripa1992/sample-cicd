import 'package:flutter/foundation.dart';
import 'package:klikit/app/app_preferences.dart';
import 'package:web_socket_channel/io.dart';

class WebSocketClient {
  final AppPreferences _appPreferences;
  IOWebSocketChannel? _webSocketChannel;

  WebSocketClient(this._appPreferences);

  void createWebSocketChannel() {
    _webSocketChannel = IOWebSocketChannel.connect(
      Uri.parse('wss://socket.dev.shadowchef.co/socket.io/?token=${_appPreferences.retrieveAccessToken()}&EIO=3&transport=websocket'),
    );
  }

  void startListening() {
    _webSocketChannel?.stream.listen(
      (data) {
        debugPrint("==========WebSocket Response===============");
        print(data);
      },
      onError: (error) {
        debugPrint("==========WebSocket Error===============");
        print(error);
      },
    );
  }

  void closeWebSocketChannel() {
    _webSocketChannel?.sink.close();
  }
}
