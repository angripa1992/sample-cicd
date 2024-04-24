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
  SocketHandler(this._tokenProvider,this._printerManager,this._orderRepository){
    player.setVolume(1.0);
  }

  void onStart() {
    final env = getIt.get<EnvironmentVariables>();
    final socket = io.io(
      env.socketUrl,
      io.OptionBuilder().setTransports(['websocket']).enableAutoConnect().setQuery({
        'token': _tokenProvider.getAccessToken(),
        // 'EIO':'3'
      }).build(),
    );
    try {
      // print("init socket handler $token");
      // Periodically send a ping to keep the WebSocket connection alive
      Timer.periodic(const Duration(seconds: 20), (timer) {
        socket.emit('ping', []);
      });
      // Connecting to Socket.IO server
      socket.connect();

      socket.onConnectError((data) => {
        Future.delayed(const Duration(seconds: 2), () async {
          onStart();
        })
      });

      socket.on('order_placed', (data) async {
        // print('Received event data order_placed: $data');
        Order? order = await _orderRepository.fetchOrderById(getOrderIdFromKlikitEvent(data));

        _printerManager.doAutoDocketPrinting(order: order!, isFromBackground: true);
        await player.play(AssetSource(AppSounds.aNewOrder));


      });
      socket.on('tpp_order_placed', (data) async{
        // print('Received event data tpp_order_placed: $data');
        Order? order = await _orderRepository.fetchOrderById(getOrderIdFromProviderEvent(data));
        _printerManager.doAutoDocketPrinting(order: order!, isFromBackground: true);
        await player.play(AssetSource(AppSounds.aNewOrder));

      });

      socket.on('order_cancelled', (data) async{
        // print('Received event data order_cancelled: $data');
        await player.play(AssetSource(AppSounds.aCancelOrder));
      });

    } catch (e) {
      print("socker error $e");
      rethrow;
    }
  }
  int getOrderIdFromKlikitEvent(Map<String, dynamic> json) {
    return json['id'];
  }
  int getOrderIdFromProviderEvent(List<dynamic> json) {
    return json[0]['id'];
  }
}
