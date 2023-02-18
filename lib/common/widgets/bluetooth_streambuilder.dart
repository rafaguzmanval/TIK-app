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

  BluetoothScanner bluetoothScanner = new BluetoothScanner();
  late DiscoveredDevice connectedDevice;

  @override
  void initState(){
    super.initState();
    bluetoothScanner.startScan();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bluetoothScanner.devicesStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error: ${snapshot.error}');
        }
        
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }

        // DEBUG
        for(var device in bluetoothScanner.devicesList)
        {
          print('${bluetoothScanner.devicesList.length} rssi ${device.rssi} mac ${bluetoothScanner.getMacIfLocalNameIsEmpty(device)}');
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
                itemCount: bluetoothScanner.devicesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.bluetooth),
                    title: Text(bluetoothScanner.getMacIfLocalNameIsEmpty(bluetoothScanner.devicesList[index])),
                    subtitle: Text('RSSI: ${bluetoothScanner.devicesList[index].rssi.toString()}'),
                    onTap: () {
                      // Código para conectarse al dispositivo Bluetooth seleccionado
                      connectedDevice = bluetoothScanner.devicesList[index];
                      bluetoothScanner.connectToDevice(connectedDevice.id);
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: (){
                bluetoothScanner.refreshDeviceList();
              },
              child: Text("Refrescar")
            ),
            ElevatedButton(
              onPressed: (){
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
