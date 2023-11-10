import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CustomPasswordFormField extends StatefulWidget
{

  final TextEditingController controller;
  final ValueChanged<bool>? onVisibilityPressed;
  final bool editing;
  final bool isConfirmPassword;

  CustomPasswordFormField({
    Key? key,
    required this.controller,
    this.onVisibilityPressed, required this.editing, this.isConfirmPassword = false
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
        labelText: widget.editing ? widget.isConfirmPassword ? AppLocalizations.of(context)!.confirmNewPassword : AppLocalizations.of(context)!.newPassword : widget.isConfirmPassword ? AppLocalizations.of(context)!.confirmPassword : AppLocalizations.of(context)!.password,
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