import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tree_timer_app/common/widgets/custom_button.dart';
import 'package:tree_timer_app/common/widgets/custom_textformfield.dart';
import 'package:tree_timer_app/features/auth_service.dart';
import 'package:tree_timer_app/providers/user_provider.dart';
import 'package:rive/rive.dart';


class Login extends StatefulWidget {
  const Login({super.key});
  static const String route = '/';
  static const String title = "Login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final AuthService authService = AuthService();
  final _loginFormKey = GlobalKey<FormState>();

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  void loginUser(){
    authService.loginUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Login.title),
      ),
      body: Container(
        margin: EdgeInsets.all(50),
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  width: 250,
                  height: 250,
                  child: RiveAnimation.asset("assets/rive/tree.riv", fit: BoxFit.cover,))
                // RiveAnimation.asset("assets/rive/tree.riv", fit: BoxFit.cover,)
                // RiveAnimation.asset("tree.riv")
              ],
            ),
            Form(
              key: _loginFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomTextField(controller: _emailController, hintText: "Email"),
                  SizedBox(height: 15),
                  CustomTextField(controller: _passwordController, hintText: "Contraseña", isPassword: true,),
                  SizedBox(height: 35),
                  Container(
                    width: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: CustomButton(
                      text: "Login",
                      textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      onTap: (){
                        if(_loginFormKey.currentState!.validate()) {
                          loginUser();
                        } 
                      },
                    ),
                  ),
                  SizedBox(height: 35),
                  GestureDetector(
                    onTap:(){
                      Navigator.pushNamed(context, '/register');
                    },
                    child: const Text("¿Nuevo usuario? Cree una cuenta")
                  ),
                ],
              ),
            ),
          ] 
        ),
      ),
    );
  }
}