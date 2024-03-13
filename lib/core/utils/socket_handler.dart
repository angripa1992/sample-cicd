import 'dart:async';
import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:klikit/core/network/token_provider.dart';
import 'package:klikit/modules/orders/domain/repository/orders_repository.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

import '../../modules/orders/domain/entities/order.dart';
import '../../printer/network_printer_handler.dart';
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
    final socket = io.io(
      'wss://connect.klikit.io',
      io.OptionBuilder().setTransports(['websocket']).enableAutoConnect().setQuery({
        // 'token':'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhaWQiOiJjMjNkZmI4MC0zNTE2LTQ4OGEtOTE4Zi1hY2Q4MTM4ZjgzM2YiLCJleHAiOjE3MDk4ODEyMjgsInJpZCI6IjcxYzQxMWRlLWQ1ODctNDBhYS1hOGRhLWFmYjNiNGQxMTMzNCIsInVpZCI6ODk0fQ.wFP4WpvZeL8VFZ2VreeF8suH0Y4ERWwRbpzkxgHH_qw',
        'token': _tokenProvider.getAccessToken(),
        // 'EIO':'3'
      }).build(),
    );
    try {

      // Periodically send a ping to keep the WebSocket connection alive
      Timer.periodic(Duration(seconds: 30), (timer) {
        socket.emit('ping', []);
      });
      // Connecting to Socket.IO server
      socket.connect();

      socket.onConnectError((data) => {
      print('error $data')
      });

      socket.on('order_placed', (data) async {
        print('Received event data order_placed: ${data}');
        Order? order = await _orderRepository.fetchOrderById(getOrderIdFromKlikitEvent(data));

        await player.play(AssetSource('sounds/new_order.wav'));
        // _printerManager.doAutoDocketPrinting(order: order!, isFromBackground: false);
      });
      socket.on('tpp_order_placed', (data) async{
        print('Received event data tpp_order_placed: $data');
        Order? order = await _orderRepository.fetchOrderById(getOrderIdFromProviderEvent(data));
        await player.play(AssetSource('sounds/new_order.wav'));
        _printerManager.doAutoDocketPrinting(order: order!, isFromBackground: false);
      });

      socket.on('order_cancelled', (data) async{
        print('Received event data order_cancelled: $data');
        await player.play(AssetSource('sounds/cancel_order.wav'));
      });

    } catch (e) {
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
