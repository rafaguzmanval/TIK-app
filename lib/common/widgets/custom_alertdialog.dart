import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CustomAlertDialog extends StatefulWidget
{
  final String title;
  String? hintText = DateFormat('yyyy_MM_dd').format(DateTime.now()).toString();

  CustomAlertDialog({
    Key? key,
    required this.title,
  }) : super(key:key);

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {

  final _textController = TextEditingController();

  @override
  void initState(){
   
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return AlertDialog(
      title: Text(widget.title),
      content: TextFormField(
        controller: _textController,
        decoration: InputDecoration(hintText: widget.hintText),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Crear'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}