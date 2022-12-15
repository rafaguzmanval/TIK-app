import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothSimpleDialog extends StatefulWidget
{

  BluetoothSimpleDialog({
    Key? key,
  }) : super(key:key);

  @override
  State<BluetoothSimpleDialog> createState() => _BluetoothSimpleDialogState();
}

class _BluetoothSimpleDialogState extends State<BluetoothSimpleDialog> {

  final String title = "Seleccione un dispositivo bluetooth: ";
  final bluetoothStreamController = new StreamController();
  List<ScanResult> devicesList = [];

  FlutterBluePlus flutterBluePlus = FlutterBluePlus.instance;


  @override
  void initState(){
    flutterBluePlus.startScan();
    bluetoothStreamController.addStream(flutterBluePlus.scanResults);
  }

  @override
  void dispose() {
    bluetoothStreamController.close();
    super.dispose();
  }

  String getMacIfLocalNameIsEmpty(ScanResult _scanResult)
  {
    if(_scanResult.device.name.isEmpty)
    {
      return _scanResult.device.id.toString();
    }
    else{
      return _scanResult.device.name.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    
    return SimpleDialog(
      title: Text(this.title),
      contentPadding: const EdgeInsets.all(10.0),
      titlePadding: const EdgeInsets.all(20.0),

      children: [
        SingleChildScrollView(
            child: StreamBuilder(
              stream: bluetoothStreamController.stream,
              builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                if(!snapshot.hasData){
                  return CircularProgressIndicator();
                }

                devicesList = snapshot.data;
                for(var device in devicesList)
                {
                  print('${devicesList.length} ${device.rssi} mac ${getMacIfLocalNameIsEmpty(device)}');
                }

                return Container(
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
                );
              },
            ),
        ),
        ElevatedButton(onPressed: (){}, child: Text("Refrescar")),
        ElevatedButton(onPressed: (){}, child: Text("Salir"))
      ],
    );
  }
}