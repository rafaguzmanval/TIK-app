import 'package:flutter/material.dart';
import 'package:tree_timer_app/constants/utils.dart';
import 'package:tree_timer_app/features/auth_service.dart';
import '../common/widgets/custom_button.dart';
import '../common/widgets/custom_textformfield.dart';

class Register extends StatefulWidget{
  const Register({super.key, required this.title});
  static const String route = '/register';

  final String title;

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register>
{
  final AuthService authService = AuthService();
  // Use for fields validators
  final _registrationFormKey = GlobalKey<FormState>();

  final TextEditingController _nameController = new TextEditingController();
  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();

  // Create function that send textfields values to server
  void registerUser(){
    authService.registerUser(
      context: context,
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text
    );
  }

  @override void dispose(){
    super.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.all(50),
        child: Center(
          child: Form(
            key: _registrationFormKey,
            child: ListView(
              children: [
                CustomTextField(controller: _nameController, labelText: "Nombre"),
                SizedBox(height: 15),
                CustomTextField(controller: _emailController, labelText: "Email"),
                SizedBox(height: 15),
                CustomTextField(controller: _passwordController, labelText: "Contraseña", isPassword: true,),
                SizedBox(height: 15),
                CustomTextField(controller: _confirmPasswordController, labelText: "Confirmar contraseña", isPassword: true,),
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
                        registerUser();
                      } 
                    }
                  ),
                ),
              ],
            )
          ),
        )
      ),
    );
  }

}