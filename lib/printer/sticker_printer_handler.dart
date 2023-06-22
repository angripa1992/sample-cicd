import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class StickerPrinterHandler {
  static final StickerPrinterHandler _instance = StickerPrinterHandler._internal();
  static final FlutterBluePlus _flutterBlue = FlutterBluePlus.instance;
  BluetoothDevice? _connectedDevice;

  factory StickerPrinterHandler() => _instance;

  StickerPrinterHandler._internal();

  Stream<List<ScanResult>> scanDevices(){
    try{
      if(_flutterBlue.isScanningNow){
        _flutterBlue.stopScan().then((value) {
          _flutterBlue.startScan(timeout: const Duration(seconds: 10));
        });
      }else{
        _flutterBlue.startScan(timeout: const Duration(seconds: 10));
      }
    }catch (e){
      //ignore
    }
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
}
