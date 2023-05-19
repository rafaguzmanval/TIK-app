import 'dart:async';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:permission_handler/permission_handler.dart';


// Bluetooth scanner class that allows to update a device list and 
// listen to bluetooth devices
class BluetoothScanner{

  final devicesList = <DiscoveredDevice>[];
  final List<Uuid> _uuids = [];
  final _flutterReactiveBle = FlutterReactiveBle();

  // StreamController y StreamSubscription
  StreamController<List<DiscoveredDevice>> _devicesStreamController = StreamController<List<DiscoveredDevice>>.broadcast();
  StreamSubscription<DiscoveredDevice>? _devicesSubscription;

  // Stream getter
  Stream<List<DiscoveredDevice>> get devicesStream => _devicesStreamController.stream;

  Future<void> requestLocationPermission() async {
  if (await Permission.location.request().isGranted) {
    // Location permission has been granted
      return;
    }
    
    // If permission are not granted, they are requested
    final result = await Permission.location.request();
    if (result.isGranted) {
      // If permissions are granted
    } else {
      // If permissions are not granted
    }
  }

  // Refresh the device list, this makes the scanner stop scanning, clean the device
  // list an start scanning again 
  void refreshDeviceList() async{
      stopScan();
      devicesList.clear();
      startScan();
  }

  void stopScan() {
    // Cancel stream subscription
    _devicesSubscription?.cancel();
  }

  // Method to start scanning
  void startScan() {

    // Request permissions
    requestLocationPermission();
    
    // If a previous stream subscription exist we must cancel it
    _devicesSubscription?.cancel();

    _devicesSubscription = _flutterReactiveBle.scanForDevices(withServices: _uuids).listen(
      (device) {
        // Add or update devices inside list
        final knownDeviceIndex = devicesList.indexWhere((d) => d.id == device.id);

        if (knownDeviceIndex >= 0) {
          devicesList[knownDeviceIndex] = device;
        } else {
          devicesList.add(device);
        }
        // Add to the updated list to the StreamController
        _devicesStreamController.add(devicesList);
      },
      onError: (error) {
        print('Device scan fails with error: $error');
      },
    );
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
    Stream<ConnectionStateUpdate> _currentConnectionStream = _flutterReactiveBle.connectToAdvertisingDevice(
      id: _foundDeviceId,
      withServices: [],
      prescanDuration: const Duration(seconds: 10),
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
          case DeviceConnectionState.connecting:
          {
            print("ME ESTOY CONECTANDO A DISPOSITIVO ${_foundDeviceId}");
            break;
          }
          case DeviceConnectionState.disconnecting:
            // TODO: Handle this case.
            break;
          case DeviceConnectionState.disconnected:
            // TODO: Handle this case.
            break;
        } 
        
      }, onError: (dynamic error) {
        print('Error connecting to device $_foundDeviceId: $error');      }
    );

  }
}
