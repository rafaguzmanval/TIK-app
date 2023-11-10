import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:tree_inspection_kit_app/features/bluetooth_scanner_flutter_blue_plus.dart';
import '../../features/bluetooth_scanner.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BluetoothStreamBuilderFlutterBluePlus extends StatefulWidget{
  const BluetoothStreamBuilderFlutterBluePlus({super.key});

  @override
  State<BluetoothStreamBuilderFlutterBluePlus> createState() => _BluetoothStreamBuilderState();

}

class _BluetoothStreamBuilderState extends State<BluetoothStreamBuilderFlutterBluePlus>{

  BluetoothScannerFlutterBluePlus bluetoothScannerFlutterBluePlus = new BluetoothScannerFlutterBluePlus();
  late BluetoothDevice connectedDevice;
  bool isConnected = false;

  void checkConnectionStatus() {
    if (connectedDevice != null) {
      connectedDevice.state.listen((state) {
        if (state == BluetoothDeviceState.connected) {
          isConnected = true;
          print('Estás conectado al dispositivo Bluetooth.');
        } else {
          isConnected = false;
          print('No estás conectado al dispositivo Bluetooth.');
        }
      });
    }
  }

  void disconnectDeviceIfConnected() async {
    if (connectedDevice != null) {
      await connectedDevice.disconnect();
    }
  }

  @override
  void initState(){
    super.initState();
    bluetoothScannerFlutterBluePlus.startScan();
  }

  @override
  void dispose() {
    bluetoothScannerFlutterBluePlus.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      // stream: bluetoothScanner.devicesStream,
      stream: bluetoothScannerFlutterBluePlus.devicesStream,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        if (snapshot.hasError) {
          print(snapshot.error);
          return Text('Error: ${snapshot.error}');
        }
        
        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }

        // DEBUG
        // for(var device in bluetoothScanner.devicesList)
        for(var device in bluetoothScannerFlutterBluePlus.devicesList)
        {
          // print('${bluetoothScanner.devicesList.length} rssi ${device.rssi} mac ${bluetoothScanner.getMacIfLocalNameIsEmpty(device)}');
          print('${bluetoothScannerFlutterBluePlus.devicesList.length} mac ${bluetoothScannerFlutterBluePlus.getMacIfLocalNameIsEmpty(device)}');
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
                // itemCount: bluetoothScanner.devicesList.length,
                itemCount: bluetoothScannerFlutterBluePlus.devicesList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.bluetooth),
                    title: Text(bluetoothScannerFlutterBluePlus.getMacIfLocalNameIsEmpty(bluetoothScannerFlutterBluePlus.devicesList[index])),
                    // subtitle: Text('RSSI: ${bluetoothScannerFlutterBluePlus.devicesList[index].rssi.toString()}'),
                    onTap: () async {
                      // Código para conectarse al dispositivo Bluetooth seleccionado
                      connectedDevice = bluetoothScannerFlutterBluePlus.devicesList[index];
                      
                      disconnectDeviceIfConnected();
                      await connectedDevice.connect();

                      // isConnected = true;
                      // Lee una característica específica del dispositivo
                      List<BluetoothService> services = await connectedDevice.discoverServices();
                      BluetoothCharacteristic desiredCharacteristic;

                      for (BluetoothService service in services) {
                        print(service);
                        // for (BluetoothCharacteristic characteristic in service.characteristics) {
                        //   if(characteristic != null){
                        //     List<int> value = await characteristic.read();
                        //     print(value);
                        //   }
                        //   if (characteristic.uuid == Guid('0x180f') || characteristic.uuid == Guid('0x180F')) {
                        //     desiredCharacteristic = characteristic;
                        //     print("Servicio encontrado");
                        //     break;
                        //   }
                        // }
                      }
                    },
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: (){
                bluetoothScannerFlutterBluePlus.refreshDeviceList();
              },
              child: Text(AppLocalizations.of(context)!.refresh)
            ),
            ElevatedButton(
              onPressed: (){
                Navigator.pop(context);
              },
              child: Text(AppLocalizations.of(context)!.exit)
            )
          ]
        );
      }
    );
  }
}
