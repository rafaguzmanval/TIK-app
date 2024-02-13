import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import '../../features/bluetooth_scanner.dart';

class BluetoothStreamBuilder extends StatefulWidget{
  const BluetoothStreamBuilder({super.key});

  @override
  State<BluetoothStreamBuilder> createState() => _BluetoothStreamBuilderState();

}

class _BluetoothStreamBuilderState extends State<BluetoothStreamBuilder>{

  late BluetoothScanner bluetoothScanner;

  List<String> devices = [];
  //late DiscoveredDevice connectedDevice;

  @override
  void initState(){
    super.initState();
    bluetoothScanner = BluetoothScanner();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return /*StreamBuilder(
      stream: bluetoothScanner.devicesStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error: ${snapshot.error}');
        }
        
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }



        if (snapshot.data is BluetoothDiscoveryResult) {
          BluetoothDiscoveryResult result = snapshot.data;

          devices.add(result.device.address);

          return Column(
              children: [
                Container(
                  // We must to set height and width in order to prevent errors
                  // with listView dimensions
                  width: 200,
                  height: 300,
                  child: BluetoothTile(devices:devices, name: result.device.address),
                ),
                ElevatedButton(
                    onPressed: () {},
                    child: Text("Refrescar")
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Salir")
                )
              ]
          );
        }

        return Center(child: CircularProgressIndicator());
      }
    );*/
     Center(child: CircularProgressIndicator());
  }

  Widget BluetoothTile({required List devices, required String name}){
    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.bluetooth),
          title: Text(name),
          onTap: () {

          },
        );
      },
    );
  }
}
