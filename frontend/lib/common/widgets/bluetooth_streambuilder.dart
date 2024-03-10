import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
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

  List<BluetoothDevice> devices = [];
  //late DiscoveredDevice connectedDevice;

  @override
  void initState(){
    bluetoothScanner = BluetoothScanner();
    super.initState();


  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bluetoothScanner.devicesStream.stream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error: ${snapshot.error}');
        }
        
        if(!snapshot.hasData){
          return const Center(child: CircularProgressIndicator());
        }



        if (snapshot.data is BluetoothDevice) {

          BluetoothDevice device = snapshot.data;

          devices.add(device);

          print(device.name);

          return Column(
              children: [
                Container(
                  // We must to set height and width in order to prevent errors
                  // with listView dimensions
                  width: 200,
                  height: 300,
                  child: BluetoothTile(devices:devices),
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
    );
     //Center(child: CircularProgressIndicator());
  }

  Widget BluetoothTile({required List<BluetoothDevice> devices}){


    return ListView.builder(
      itemCount: devices.length,
      itemBuilder: (context, index) {

        String? name = devices[index].name;
        return ListTile(
          leading: Icon(Icons.bluetooth),
          title: Text(name!),
          onTap: () async {

            print(devices[index].address);
            BluetoothConnection conn = await BluetoothConnection.toAddress(devices[index].address);

            //StreamController inputControl = StreamController();
            //Stream<Uint8List>? blueStream = ;

            conn.input?.listen((event) {

              String s = String.fromCharCodes(event);

              if(s == "hi")
                {
                  Navigator.pop(context);
                }
              else
                {
                  print(s);
                }
              //conn.output.add(utf8.encode("DISESELO"));


            });

          },
        );
      },
    );
  }
}
