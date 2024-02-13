import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tree_inspection_kit_app/common/widgets/bluetooth_streambuilder.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:tree_inspection_kit_app/features/bluetooth_scanner.dart';

class BluetoothSimpleDialog extends StatefulWidget
{

  BluetoothSimpleDialog({
    Key? key,
  }) : super(key:key);

  @override
  State<BluetoothSimpleDialog> createState() => _BluetoothSimpleDialogState();
}

class _BluetoothSimpleDialogState extends State<BluetoothSimpleDialog> {

  late final String title;
  late BluetoothScanner scanner;

  @override
  void initState() {
    super.initState();

    scanner = BluetoothScanner();

  }
  
  // Init dialog title
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    title = "${AppLocalizations.of(context)!.selectBluetoothDevice}: ";
  }

  @override
  Widget build(BuildContext context) {

    return SimpleDialog(
      title: Text(this.title),
      contentPadding: const EdgeInsets.all(10.0),
      titlePadding: const EdgeInsets.all(20.0),

      children: [
        SingleChildScrollView(
          // child: BluetoothStreamBuilderFlutterBluePlus(),
          child: Column(children: [
            /*SwitchListTile(title: Text("Enciende el bluetooth"),
                value: scanner.bluetoothState.isEnabled,
                onChanged: (bool value) { _switchBluetooth(value);})*/BluetoothStreamBuilder()
          ],),
        ),
      ],
    );
  }


  void _switchBluetooth(bool value) async{

      if(value) {
        await scanner.enable();
      } else {
        await scanner.disable();
      }

      setState(() {

      });
  }
}