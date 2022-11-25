import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class BluetoothPrinterHandler {
  final _bluetooth = BlueThermalPrinter.instance;
  bool _connected = false;
  BluetoothDevice? _currentConnectedDevice;

  BluetoothPrinterHandler(){
    _initListener();
  }

  void _initListener() {
    _bluetooth.onStateChanged().listen((state) {
      debugPrint('*****************************BLE STATE $state***********************');
      switch(state){
        case BlueThermalPrinter.CONNECTED:
          _connected = true;
          break;
        default:
          _connected = false;
          break;
      }
    });
  }

  Future<bool> isBluetoothOn() async{
   final result =  await _bluetooth.isOn;
   if(result == null || !result){
     return false;
   }else{
     return true;
   }
  }

  Future<List<BluetoothDevice>> getDevices() async {
    try {
      return await _bluetooth.getBondedDevices();
    } on PlatformException {
      return [];
    }
  }

  Future<bool> isConnected() async{
    bool? isConnected = await _bluetooth.isConnected;
    if(isConnected != null){
      if(isConnected && _connected){
        return true;
      }
    }
    debugPrint('*****************************BLE IS CONNECTED $isConnected***********************');
    return false;
  }

  Future<bool> connect(BluetoothDevice device) async{
    bool? isConnected = await _bluetooth.isConnected;
    if(isConnected!){
      await _bluetooth.disconnect();
    }
    try{
      await _bluetooth.connect(device).timeout(const Duration(seconds: 4));
      _currentConnectedDevice = device;
      _connected = true;
      debugPrint('*****************************BLE CONNECTED***********************');
    }on PlatformException catch(e){
      _connected == false;
      debugPrint('*****************************BLE ERROR $e***********************');
    }
    return _connected;
  }
}
