import "dart:convert";

import "package:flutter/material.dart";
import "package:tree_timer_app/models/valid_response.dart";

void showSnackBar(BuildContext context, String text){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    )
  );
}

bool compareStr(String text1, String Text2){
  return text1 == Text2 ? true : false;
}

Future<bool?> showConfirmDialog(BuildContext context, String title, String content) async {
  return await showDialog<bool>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text('Aceptar'),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}

String returnResponseMessage(ValidResponse res)
{
  String ret = "";
  dynamic jsonResponse = jsonDecode(res.body);
    if(jsonResponse["msg"] != "")
      ret = jsonResponse["msg"];

  return ret;
}

String? mandatoryField(value) {
    if (value == null || value.isEmpty) {
      return 'Este campo es obligatorio';
    }
    return null;
  }