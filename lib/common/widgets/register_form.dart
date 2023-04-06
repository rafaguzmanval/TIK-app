import 'package:flutter/material.dart';
import 'package:tree_timer_app/common/widgets/custom_button.dart';
import 'package:tree_timer_app/common/widgets/custom_passwordformfield.dart';
import 'package:tree_timer_app/common/widgets/custom_textformfield.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/features/auth_service.dart';

class RegisterForm extends StatefulWidget{

  final AuthService authService;
  
  RegisterForm({
    Key? key,
    required this.authService,
  }) : super(key:key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm>{
  
  // Use for fields validators
  final _registrationFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(60))
      ),
      child: FractionallySizedBox(
        heightFactor: 0.6,
        child: Container(
          height: double.infinity,
          width: 310,
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _registrationFormKey,
            child: ListView(
              padding: EdgeInsets.all(20),
              children: [
                Center(child: Text("Registro", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                SizedBox(height: 15),
                CustomTextField(controller: _nameController, labelText: "Nombre"),
                SizedBox(height: 15),
                CustomTextField(controller: _emailController, labelText: "Email"),
                SizedBox(height: 15),
                CustomPasswordFormField(controller: _passwordController),
                SizedBox(height: 15),
                CustomPasswordFormField(controller: _confirmPasswordController),
                SizedBox(height: 35),
                Container(
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  // ignore: prefer_const_constructors
                  child: CustomButton(
                    text: "Crear cuenta",
                    textStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    onTap: (){
                      if(_registrationFormKey.currentState!.validate() && compareStr(_passwordController.text, _confirmPasswordController.text)) {
                        widget.authService.registerUser(context: context,name: _nameController.text,
                          email: _emailController.text,password: _passwordController.text);
                      } 
                    }
                  ),
                ),
                Container(
                  height: double.minPositive,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: -65,
                        child: CircleAvatar(radius: 16, backgroundColor: Colors.grey.shade100, child: Icon(Icons.close),)
                      ),
                    ]
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

}
