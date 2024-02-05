import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
import 'package:klikit/core/route/routes_generator.dart';
import 'package:klikit/modules/widgets/snackbars.dart';

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
    } else {
      showErrorSnackBar(RoutesGenerator.navigatorKey.currentState!.context, connect.msg);
    }
  }
}
