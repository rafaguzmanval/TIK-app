import 'dart:async';
//import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';


// Bluetooth scanner class that allows to update a device list and 
// listen to bluetooth devices
class BluetoothScanner{

  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;

  BluetoothState get bluetoothState => _bluetoothState;

  StreamController devicesStream = StreamController();

  BluetoothScanner(){
        _getBTState();
        _stateChangeListened();
        getPairedDevices();
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


    devicesStream.addStream(FlutterBluetoothSerial.instance.startDiscovery());

  }

  void getPairedDevices() async{
    print("Getting paired devices");
    List<BluetoothDevice> devices = await FlutterBluetoothSerial.instance.getBondedDevices();
    devices.forEach((element) {
      devicesStream.add(element);

    });
  }

}
