import 'dart:async';
//import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


// Bluetooth scanner class that allows to update a device list and 
// listen to bluetooth devices
class BluetoothScanner{

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  BluetoothState get bluetoothState => _bluetoothState;

  late Stream devicesStream ;

  BluetoothScanner(){
        _getBTState();
        _stateChangeListened();
        discover();
  }

  _getBTState() async {
     _bluetoothState = await FlutterBluetoothSerial.instance.state;
  }

  _stateChangeListened(){
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
          _bluetoothState = state;
          print("State isEnabled : ${state.isEnabled}");
    });
  }

  Future<bool?> enable() async{
    return FlutterBluetoothSerial.instance.requestEnable();
  }

  Future<bool?> disable() async{
    return FlutterBluetoothSerial.instance.requestDisable();
  }

  void discover() async{
    List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();

    devices.map((e) => e.name).toList().forEach(print);


  }

}
