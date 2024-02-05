import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';

class NetworkPrinterHandler {

  static final NetworkPrinterHandler _instance = NetworkPrinterHandler._internal();

  factory NetworkPrinterHandler() => _instance;

  NetworkPrinterHandler._internal();

  Future<void> doPrint(List<int> data, String printerAddress) async {
    final printer = PrinterNetworkManager(printerAddress);
    PosPrintResult connect = await printer.connect();
    if (connect == PosPrintResult.success) {
      await printer.printTicket(data);
      printer.disconnect();
    }else{
      print("no network found");
    }
  }
}
