import 'package:flutter/material.dart';
import 'package:klikit/printer/data/printer_setting.dart';

abstract class PrinterHandler {
  String title();

  IconData icon();

  int type();

  Future<List<T>> getDevices<T>();

  Future<bool> connect({LocalPrinter? localPrinter,required bool isFromBackground,required bool showMessage});

  Future<bool> disconnect(LocalPrinter? localPrinter, bool isFromBackground);

  Future<bool> print({required List<int> data, required LocalPrinter? localPrinter, required bool isFromBackground});
}
