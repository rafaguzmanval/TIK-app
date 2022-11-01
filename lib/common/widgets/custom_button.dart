import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final String route;

  const CustomButton({Key? key,
    required this.text,
    required this.textStyle,
    required this.route}) : super(key:key);


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text(text, style: textStyle,),
      onPressed: (){
        Navigator.pushNamed(context, route);
      },
    );
  }
}