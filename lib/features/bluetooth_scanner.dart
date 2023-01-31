import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';

// Bluetooth scanner class that allows to update a device list and 
// listen to bluetooth devices
class BluetoohScanner{
  StreamController bluetoothStreamController = StreamController.broadcast();
  final devicesList = <DiscoveredDevice>[];
  final List<Uuid> uuids = [];
  bool isScanning = false;
  final flutterReactiveBle = FlutterReactiveBle();

  // Refresh the device list, this makes the scanner stop scanning, clean the device
  // list an start scanning again 
  void refreshDeviceList() async{
    // We should check if a scan it's already running
    if (isScanning){
      stopScan();
      devicesList.clear();
    }else{
      startScan();
    }
  }

  // Starts scanning but checking if it is not scanning already
  void startScan() {
    if(!isScanning)
    {
      isScanning = true;
      bluetoothStreamController.addStream(flutterReactiveBle.scanForDevices(withServices: uuids));
    }
  }

  // change the value of boolean
  void stopScan() {

    if(isScanning)
    {
      isScanning = false;
    }
  }

  // Using the stream of a controller [_bluetoothController] it will listen and
  // add or update the listened devices to the devices list
  void updateDevicesList(){
    bluetoothStreamController.stream.listen((device) {
      final knownDeviceIndex = devicesList.indexWhere((d) => d.id == device.id);

      if (knownDeviceIndex >= 0) {
        devicesList[knownDeviceIndex] = device;
      } else {
        devicesList.add(device);
      }
    }, onError: (Object e) => print('Device scan fails with error: $e'));
  }

  // Takes the discoverd device [_discoveredDevice] and returns his name or MAC if it is
  // name it is empty
  String getMacIfLocalNameIsEmpty(DiscoveredDevice _discoveredDevice){
    if(_discoveredDevice.name.isEmpty)
    {
      return _discoveredDevice.id.toString();
    }
    else{
      return _discoveredDevice.name.toString();
    }
  }

  void connectToDevice( _foundDeviceId){
    Stream<ConnectionStateUpdate> _currentConnectionStream = flutterReactiveBle.connectToAdvertisingDevice(
      id: _foundDeviceId,
      withServices: [],
      prescanDuration: const Duration(seconds: 5),
      connectionTimeout: const Duration(seconds:  2),
    );
    _currentConnectionStream.listen((event) {
        // Handle connection state updates
        switch(event.connectionState){
          case DeviceConnectionState.connected:
          {
            print("ME HE CONECTADO A DISPOSITIVO ${_foundDeviceId}");
            break;
          }
        } 
        
      }, onError: (dynamic error) {
      // Handle a possible error
      }
    );

  }
}