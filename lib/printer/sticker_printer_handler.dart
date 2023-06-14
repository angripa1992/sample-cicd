import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class StickerPrinterHandler {
  static final StickerPrinterHandler _instance = StickerPrinterHandler._internal();
  static final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? _connectedDevice;

  factory StickerPrinterHandler() => _instance;

  StickerPrinterHandler._internal();

  Stream<List<ScanResult>> scanDevices() {
    _flutterBlue.startScan(timeout: const Duration(seconds: 4));
    return _flutterBlue.scanResults.asBroadcastStream();
  }

  Future<bool> isConnected() async{
    final connectedDevices = await _flutterBlue.connectedDevices;
    return _connectedDevice != null && connectedDevices.isNotEmpty;
  }

  Future<bool> connect(BluetoothDevice device) async{
    try{
      final connectedDevices = await _flutterBlue.connectedDevices;
      for (var connectedDevice in connectedDevices) {
        if(connectedDevice.id.id == device.id.id){
          await device.disconnect();
        }
      }
      await device.connect();
      _connectedDevice = device;
      return true;
    }catch (e){
      return false;
    }
  }

  Future print(Uint8List command) async{
    if(await isConnected()){
      try{
        BluetoothCharacteristic? writeCharacteristic;
        List<BluetoothService> services = await _connectedDevice!.discoverServices();
        for (var service in services) {
          for (var characteristic in service.characteristics) {
            if (characteristic.properties.write) {
              writeCharacteristic = characteristic;
            }
          }
        }
        if (writeCharacteristic != null) {
          await writeCharacteristic.write(command);
        }
      }catch (e){
        //ignore
      }
    }
  }

  Uint8List _data(){
    //   String tsplCommands = '''
    //   SIZE 80 mm, 40 mm
    //   GAP 3 mm, 0
    //   SPEED 4
    //   DENSITY 8
    //   DIRECTION 1
    //   REFERENCE 0,0
    //   OFFSET 0 mm
    //   CLS
    //   TEXT 10,10,"TSS24.BF2",0,1,1,"This is a long text"
    //   TEXT 10,40,"TSS24.BF2",0,1,1,"that needs to be printed"
    //   PRINT 1
    // ''';

    // Long text
    String longText = 'This is a long text that needs to be printed on multiple lines.';

    String tslText = "";

    // Split the long text into multiple lines
    List<String> lines = splitTextIntoLines(longText, 20); // Specify the desired line length

    double lineHeight = 30; // Specify the desired line height
    double initialYPosition = 10; // Specify the initial Y position of the text
    for (int i = 0; i < lines.length; i++) {
      double yPosition = initialYPosition + i * lineHeight;
      tslText += '''TEXT 10,$yPosition,"TSS24.BF2",0,1,1,"${lines[i]}"\n''';
    }


    // Prepare TSPL commands with multiline text
    String tsplCommands = '''
    SIZE 80 mm, 40 mm
    GAP 3 mm, 0
    SPEED 4
    DENSITY 8
    DIRECTION 1
    REFERENCE 0,0
    OFFSET 0 mm
    SELFTEST
    PRINT 1
    CLS
  ''';

    // Convert TSPL commands to bytes
    List<int> tsplBytes = utf8.encode(tsplCommands);

    return Uint8List.fromList(tsplBytes);
  }

  List<String> splitTextIntoLines(String text, int lineLength) {
    List<String> lines = [];
    List<String> words = text.split(' ');

    String line = '';
    for (String word in words) {
      if (line.isEmpty) {
        line = word;
      } else {
        String tempLine = '$line $word';
        if (tempLine.length <= lineLength) {
          line = tempLine;
        } else {
          lines.add(line);
          line = word;
        }
      }
    }

    if (line.isNotEmpty) {
      lines.add(line);
    }

    return lines;
  }
}
