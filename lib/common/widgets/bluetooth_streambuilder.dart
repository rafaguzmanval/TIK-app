import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothStreamBuilder extends StatefulWidget{
  const BluetoothStreamBuilder({super.key});

  @override
  State<BluetoothStreamBuilder> createState() => _BluetoothStreamBuilderState();

}

class _BluetoothStreamBuilderState extends State<BluetoothStreamBuilder>{

  StreamController bluetoothStreamController = StreamController();
  List<ScanResult> devicesList = [];
  bool isScanning = false;
  FlutterBluePlus flutterBluePlus = FlutterBluePlus.instance;

  void refreshDeviceList() async{
  
    // We should check if a scan it's already running
    if (isScanning){
      // Clear device list and stop scanning
      await stopScan();
      devicesList.clear();
    }else{
      await startScan();
    }
  }

  Future stopScan() async{
    isScanning = false;
    flutterBluePlus.stopScan();
  }

  Future startScan() async {
    isScanning = true;
    flutterBluePlus.startScan(timeout: Duration(seconds: 5));
  }

  String getMacIfLocalNameIsEmpty(ScanResult _scanResult){
    if(_scanResult.device.name.isEmpty)
    {
      return _scanResult.device.id.toString();
    }
    else{
      return _scanResult.device.name.toString();
    }
  }

  @override
  void initState(){
    super.initState();
    flutterBluePlus.startScan(timeout: Duration(seconds: 5));
    isScanning = true;
    bluetoothStreamController.addStream(flutterBluePlus.scanResults);
  }

  @override
  void dispose() {
    stopScan();
    // We must close stream controller to void refresh info when widget has been removed
    bluetoothStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bluetoothStreamController.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }

        // DEBUG
        devicesList = snapshot.data;
        for(var device in devicesList)
        {
          print('${devicesList.length} ${device.rssi} mac ${getMacIfLocalNameIsEmpty(device)}');
        }


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