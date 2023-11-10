import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:permission_handler/permission_handler.dart';


// Bluetooth scanner class that allows to update a device list and 
// listen to bluetooth devices
class BluetoothScannerFlutterBluePlus{

  final devicesList = <BluetoothDevice>[];
  // final List<Uuid> _uuids = [];
  final _flutterBluePlus = FlutterBluePlus.instance;

  // StreamController y StreamSubscription
  StreamController<List<BluetoothDevice>> _devicesStreamController = StreamController<List<BluetoothDevice>>.broadcast();
  StreamSubscription<List<ScanResult>>? _devicesSubscription;

  // Stream getter
  Stream<List<BluetoothDevice>> get devicesStream => _devicesStreamController.stream;

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
      // stopScan();
      await  _flutterBluePlus.stopScan();
      devicesList.clear();
      startScan();
  }

  void stopScan() async{
    // Cancel stream subscription
    await _flutterBluePlus.stopScan();
    _devicesSubscription?.cancel();
  }

  // Method to start scanning
  void startScan() {

    // Request permissions
    requestLocationPermission();
    
    // If a previous stream subscription exist we must cancel it
    _devicesSubscription?.cancel();

    _flutterBluePlus.startScan();

    _devicesSubscription = _flutterBluePlus.scanResults.listen(
      (results) {
        for (ScanResult result in results) {
          // Add or update devices inside list
          final knownDeviceIndex = devicesList.indexWhere((d) => d.id == result.device.id);

          if (knownDeviceIndex >= 0) {
            devicesList[knownDeviceIndex] = result.device;
          } else {
            devicesList.add(result.device);
          }
          // Add to the updated list to the StreamController
          _devicesStreamController.add(devicesList);
          
        }
      },
      onError: (error) {
        print('Device scan fails with error: $error');
      },
    );
  }

  // Takes the discoverd device [_discoveredDevice] and returns his name or MAC if it is
  // name it is empty
  String getMacIfLocalNameIsEmpty(BluetoothDevice _bluetoothDevice){
    if(_bluetoothDevice.name.isEmpty)
    {
      return _bluetoothDevice.id.toString();
    }
    else{
      return _bluetoothDevice.name.toString();
    }
  }

  // void connectToDevice(_foundDeviceId){
  //   Stream<ConnectionStateUpdate> _currentConnectionStream = _flutterBluePlus. .connectToDevice(
  //     id: _foundDeviceId,
  //     servicesWithCharacteristicsToDiscover: {},
  //     // prescanDuration: const Duration(seconds: 10),
  //     connectionTimeout: const Duration(seconds:  2),
  //   );
  //   _currentConnectionStream.listen((event) {
  //       // Handle connection state updates
  //       switch(event.connectionState){
  //         case DeviceConnectionState.connected:
  //         {
  //           print("ME HE CONECTADO A DISPOSITIVO ${_foundDeviceId}");
  //           break;
  //         }
  //         case DeviceConnectionState.connecting:
  //         {
  //           print("ME ESTOY CONECTANDO A DISPOSITIVO ${_foundDeviceId}");
  //           break;
  //         }
  //         case DeviceConnectionState.disconnecting:
  //           // TODO: Handle this case.
  //           break;
  //         case DeviceConnectionState.disconnected:
  //           // TODO: Handle this case.
  //           break;
  //       } 
        
  //     }, onError: (dynamic error) {
  //       print('Error connecting to device $_foundDeviceId: $error');      }
  //   );

  // }
}
