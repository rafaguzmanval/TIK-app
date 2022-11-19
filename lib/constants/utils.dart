import "package:flutter/material.dart";

void showSnackBar(BuildContext context, String text){
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    )
  );
}

bool compareStr(String text1, String Text2){
  print(text1 + Text2);
  return text1 == Text2 ? true : false;
}
