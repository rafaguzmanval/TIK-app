import 'package:flutter/material.dart';
import 'package:tree_timer_app/common/widgets/custom_button.dart';
import 'package:tree_timer_app/common/widgets/custom_textformfield.dart';

class Login extends StatefulWidget {
  const Login({super.key, required this.title});

  final String title;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        margin: EdgeInsets.all(50),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomTextField(controller: _emailController, hintText: "Email"),
              SizedBox(height: 15),
              CustomTextField(controller: _passwordController, hintText: "Contraseña"),
              SizedBox(height: 35),
              Container(
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: CustomButton(text: "Login", textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), route: "/home"),
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
      ),
    );
  }
}