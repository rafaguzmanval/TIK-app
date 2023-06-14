import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:tree_inspection_kit_app/common/widgets/bluetooth_streambuilder.dart';
import 'package:tree_inspection_kit_app/common/widgets/bluetooth_streambuilderflutterblueplus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

      children: const [
        SingleChildScrollView(
          child: BluetoothStreamBuilderFlutterBluePlus(),
        ),
      ],
    );
  }
}