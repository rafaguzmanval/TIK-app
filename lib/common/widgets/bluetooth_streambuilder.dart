import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:flutter_reactive_ble/src/device_scanner.dart';

class BluetoothStreamBuilder extends StatefulWidget{
  const BluetoothStreamBuilder({super.key});

  @override
  State<BluetoothStreamBuilder> createState() => _BluetoothStreamBuilderState();

}

class _BluetoothStreamBuilderState extends State<BluetoothStreamBuilder>{

  StreamController bluetoothStreamController = StreamController.broadcast();
  final devicesList = <DiscoveredDevice>[];
  final List<Uuid> uuids = [];
  bool isScanning = false;
  final flutterReactiveBle = FlutterReactiveBle();

  void refreshDeviceList() async{
    // We should check if a scan it's already running
    if (isScanning){
      stopScan();
      devicesList.clear();
    }else{
      startScan(uuids);
    }
  }

  void startScan(List<Uuid> serviceIds){

    if(!isScanning)
    {
      isScanning = true;
      bluetoothStreamController.addStream(flutterReactiveBle.scanForDevices(withServices: uuids));
    }
  }

  Future stopScan() async{

    if(isScanning)
    {
      isScanning = false;
    }
  }

  String getMacIfLocalNameIsEmpty(DiscoveredDevice _discoveredDevice){
    if(_discoveredDevice.name.isEmpty)
    {
      return _discoveredDevice.id.toString();
    }
    else{
      return _discoveredDevice.name.toString();
    }
  }

  @override
  void initState(){
    super.initState();
    isScanning = false;
    startScan(uuids);
  }

  @override
  void dispose() {
    devicesList.clear();
    super.dispose();
  }

  void handleDevicesList(StreamController _bluetoothStreamController){
    _bluetoothStreamController.stream.listen((device) {
      final knownDeviceIndex = devicesList.indexWhere((d) => d.id == device.id);

      if (knownDeviceIndex >= 0) {
        devicesList[knownDeviceIndex] = device;
      } else {
        devicesList.add(device);
      }
    }, onError: (Object e) => print('Device scan fails with error: $e'));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bluetoothStreamController.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }

        handleDevicesList(bluetoothStreamController);

        // DEBUG
        for(var device in devicesList)
        {
          print('${devicesList.length} ${device.rssi} mac ${getMacIfLocalNameIsEmpty(device)}');
        }
        //
        return Column(
          children: [
            Container(
              // We must to set height and width in order to prevent errors
              // with listView dimensions
              width: 200,
              height: 300,
              child: ListView.builder(
                itemCount: devicesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.bluetooth),
                    title: Text(getMacIfLocalNameIsEmpty(devicesList[index])),
                    subtitle: Text('RSSI: ${devicesList[index].rssi.toString()}'),
                    onTap: () {
                      // Código para conectarse al dispositivo Bluetooth seleccionado
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: (){
                refreshDeviceList();
              },
              child: Text("Refrescar")
            ),
            ElevatedButton(
              onPressed: (){
                dispose();
                Navigator.pop(context);
              },
              child: Text("Salir")
            )
          ]
        );
      }
    );
  }
}
