import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final bool isPassword;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.isPassword = false,
  }) : super(key:key);


  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // If it's a password field obscure text = true
      obscureText: isPassword ? true : false,
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
      ),
      validator: (val) {
        String hintTextLowerCase = labelText.toLowerCase();
        if(val == null || val.isEmpty) {
          return 'Introduce tu $hintTextLowerCase';
        }
        return null;
      },
    );
  }
}