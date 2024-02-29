import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class WifiPrinterPlugin {
  static const MethodChannel _channel =
  MethodChannel('io.klikit.enterprise.klikit_enterprise_app/WifiPrinterPlugin');

  static Future<void> printData(String? ipAddress, List<int> data) async {
    try {
      await _channel.invokeMethod('printData', {
            'ip': ipAddress,
            'data': data,
          });
    } catch (e) {
      print("Error invoking method: $e");
    }
  }
}