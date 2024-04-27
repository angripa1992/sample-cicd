import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:klikit/core/network/token_provider.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:klikit/resources/assets.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../app/di.dart';
import '../../env/environment_variables.dart';
import '../../modules/orders/domain/entities/order.dart';
import '../../printer/printer_manager.dart';

class SocketHandler {
  final TokenProvider _tokenProvider;
  final PrinterManager _printerManager;
  final OrderRepository _orderRepository;
  final player = AudioPlayer();

  late io.Socket socket;
  bool isConnecting =
      false; // Flag to prevent reconnecting while already trying

  SocketHandler(
      this._tokenProvider, this._printerManager, this._orderRepository) {
    player.setVolume(1.0);
  }

  void initializeSocket() {
    final env = getIt.get<EnvironmentVariables>();
    // Initialize the socket connection
    socket = io.io(
      env.socketUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect() // Disable auto-connect
          .setQuery({
            'token': _tokenProvider.getAccessToken(),
          })
          .build(),
    );

    socket.onConnect((_) {
      print('Socket connected');
    });

    socket.onConnectError((error) {
      print('Socket connection error: $error');
      _handleSocketError();
    });

    socket.onDisconnect((_) {
      print('Socket disconnected');
      _handleSocketError();
    });

    socket.on('order_placed', (data) async {
      // print('Received event data order_placed: $data');
      Order? order = await _orderRepository
          .fetchOrderById(getOrderIdFromKlikitEvent(data));

      _printerManager.doAutoDocketPrinting(
          order: order!, isFromBackground: true);
      await player.play(AssetSource(AppSounds.aNewOrder));
    });
    socket.on('tpp_order_placed', (data) async {
      // print('Received event data tpp_order_placed: $data');
      Order? order = await _orderRepository
          .fetchOrderById(getOrderIdFromProviderEvent(data));
      _printerManager.doAutoDocketPrinting(
          order: order!, isFromBackground: true);
      await player.play(AssetSource(AppSounds.aNewOrder));
    });

    socket.on('order_cancelled', (data) async {
      // print('Received event data order_cancelled: $data');
      await player.play(AssetSource(AppSounds.aCancelOrder));
    });

    // Connect to the socket manually
    _connectSocket();
  }

  void _connectSocket() {
    if (!socket.connected && !isConnecting) {
      isConnecting = true; // Set flag to prevent multiple connection attempts
      socket.connect();
      isConnecting = false; // Reset flag after connecting
    }
  }

  void _handleSocketError() {
    // Handle socket connection errors here
    // Implement logic to retry connection or handle accordingly
    // Example: Retry connection after a delay
    Future.delayed(const Duration(seconds: 5), () {
      _connectSocket();
    });
  }

  int getOrderIdFromKlikitEvent(Map<String, dynamic> json) {
    return json['id'];
  }

  int getOrderIdFromProviderEvent(List<dynamic> json) {
    return json[0]['id'];
  }
}
