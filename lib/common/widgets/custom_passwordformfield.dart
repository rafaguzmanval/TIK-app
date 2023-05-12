import 'package:flutter/material.dart';

class CustomPasswordFormField extends StatefulWidget
{

  final TextEditingController controller;
  final ValueChanged<bool>? onVisibilityPressed;
  final bool editing;

  CustomPasswordFormField({
    Key? key,
    required this.controller,
    this.onVisibilityPressed, required this.editing,
  }) : super(key:key);


  @override
  _CustomPasswordFormField createState() => _CustomPasswordFormField(); 
}

class _CustomPasswordFormField extends State<CustomPasswordFormField>
{
  bool hideText = true;
  
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: hideText,
      decoration: InputDecoration(
        labelText: widget.editing ? 'Nueva contraseña' :'Contraseña',
        suffixIcon: IconButton(
          icon: Icon(
            hideText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              hideText = !hideText;
            });
            if(widget.onVisibilityPressed != null){
              widget.onVisibilityPressed!(hideText);
            }
          },          
        ),
      ),
      onTap: () => {
        if(hideText == true && widget.onVisibilityPressed != null)
        {
         widget.onVisibilityPressed!(true)
        }
      },
    );
  }

}