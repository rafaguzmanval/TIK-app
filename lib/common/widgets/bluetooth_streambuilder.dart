import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import '../../features/bluetooth_scanner.dart';

class BluetoothStreamBuilder extends StatefulWidget{
  const BluetoothStreamBuilder({super.key});

  @override
  State<BluetoothStreamBuilder> createState() => _BluetoothStreamBuilderState();

}

class _BluetoothStreamBuilderState extends State<BluetoothStreamBuilder>{

  BluetoohScanner bluetoohScanner = new BluetoohScanner();
  late DiscoveredDevice connectedDevice;

  @override
  void initState(){
    super.initState();
    bluetoohScanner.startScan();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bluetoohScanner.bluetoothStreamController.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }

        bluetoohScanner.updateDevicesList();

        // DEBUG
        for(var device in bluetoohScanner.devicesList)
        {
          print('${bluetoohScanner.devicesList.length} rssi ${device.rssi} mac ${bluetoohScanner.getMacIfLocalNameIsEmpty(device)}');
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
                itemCount: bluetoohScanner.devicesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.bluetooth),
                    title: Text(bluetoohScanner.getMacIfLocalNameIsEmpty(bluetoohScanner.devicesList[index])),
                    subtitle: Text('RSSI: ${bluetoohScanner.devicesList[index].rssi.toString()}'),
                    onTap: () {
                      // Código para conectarse al dispositivo Bluetooth seleccionado
                      connectedDevice = bluetoohScanner.devicesList[index];
                      bluetoohScanner.connectToDevice(connectedDevice.id);
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: (){
                bluetoohScanner.refreshDeviceList();
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
